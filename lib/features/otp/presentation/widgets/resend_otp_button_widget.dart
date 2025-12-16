import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/text_constants.dart';

class ResendOtpButtonWidget extends StatelessWidget {
  const ResendOtpButtonWidget({super.key, required this.ontap});

  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: TextButton(
        style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
        onPressed: ontap,
        child: const Text(
          TextConstants.resendCode,
          style: TextStyle(color: ColorConstants.primaryColor),
        ),
      ),
    );
  }
}
