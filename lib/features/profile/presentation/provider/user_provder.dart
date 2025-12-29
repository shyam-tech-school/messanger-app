import 'package:flutter/material.dart';
import 'package:mail_messanger/core/utils/phone_hash_utils.dart';
import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';
import 'package:mail_messanger/features/profile/domain/usecases/save_user_usecase.dart';

class UserProvder extends ChangeNotifier {
  final SaveUserUsecase saveUserUsecase;

  UserProvder(this.saveUserUsecase);

  Future<void> onOtpVerified({
    required String uid,
    required String name,
    required String phone,
    String? photoUrl,
  }) async {
    final user = AppUser(
      uid: uid,
      phone: phone,
      phoneHash: PhoneHashUtils.hash(phone),
      name: name,
      photoUrl: photoUrl,
    );

    await saveUserUsecase(user);
  }
}
