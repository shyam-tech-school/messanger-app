import 'package:flutter/material.dart';
import 'package:mail_messanger/app_navigation.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/features/auth/presentation/pages/otp_screen.dart';
import 'package:mail_messanger/features/auth/presentation/pages/otp_verification_screen.dart';
import 'package:mail_messanger/features/onboard/presentation/pages/onboard/onboard_screen.dart';
import 'package:mail_messanger/features/onboard/presentation/pages/splash/splash_screen.dart';

class RouteConfig {
  static Route<dynamic> routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case RouteName.onboardScreen:
        return MaterialPageRoute(builder: (context) => const OnboardScreen());

      case RouteName.otpScreen:
        return MaterialPageRoute(builder: (context) => const OtpScreen());

      case RouteName.otpVerificationScreen:
        return MaterialPageRoute(
          builder: (context) => const OtpVerificationScreen(),
        );

      case RouteName.navigationScreen:
        return MaterialPageRoute(builder: (context) => const AppNavigation());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("/Route Error"))),
        );
    }
  }
}
