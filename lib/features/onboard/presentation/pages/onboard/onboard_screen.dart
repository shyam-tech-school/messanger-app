import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/constants/image_path_constants.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';

import '../../widgets/slide_action_widget.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: .maxFinite,
          height: .maxFinite,
          child: Column(
            children: [
              const SizedBox(height: 24),

              // image
              Image.asset(ImagePathConstants.onboard),

              // title and subtitle
              Column(
                spacing: 12,
                children: [
                  Text(
                    TextConstants.onboardTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    TextConstants.onboardSubTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: ColorConstants.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // Swipe button
              Padding(
                padding: const .symmetric(horizontal: 20),
                child: SlidActionWidget(
                  onNavigate: () {
                    return Navigator.pushReplacementNamed(
                      context,
                      RouteName.otpScreen,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
