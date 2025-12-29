import 'dart:io';

import 'package:mail_messanger/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:mail_messanger/features/profile/domain/repositories/i_profile_repository.dart';

class ProfileImageRepository implements IProfileRepository {
  final ProfileRemoteDataSoruceImpl remoteDataSource;

  ProfileImageRepository(this.remoteDataSource);

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    return remoteDataSource.uploadProfileImage(imageFile);
  }
}
