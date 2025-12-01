import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/constants/image_path_constants.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';

import '../../../../core/common/widget/primary_button.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const SizedBox(height: 12),

              // header section
              Row(
                children: [
                  Image.asset(ImagePathConstants.splash, height: 40),
                  Text(
                    TextConstants.tolki,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),

              // Welcome text
              const SizedBox(height: 24),
              Text(
                TextConstants.welcomeText,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                TextConstants.createAccount,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: ColorConstants.grey),
              ),

              // Phone number section
              const SizedBox(height: 60),
              Text(
                TextConstants.phoneNumber,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: ColorConstants.grey),
              ),
              const SizedBox(height: 12),
              Row(
                spacing: 12,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: const Text("🇮🇳", style: TextStyle(fontSize: 30)),
                  ),

                  // input field
                  Expanded(
                    child: TextField(
                      cursorColor: ColorConstants.primary,
                      cursorHeight: 22,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        hintText: "Enter number",
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                        // Navigator.pushNamed(
                        //   context,
                        //   RouteName.otpVerificationScreen,
                        // );
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Submit button
              PrimaryButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
