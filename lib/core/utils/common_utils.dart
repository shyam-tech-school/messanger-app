import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

class CommonUtils {
  //-- TIMER FOR OTP
  static String formatSeconds(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // -- Snackbar
  static dynamic showSnakckbar(BuildContext context, String content) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content, style: Theme.of(context).textTheme.bodyMedium),
        backgroundColor: ColorConstants.textfieldFillColor,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
