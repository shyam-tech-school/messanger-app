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
  static dynamic showSnakckbar(
    BuildContext context,
    String content, [
    Color bgColor = ColorConstants.textfieldFillColor,
  ]) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content, style: Theme.of(context).textTheme.bodyMedium),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  //-- VALIDATE INDIAN PHONE NUMBER
  static String? validateIndianPhoneNumber(String phone) {
    final value = phone.trim();

    if (value.isEmpty) {
      return 'Phone number cannot be empty';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Phone number must contain digits only';
    }

    if (phone.length < 10) {
      return 'Phone number must be 10 digits';
    }

    return null;
  }

  static String toE164(String phone, {String countryCode = "+91"}) {
    final normalized = phone.replaceFirst(RegExp(r'^0+'), '');
    return "$countryCode$normalized";
  }
}
