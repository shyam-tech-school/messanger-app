import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mail_messanger/core/utils/app_logger.dart';
import 'package:mail_messanger/features/chat/domain/entities/message_entity.dart';

abstract class ChatRemoteDatasource {
  Future<String> startChat(String currentUserId, String otherUserId);
  Future<void> sendMessage(MessageEntity message);
  Stream<List<MessageEntity>> getMessages(String chatId);
  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String userId);

  // Typing status
  Future<void> setTypingStatus(String chatId, String userId, bool isTyping);
  Stream<bool> streamTypingStatus(String chatId, String userId);

  // Unread count
  Future<void> resetUnreadCount(String chatId, String userId);

  // Delivery status
  Future<void> markMessagesDelivered(String chatId, String receiverId);

  // Delete chat (soft-delete)
  Future<void> deleteChat(String chatId, String currentUserId);

  // Bulk operations
  Future<void> clearAllChats(String userId);
  Future<void> deleteAllChats(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDatasource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Future<String> startChat(String currentUserId, String otherUserId) async {
    final chatId = _getChatId(currentUserId, otherUserId);

    await firestore.collection('chats').doc(chatId).set({
      'chatId': chatId,
      'participants': [currentUserId, otherUserId],
      'participantsMap': {currentUserId: true, otherUserId: true},
      'chatType': "one-to-one",
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return chatId;
  }

  // chat room id generator
  String _getChatId(String currentUserId, String otherUserId) =>
      currentUserId.compareTo(otherUserId) < 0
      ? "${currentUserId}_$otherUserId"
      : "${otherUserId}_$currentUserId";

  // Get messages
  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((e) {
            final data = e.data();
            return MessageEntity(
              chatId: chatId,
              senderId: data['senderId'],
              receiverId: data['receiverId'],
              message: data['message'],
              type: data['type'],
              mediaUrl: data['mediaUrl'],
              createdAt: (data['createdAt'] as Timestamp).toDate(),
              isSeen: (data['isSeen'] as bool?) ?? false,
              isDelivered: (data['isDelivered'] as bool?) ?? false,
            );
          }).toList();
        });
  }

  // Send messages
  @override
  Future<void> sendMessage(MessageEntity message) async {
    final chatRef = firestore.collection('chats').doc(message.chatId);

    // Add message
    await chatRef.collection('messages').add({
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'message': message.message,
      'type': message.type,
      'mediaUrl': message.mediaUrl,
      'isSeen': false,
      'isDelivered': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update chat metadata(summary)
    await chatRef.update({
      'lastMessage': message.message,
      'lastMessageType': message.type,
      'lastMessageSenderId': message.senderId,
      'lastMessageTime': FieldValue.serverTimestamp(),

      // Unread messsage count
      'unreadCount.${message.receiverId}': FieldValue.increment(1),
      'unreadCount.${message.senderId}': 0,

      // Typing reset
      'typing.${message.senderId}': false,
    });
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String userId) {
    return firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  @override
  Future<void> setTypingStatus(
    String chatId,
    String userId,
    bool isTyping,
  ) async {
    AppLogger.i(
      'ChatRemoteDataSource: Setting typing status for $userId in $chatId to $isTyping',
    );
    await firestore
        .collection('chats')
        .doc(chatId)
        .update({'typing.$userId': isTyping})
        .catchError((e) {
          AppLogger.e('ChatRemoteDataSource: Error setting typing status: $e');
        });
  }

  @override
  Stream<bool> streamTypingStatus(String chatId, String userId) {
    return firestore.collection('chats').doc(chatId).snapshots().map((
      snapshot,
    ) {
      final data = snapshot.data();
      final isTyping = (data != null && data['typing'] != null)
          ? data['typing'][userId] ?? false
          : false;
      AppLogger.i(
        'ChatRemoteDataSource: Streamed typing status for $userId in $chatId: $isTyping',
      );
      return isTyping;
    });
  }

  @override
  Future<void> resetUnreadCount(String chatId, String userId) async {
    await firestore.collection('chats').doc(chatId).update({
      'unreadCount.$userId': 0,
    });
  }

  @override
  Future<void> markMessagesDelivered(String chatId, String receiverId) async {
    // Batch-update all undelivered messages sent to this receiver
    final snap = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('receiverId', isEqualTo: receiverId)
        .where('isDelivered', isEqualTo: false)
        .get();

    if (snap.docs.isEmpty) return;

    final batch = firestore.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isDelivered': true});
    }
    await batch.commit();
  }

  @override
  Future<void> deleteChat(String chatId, String currentUserId) async {
    await firestore.collection('chats').doc(chatId).update({
      'participants': FieldValue.arrayRemove([currentUserId]),
      'participantsMap.$currentUserId': FieldValue.delete(),
    });
  }

  @override
  Future<void> clearAllChats(String userId) async {
    final chatsSnap = await firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    for (final chatDoc in chatsSnap.docs) {
      // Delete all messages in the subcollection
      final messagesSnap = await chatDoc.reference
          .collection('messages')
          .get();

      final batch = firestore.batch();
      for (final msgDoc in messagesSnap.docs) {
        batch.delete(msgDoc.reference);
      }
      await batch.commit();

      // Reset chat metadata but keep the chat document
      await chatDoc.reference.update({
        'lastMessage': '',
        'lastMessageType': null,
        'lastMessageSenderId': null,
        'lastMessageTime': null,
        'unreadCount.$userId': 0,
      });
    }
  }

  @override
  Future<void> deleteAllChats(String userId) async {
    final chatsSnap = await firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    for (final chatDoc in chatsSnap.docs) {
      // Delete all messages in the subcollection
      final messagesSnap = await chatDoc.reference
          .collection('messages')
          .get();

      final batch = firestore.batch();
      for (final msgDoc in messagesSnap.docs) {
        batch.delete(msgDoc.reference);
      }
      await batch.commit();

      // Soft-delete: remove user from participants
      await chatDoc.reference.update({
        'participants': FieldValue.arrayRemove([userId]),
        'participantsMap.$userId': FieldValue.delete(),
      });
    }
  }
}
