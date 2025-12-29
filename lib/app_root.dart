import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/app_navigation.dart';
import 'package:mail_messanger/core/storage/onboard_storage.dart';
import 'package:mail_messanger/features/contacts/presentation/pages/contact_permission_screen.dart';
import 'package:mail_messanger/features/onboard/presentation/pages/onboard/presentation/pages/onboard_screen.dart';

import 'core/utils/app_logger.dart';
import 'features/otp/presentation/pages/otp_screen.dart';
import 'features/profile/presentation/pages/create_profile_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: OnboardStorage.isCompleted(),
      builder: (context, onboardSnap) {
        if (onboardSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Onboarding is not completed
        if (!onboardSnap.data!) {
          return const OnboardScreen();
        }

        // Onboarding done - check authentication
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnap) {
            AppLogger.i('🔥 Auth state changed: ${authSnap.data}');
            if (authSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // 3️⃣ User logged in
            if (authSnap.hasData) {
              return const ContactPermissionScreen(); // Contact permission screen
              //return const CreateProfileScreen();
            }

            // 4️⃣ Not logged in
            return const OtpScreen(); // Phone input
          },
        );
      },
    );
  }
}
