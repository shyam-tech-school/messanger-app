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
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.primary),
        ),
        hintText: "Enter number",
        hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
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
