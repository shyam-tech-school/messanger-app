import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FontSizeOption { small, medium, large }

class FontSizeProvider extends ChangeNotifier {
  static const _key = 'app_font_size';

  FontSizeOption _fontSizeOption = FontSizeOption.medium;

  FontSizeOption get fontSizeOption => _fontSizeOption;

  /// The scale factor applied to the entire app's text via MediaQuery.
  double get textScaleFactor {
    switch (_fontSizeOption) {
      case FontSizeOption.small:
        return 0.85;
      case FontSizeOption.medium:
        return 1.0;
      case FontSizeOption.large:
        return 1.15;
    }
  }

  /// Radio-group index: small=0, medium=1, large=2.
  int get radioIndex => _fontSizeOption.index;

  FontSizeProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_key) ?? 1; // default medium
    _fontSizeOption = FontSizeOption.values[savedIndex.clamp(0, 2)];
    notifyListeners();
  }

  Future<void> setFontSize(FontSizeOption option) async {
    if (_fontSizeOption == option) return;
    _fontSizeOption = option;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, option.index);
  }

  /// Convenience to set from radio-group int value.
  Future<void> setFontSizeFromIndex(int index) async {
    final option = FontSizeOption.values[index.clamp(0, 2)];
    await setFontSize(option);
  }
}
