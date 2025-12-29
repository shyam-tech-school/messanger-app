import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';
import 'package:mail_messanger/features/profile/domain/repositories/i_user_auth_repository.dart';

class SaveUserUsecase {
  final IUserAuthRepository iUserAuthRepository;

  SaveUserUsecase(this.iUserAuthRepository);

  Future<void> call(AppUser user) {
    return iUserAuthRepository.saveUser(user);
  }
}
