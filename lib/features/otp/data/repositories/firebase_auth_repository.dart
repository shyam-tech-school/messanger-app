import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mail_messanger/core/utils/app_logger.dart';
import 'package:mail_messanger/features/otp/domain/repositories/i_auth_repository.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository(this._auth);

  @override
  Future<String> sendOtp(String phoneNumber) async {
    final completer = Completer<String>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      verificationCompleted: (credential) {
        _auth.signInWithCredential(credential);
        AppLogger.i('AUTO VERIFIED');
      },

      verificationFailed: (error) {
        AppLogger.e('OTP FAILED: ${error.code} - ${error.message}');
        completer.completeError(Exception(error.message));
      },

      codeSent: (verificationId, _) {
        AppLogger.i('OTP SENT. verificationId: $verificationId');
        completer.complete(verificationId);
      },

      codeAutoRetrievalTimeout: (verificationId) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
        AppLogger.w('AUTO RETRIEVAL TIMEOUT');
      },
    );

    return completer.future;
  }

  @override
  Future<void> verifyOtp(String verificationId, String otp) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    await _auth.signInWithCredential(credential);
  }
}
