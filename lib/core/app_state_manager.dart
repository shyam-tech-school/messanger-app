import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateManager {
  static const _phoneVerifiedKey = 'phoneVerified';
  static const _profileCompletedKey = 'profileCompleted';

  static Future<bool> getPhoneVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_phoneVerifiedKey) ?? false;
  }

  static Future<bool> getProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_profileCompletedKey) ?? false;
  }

  static Future<void> setPhoneVerified() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_phoneVerifiedKey, true);
  }

  static Future<void> setProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_profileCompletedKey, true);
  }

  static Future<bool> isUserAlreadyResgitered(String uid) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return data.exists;
  }
}
