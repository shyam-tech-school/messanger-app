import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/themes/custom_themes/text_themes.dart';

class AppThemes {
  static ThemeData lightThemeData = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorConstants.white,
    textTheme: TextThemes.lightTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorConstants.white,
      foregroundColor: ColorConstants.black,
      elevation: 0,
    ),
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );

  static ThemeData darkThemeData = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorConstants.black,
  );
}
