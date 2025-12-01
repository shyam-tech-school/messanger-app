import 'package:flutter/material.dart';
import 'package:mail_messanger/core/common/widget/primary_button.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/features/auth/presentation/widgets/pinput_widget.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: .maxFinite,
          child: Padding(
            padding: const .all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Text(
                  "Verify Phone",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Code has been sent to +91-98xxxxxxxx00",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Otp field
                const PinPutWidget(),
                const SizedBox(height: 24),

                const Text("Did'nt get OTP Code?"),
                const SizedBox(height: 12 / 2),
                Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Resend Code",
                      style: TextStyle(color: ColorConstants.primary),
                    ),
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteName.navigationScreen,
                      (route) => true,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
