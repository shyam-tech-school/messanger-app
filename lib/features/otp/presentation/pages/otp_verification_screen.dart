import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mail_messanger/core/app_state_manager.dart';
import 'package:mail_messanger/core/common/widget/primary_button.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';
import 'package:mail_messanger/core/utils/common_utils.dart';
import 'package:mail_messanger/features/otp/presentation/provider/auth_provider.dart';
import 'package:mail_messanger/features/otp/presentation/provider/otp_timer_provider.dart';
import 'package:mail_messanger/features/otp/presentation/widgets/pinput_widget.dart';
import 'package:provider/provider.dart';

import '../../../../app_root.dart';
import '../widgets/resend_otp_button_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _otp = '';
  final int maxPhoneLength = 10;
  double progress = 0.0;
  bool _isVerificationSuccess = false;

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
      appBar: AppBar(
        backgroundColor: ColorConstants.darkScaffoldBgColor,
        elevation: 0,
        leading: const BackButton(color: ColorConstants.primaryColor),
      ),
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
                    fontFamily: 'LuckiestGuy',
                    color: ColorConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  TextConstants.verifyOtpSubText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  "+91 ${widget.phoneNumber}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Otp field
                PinPutWidget(
                  onChanged: (value) {
                    setState(() {
                      progress = value.length / 6;
                    });
                  },
                  onCompleted: (value) {
                    _otp = value;
                  },
                ),
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
                const SizedBox(height: 30),

                // Submit button
                Consumer<OTPAuthProvider>(
                  builder: (_, auth, _) => PrimaryBtnWidget(
                    progress: _isVerificationSuccess ? 1.0 : progress,
                    label: TextConstants.verify,
                    isLoading: auth.isLoading && _isVerificationSuccess,
                    onTap: (_isVerificationSuccess || auth.isLoading)
                        ? null
                        : () async {
                            if (_otp.length != 6) {
                              CommonUtils.showSnakckbar(
                                context,
                                'Enter a valid OTP',
                                Colors.red,
                              );
                              return;
                            }

                            try {
                              setState(() {
                                _isVerificationSuccess = true;
                              });

                              await auth.verifyOtp(_otp);
                              await AppStateManager.setPhoneVerified(); // OTP verified flag

                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) => Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const AppRoot(),
                                  ),
                                  (route) => false,
                                ),
                              );
                            } catch (e) {
                              if (context.mounted) {
                                setState(() {
                                  _isVerificationSuccess = false;
                                });

                                CommonUtils.showSnakckbar(
                                  context,
                                  'Invalid OTP. Please try again.',
                                );
                              }
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
