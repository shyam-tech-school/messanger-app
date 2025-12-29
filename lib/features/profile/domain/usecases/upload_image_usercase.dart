import 'dart:io';

import 'package:mail_messanger/features/profile/domain/repositories/i_profile_repository.dart';

class UploadImageUsercase {
  final IProfileRepository repository;

  UploadImageUsercase(this.repository);

  Future<String> call(File image) {
    return repository.uploadProfileImage(image);
  }
}
