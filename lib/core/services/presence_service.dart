import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PresenceService with WidgetsBindingObserver {
  static final PresenceService _instance = PresenceService._internal();
  factory PresenceService() => _instance;
  PresenceService._internal();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        debugPrint('PresenceService: User logged in: ${user.uid}');
        _updatePresence(user.uid, true);
        _setupRTDBPresence(user.uid);
      } else {
        debugPrint('PresenceService: No user logged in');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final user = _auth.currentUser;
    if (user == null) return;

    if (state == AppLifecycleState.resumed) {
      _updatePresence(user.uid, true);
    } else {
      _updatePresence(user.uid, false);
    }
  }

  Future<void> _updatePresence(String uid, bool isOnline) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
      debugPrint(
        'PresenceService: Firestore updated for $uid: isOnline=$isOnline',
      );
    } catch (e) {
      debugPrint('PresenceService: Error updating Firestore presence: $e');
    }
  }

  void _setupRTDBPresence(String uid) {
    final presenceRef = _database.ref('presence/$uid');

    _database.ref('.info/connected').onValue.listen((event) {
      final connected = event.snapshot.value == true;
      if (connected) {
        presenceRef.onDisconnect().update({
          'isOnline': false,
          'lastSeen': ServerValue.timestamp,
        });
        presenceRef.update({
          'isOnline': true,
          'lastSeen': ServerValue.timestamp,
        });
      }
    });
  }

  Stream<Map<String, dynamic>> streamUserPresence(String uid) {
    // Return Firestore stream as it's more likely to work
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      return {
        'isOnline': data?['isOnline'] ?? false,
        'lastSeen': data?['lastSeen'] ?? 0,
      };
    });
  }
}
