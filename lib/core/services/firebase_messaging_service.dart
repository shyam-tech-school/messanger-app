import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import '../../features/audio_call/presentation/services/callkit_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');

  if (message.data['type'] == 'call') {
    final uuid = message.data['uuid'] as String?;
    final callerName = message.data['callerName'] as String? ?? 'Unknown';
    final callerId = message.data['callerId'] as String? ?? 'unknown_id';
    final callerPhoto = message.data['callerPhoto'] as String?;

    CallKitService().showIncomingCall(
      callerName: callerName,
      callerId: callerId,
      callerPhoto: callerPhoto,
      callId: uuid,
    );
  }
}

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');
      if (message.data['type'] == 'call') {
        final uuid = message.data['uuid'] as String?;
        final callerName = message.data['callerName'] as String? ?? 'Unknown';
        final callerId = message.data['callerId'] as String? ?? 'unknown_id';
        final callerPhoto = message.data['callerPhoto'] as String?;

        CallKitService().showIncomingCall(
          callerName: callerName,
          callerId: callerId,
          callerPhoto: callerPhoto,
          callId: uuid,
        );
      }
    });
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
