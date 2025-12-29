import 'dart:io';

abstract class IProfileRepository {
  Future<String> uploadProfileImage(File imageFile);
}
