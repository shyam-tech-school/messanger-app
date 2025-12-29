import 'package:flutter/material.dart';
import 'package:mail_messanger/core/utils/app_logger.dart';
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
      if (isLoading) return;

      isLoading = true;
      notifyListeners();

      verificationId = await sendOtpUsecase(phoneNumber);
      AppLogger.i('[OTP]: Verification id: $verificationId');
    } catch (e) {
      error = e.toString();
      AppLogger.e('[OTP] send failed', e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
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
