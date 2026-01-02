import 'package:flutter/material.dart';
import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';
import 'package:mail_messanger/features/profile/domain/usecases/save_user_usecase.dart';

class UserProvder extends ChangeNotifier {
  final SaveUserUsecase saveUserUsecase;

  UserProvder(this.saveUserUsecase);

  bool isLoading = false;

  Future<void> onOtpVerified(AppUser user) async {
    try {
      if (isLoading) return;

      isLoading = true;
      notifyListeners();

      await saveUserUsecase(user);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
