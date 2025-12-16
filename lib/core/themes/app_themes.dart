import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/themes/custom_themes/text_themes.dart';

class AppThemes {
  static ThemeData lightThemeData = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorConstants.white,
    textTheme: TextThemes.darkTextTheme,
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
    scaffoldBackgroundColor: ColorConstants.darkScaffoldBgColor,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.darkScaffoldBgColor,
      iconTheme: IconThemeData(color: ColorConstants.primaryColor),
      elevation: 0,
      scrolledUnderElevation: 10,
      centerTitle: false,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: ColorConstants.white,
        fontFamily: 'OpenSans',
      ),

      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: ColorConstants.white,
        fontFamily: 'OpenSans',
      ),

      headlineMedium: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: ColorConstants.white,
      ),
    ),
  );
}
