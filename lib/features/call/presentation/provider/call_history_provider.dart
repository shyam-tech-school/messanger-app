import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mail_messanger/features/audio_call/domain/entities/call_entity.dart';
import 'package:mail_messanger/features/call/domain/repositories/call_history_repository.dart';

class CallHistoryProvider extends ChangeNotifier {
  final ICallHistoryRepository callHistoryRepository;

  List<CallEntity> callLogs = [];
  StreamSubscription<List<CallEntity>>? _callLogsSubscription;
  bool isLoading = true;

  CallHistoryProvider(this.callHistoryRepository) {
    _init();
  }

  void _init() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _fetchCallLogs(currentUser.uid);
    } else {
      // Wait for auth state changes if not currently logged in
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          _fetchCallLogs(user.uid);
        } else {
          _callLogsSubscription?.cancel();
          callLogs = [];
          notifyListeners();
        }
      });
    }
  }

  void _fetchCallLogs(String userId) {
    _callLogsSubscription?.cancel();
    isLoading = true;
    notifyListeners();

    _callLogsSubscription = callHistoryRepository.getCallLogs(userId).listen((logs) {
      callLogs = logs;
      isLoading = false;
      notifyListeners();
    }, onError: (error) {
      isLoading = false;
      notifyListeners();
      debugPrint("Error fetching call logs: $error");
    });
  }

  @override
  void dispose() {
    _callLogsSubscription?.cancel();
    super.dispose();
  }
}
