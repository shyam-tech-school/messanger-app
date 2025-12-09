import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mail_messanger/core/constants/image_path_constants.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';
import 'package:mail_messanger/features/auth/presentation/widgets/padding16_symmetric.dart';

import '../../../../core/common/widget/primary_button.dart';
import '../../../../core/routes/route_name.dart';
import '../widgets/country_flag_widget.dart';
import '../widgets/otp_inputfield_widget.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: .maxFinite,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Lottie.asset(ImagePathConstants.otp, height: 300),
            const SizedBox(height: 20),
            Text(
              TextConstants.otpVerification,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            const Text(TextConstants.createAccountText),
            const SizedBox(height: 20),
            const Padding16Symmetric(
              child: Row(
                spacing: 12,
                children: [
                  CountryFlagWidget(),

                  // input field
                  Expanded(child: OtpInputFieldWidget()),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Text(
              TextConstants.otpSubText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 30),

            // Submit button
            Padding16Symmetric(
              child: PrimaryButton(
                onTap: () async {
                  // Sending otp popup
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(TextConstants.otpMessage)),
                  );

                  Timer(
                    const Duration(seconds: 3),
                    () => Navigator.pushNamed(
                      context,
                      RouteName.otpVerificationScreen,
                    ),
                  );
                },
                label: "Next",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
