import 'package:flutter/material.dart';
import 'package:mail_messanger/core/services/firebase_messaging_service.dart';
import 'package:mail_messanger/core/utils/app_logger.dart';
import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';
import 'package:mail_messanger/features/profile/domain/usecases/save_user_usecase.dart';

class UserProvder extends ChangeNotifier {
  final SaveUserUsecase saveUserUsecase;
  final FirebaseMessagingService firebaseMessagingService;

  UserProvder(this.saveUserUsecase, this.firebaseMessagingService);

  bool isLoading = false;

  Future<void> onOtpVerified(AppUser user) async {
    try {
      if (isLoading) return;

      isLoading = true;
      notifyListeners();

      // Generate FCM token
      final fcmToken = await firebaseMessagingService.getToken();
      AppLogger.i('[FCM] Token generated: $fcmToken');

      // Create user with FCM token attached
      final userWithToken = AppUser(
        uid: user.uid,
        phone: user.phone,
        phoneHash: user.phoneHash,
        name: user.name,
        photoUrl: user.photoUrl,
        fcmToken: fcmToken,
      );

      await saveUserUsecase(userWithToken);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
