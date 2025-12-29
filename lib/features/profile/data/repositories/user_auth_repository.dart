import 'package:mail_messanger/features/profile/data/datasources/auth_remote_datasource.dart';
import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';
import 'package:mail_messanger/features/profile/domain/repositories/i_user_auth_repository.dart';

class UserAuthRepository implements IUserAuthRepository {
  final AuthRemoteDatasourceImpl remoteDataSource;

  UserAuthRepository(this.remoteDataSource);

  @override
  Future<void> saveUser(AppUser user) {
    return remoteDataSource.saveUser(user);
  }
}
