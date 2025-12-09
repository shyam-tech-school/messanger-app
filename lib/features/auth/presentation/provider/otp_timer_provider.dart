import 'dart:async';

import 'package:flutter/material.dart';

class OtpTimerProvider extends ChangeNotifier {
  static const int otpDuration = 60;
  int _secondsRemaining = otpDuration;
  Timer? _timer;

  int get secondsRemaining => _secondsRemaining;
  bool get isExpired => _secondsRemaining == 0;

  void startTimer() {
    _resetTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        _timer?.cancel();
      } else {
        _secondsRemaining--;
        notifyListeners();
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _secondsRemaining = otpDuration;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
