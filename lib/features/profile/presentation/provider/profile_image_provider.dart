import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mail_messanger/features/profile/domain/usecases/upload_image_usercase.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileImageProvider extends ChangeNotifier {
  final UploadImageUsercase uploadImageUsercase;
  ProfileImageProvider(this.uploadImageUsercase);

  File? _selectedImage;
  bool _isSubmitting = false;

  File? get selectedImage => _selectedImage;
  bool get isSubmitting => _isSubmitting;

  final ImagePicker _imagePicker = ImagePicker();

  // Pick image
  Future<void> pickProfileImage() async {
    final permission = await Permission.photos.request();

    if (!permission.isGranted) {
      throw Exception('Gallery permission denied');
    }

    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedImage == null) return;

    final file = File(pickedImage.path);

    _validateImage(file);
    _selectedImage = file;

    notifyListeners();
  }

  // Validate image
  void _validateImage(File file) {
    final allowedFormats = ['png', 'jpeg', 'jpg'];
    final extension = file.path.split('.').last.toLowerCase();

    if (!allowedFormats.contains(extension)) {
      throw Exception('Only JPG and PNG images are allowed');
    }

    final sizeInBytes = file.lengthSync();
    final sizeInMb = sizeInBytes / (1024 * 1024);

    if (sizeInMb > 5) {
      throw Exception('Image size must be under 5 MB');
    }
  }

  // Upload profile image
  Future<String?> uploadProfileImage() async {
    if (_selectedImage == null) return null;

    _isSubmitting = true;
    notifyListeners();

    try {
      final imageUrl = await uploadImageUsercase.call(_selectedImage!);
      return imageUrl;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
