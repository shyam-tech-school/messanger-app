import 'package:shared_preferences/shared_preferences.dart';

class OnboardStorage {
  static const _key = 'onboard_completed';

  // Returns true if onboarding already completed
  static Future<bool> isCompleted() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getBool(_key) ?? false;
  }

  // Call this user finishes onboarding
  static Future<void> markCompleted() async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(_key, true);
  }
}
