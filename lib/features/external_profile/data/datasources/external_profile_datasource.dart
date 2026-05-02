import 'package:cloud_firestore/cloud_firestore.dart';

class ExternalProfileDatasource {
  final FirebaseFirestore _firestore;

  ExternalProfileDatasource([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ── Fetch a single user document ──────────────────────────────────────────
  Future<Map<String, dynamic>?> fetchUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists ? doc.data() : null;
  }

  // ── Clear all messages in a chat room ────────────────────────────────────
  /// Batch-deletes every message in chats/{chatId}/messages and resets the
  /// lastMessage / lastMessageTime metadata on the parent chat document.
  Future<void> clearChat(String chatId) async {
    final messagesRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    // Firestore batches are capped at 500 writes — loop until done
    QuerySnapshot snapshot;
    do {
      snapshot = await messagesRef.limit(400).get();
      if (snapshot.docs.isEmpty) break;

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } while (snapshot.docs.length >= 400);

    // Reset chat summary metadata
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': '',
      'lastMessageTime': null,
      'lastMessageType': null,
      'lastMessageSenderId': null,
    });
  }

  // ── Block a user ──────────────────────────────────────────────────────────
  Future<void> blockUser(String currentUserId, String targetUserId) async {
    await _firestore.collection('users').doc(currentUserId).update({
      'blockedUsers': FieldValue.arrayUnion([targetUserId]),
    });
  }

  // ── Unblock a user ────────────────────────────────────────────────────────
  Future<void> unblockUser(String currentUserId, String targetUserId) async {
    await _firestore.collection('users').doc(currentUserId).update({
      'blockedUsers': FieldValue.arrayRemove([targetUserId]),
    });
  }

  // ── Stream of blocked user IDs for the current user ──────────────────────
  Stream<List<String>> streamBlockedUsers(String currentUserId) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .snapshots()
        .map((snap) {
      if (!snap.exists) return <String>[];
      final data = snap.data();
      final raw = data?['blockedUsers'];
      if (raw == null) return <String>[];
      return List<String>.from(raw as List);
    });
  }

  // ── Stream: have I blocked this user? ────────────────────────────────────
  /// Returns true ONLY if the current user has blocked the other user.
  /// This is a plain Firestore snapshot stream — it replays the current
  /// value immediately on subscribe, so it works reliably across navigation.
  ///
  /// WhatsApp-style behavior:
  ///   • If I blocked them  → show "can't send messages" banner (I know I blocked them)
  ///   • If they blocked me → no indication, messages show single tick permanently
  Stream<bool> streamIBlockedThem(String currentUserId, String otherUserId) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .snapshots()
        .map((snap) {
      final raw = snap.data()?['blockedUsers'];
      if (raw == null) return false;
      return (raw as List).contains(otherUserId);
    });
  }

  // ── Fetch full user docs for a list of user IDs ───────────────────────────
  /// Used by the Blocked Contacts screen to get names/photos for each blocked
  /// UID. Returns only existing documents.
  Future<List<Map<String, dynamic>>> fetchUsersByIds(
    List<String> userIds,
  ) async {
    if (userIds.isEmpty) return [];

    // Firestore `whereIn` is limited to 30 items; chunk if needed
    final results = <Map<String, dynamic>>[];
    for (var i = 0; i < userIds.length; i += 30) {
      final chunk = userIds.sublist(
        i,
        (i + 30) > userIds.length ? userIds.length : (i + 30),
      );
      final snap = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final doc in snap.docs) {
        results.add({'uid': doc.id, ...doc.data()});
      }
    }
    return results;
  }
}
