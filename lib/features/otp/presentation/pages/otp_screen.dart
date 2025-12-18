import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/constants/image_path_constants.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';
import 'package:mail_messanger/core/utils/common_utils.dart';
import 'package:mail_messanger/features/otp/presentation/provider/auth_provider.dart';
import 'package:mail_messanger/features/otp/presentation/widgets/padding16_symmetric.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widget/primary_button.dart';
import '../../../../core/routes/route_name.dart';
import '../widgets/country_flag_widget.dart';
import '../widgets/otp_inputfield_widget.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _phoneNumberController = TextEditingController();
  final int maxPhoneLength = 10;
  double progress = 0.0;

  void _onTextChanged(String value) {
    setState(() {
      progress = (value.length / maxPhoneLength).clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Lottie.asset(ImagePathConstants.otp, height: 300),
                const SizedBox(height: 20),
                Text(
                  TextConstants.otpVerification,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: ColorConstants.primaryColor,
                    fontFamily: 'LuckiestGuy',
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(TextConstants.createAccountText),
                const SizedBox(height: 20),
                Padding16Symmetric(
                  child: Row(
                    spacing: 12,
                    children: [
                      const CountryFlagWidget(),

                      // input field
                      Expanded(
                        child: OtpInputFieldWidget(
                          controller: _phoneNumberController,
                          onChanged: _onTextChanged,
                        ),
                      ),
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
                  child: Consumer<OTPAuthProvider>(
                    builder: (context, auth, _) => PrimaryBtnWidget(
                      progress: progress,
                      label: TextConstants.next,
                      isEnabled: !auth.isLoading,
                      ontap: auth.isLoading
                          ? null
                          : () async {
                              final rawPhone = _phoneNumberController.text;

                              final error =
                                  CommonUtils.validateIndianPhoneNumber(
                                    rawPhone,
                                  );

                              if (error != null) {
                                CommonUtils.showSnakckbar(context, error);
                                return;
                              }

                              final phoneE164 = CommonUtils.toE164(rawPhone);

                              await auth.sendOtp(phoneE164);

                              if (context.mounted) {
                                if (auth.error != null) {
                                  CommonUtils.showSnakckbar(
                                    context,
                                    auth.error!,
                                  );
                                  return;
                                }
                              }
                              log("[LOG]: ${_phoneNumberController.text}");

                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  RouteName.otpVerificationScreen,
                                  arguments: rawPhone,
                                );
                              }
                            },
                    ),
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
