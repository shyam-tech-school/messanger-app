import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mail_messanger/app_navigation.dart';
import 'package:mail_messanger/core/common/widget/primary_button.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/core/utils/common_utils.dart';
import 'package:mail_messanger/features/auth/presentation/provider/otp_timer_provider.dart';
import 'package:mail_messanger/features/auth/presentation/widgets/pinput_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/resend_otp_button_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<OtpTimerProvider>().startTimer(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          width: .maxFinite,
          child: Padding(
            padding: const .all(16.0),
            child: Column(
              children: [
                // OTP TEXT
                Text(
                  TextConstants.verifyOtp,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  TextConstants.verifyOtpSubText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                const Text("+91-98XXXXXX00"),
                const SizedBox(height: 24),

                // Otp field
                const PinPutWidget(),
                const SizedBox(height: 24),

                const Text(TextConstants.didntGetOtp),
                const SizedBox(height: 12 / 2),
                Row(
                  spacing: 6,
                  mainAxisAlignment: .center,
                  children: [
                    // Otp resend button
                    Selector<OtpTimerProvider, bool>(
                      selector: (_, provider) => provider.secondsRemaining == 0,
                      builder: (context, isExpired, _) => ResendOtpButtonWidget(
                        ontap: isExpired
                            ? () {
                                //TODO: RESEND OTP FUNCTION
                              }
                            : null,
                      ),
                    ),

                    // Otp timer
                    Selector<OtpTimerProvider, int>(
                      selector: (_, provider) => provider.secondsRemaining,
                      builder: (context, seconds, _) =>
                          Text(CommonUtils.formatSeconds(seconds)),
                    ),
                  ],
                ),
                const Spacer(),

                // Submit button
                PrimaryButton(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteName.navigationScreen,
                      (route) => true,
                    );
                  },
                  label: "Verify",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
