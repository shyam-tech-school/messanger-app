import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';

abstract class IUserAuthRepository {
  Future<void> saveUser(AppUser user);
  Future<AppUser?> getUser(String uid);
  Future<void> updateProfile({
    required String uid,
    required String name,
    String? about,
    String? photoUrl,
  });
}
