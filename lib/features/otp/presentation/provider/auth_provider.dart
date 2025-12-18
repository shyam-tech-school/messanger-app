import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mail_messanger/features/otp/domain/usecases/send_otp_usecase.dart';
import 'package:mail_messanger/features/otp/domain/usecases/verify_otp_usecase.dart';

class OTPAuthProvider extends ChangeNotifier {
  final SendOtpUsecase sendOtpUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;

  OTPAuthProvider({
    required this.sendOtpUsecase,
    required this.verifyOtpUsecase,
  });

  bool isLoading = false;
  String? verificationId;
  String? error;

  Future<void> sendOtp(String phoneNumber) async {
    try {
      isLoading = true;
      notifyListeners();

      verificationId = await sendOtpUsecase(phoneNumber);
      log('[LOG]: OTP Verification id: $verificationId');
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    if (verificationId == null) {
      throw Exception('Verification ID missing');
    }

    isLoading = true;
    notifyListeners();

    try {
      await verifyOtpUsecase(verificationId!, smsCode);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
