import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/color_constants.dart';

class OtpInputFieldWidget extends StatelessWidget {
  const OtpInputFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: ColorConstants.primary,
      cursorHeight: 22,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: const InputDecoration(
        filled: true,
        fillColor: ColorConstants.textfieldFillColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.textfieldBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.textfieldBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.primaryColor),
        ),
        hintText: "Enter number",
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: ColorConstants.white,
          fontFamily: 'OpenSans',
        ),
      ),
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
