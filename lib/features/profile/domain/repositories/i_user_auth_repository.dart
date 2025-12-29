import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';

abstract class IUserAuthRepository {
  Future<void> saveUser(AppUser user);
}
