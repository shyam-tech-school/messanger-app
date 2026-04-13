import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';
import 'package:mail_messanger/features/profile/domain/repositories/i_user_auth_repository.dart';
import 'package:mail_messanger/features/profile/domain/usecases/upload_image_usercase.dart';

class CurrentUserProvider extends ChangeNotifier {
  final IUserAuthRepository _repository;
  final UploadImageUsercase _uploadImageUsercase;

  CurrentUserProvider(this._repository, this._uploadImageUsercase) {
    _loadUser();
  }

  AppUser? _user;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      _user = await _repository.getUser(uid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => _loadUser();

  /// Update profile: name, about, and optionally a new photo [imageFile].
  Future<void> updateProfile({
    required String name,
    String? about,
    File? imageFile,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      String? newPhotoUrl;
      if (imageFile != null) {
        newPhotoUrl = await _uploadImageUsercase.call(imageFile);
      }

      await _repository.updateProfile(
        uid: uid,
        name: name,
        about: about,
        photoUrl: newPhotoUrl,
      );

      // Optimistically update local state
      _user = _user?.copyWith(
        name: name,
        about: about,
        photoUrl: newPhotoUrl ?? _user?.photoUrl,
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
