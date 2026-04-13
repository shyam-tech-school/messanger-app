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

  @override
  Future<AppUser?> getUser(String uid) {
    return remoteDataSource.getUser(uid);
  }

  @override
  Future<void> updateProfile({
    required String uid,
    required String name,
    String? about,
    String? photoUrl,
  }) {
    return remoteDataSource.updateProfile(
      uid: uid,
      name: name,
      about: about,
      photoUrl: photoUrl,
    );
  }
}
