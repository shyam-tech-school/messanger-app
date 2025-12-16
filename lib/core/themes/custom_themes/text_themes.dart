import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';

class TextThemes {
  static const TextTheme darkTextTheme = TextTheme(
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: ColorConstants.black,
    ),

    // -- HEADLINE --
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: ColorConstants.black,
    ),

    headlineMedium: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: ColorConstants.black,
    ),

    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: ColorConstants.black,
    ),
  );
}
