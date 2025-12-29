import 'package:flutter/material.dart';
import 'package:mail_messanger/app_navigation.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/features/audio_call/presentation/pages/audio_call_screen.dart';
import 'package:mail_messanger/features/contacts/presentation/pages/contact_permission_screen.dart';
import 'package:mail_messanger/features/otp/presentation/pages/otp_screen.dart';
import 'package:mail_messanger/features/otp/presentation/pages/otp_verification_screen.dart';
import 'package:mail_messanger/features/chat/presentation/pages/chat_screen.dart';
import 'package:mail_messanger/features/external_profile/presentation/pages/external_profile.dart';
import 'package:mail_messanger/features/onboard/presentation/pages/onboard/presentation/pages/onboard_screen.dart';
import 'package:mail_messanger/features/profile/presentation/pages/profile_screen.dart';
import 'package:mail_messanger/features/sub_settings/account/account_screen.dart';
import 'package:mail_messanger/features/sub_settings/account/change_phone_number/presentation/pages/change_phone_number_info.dart';
import 'package:mail_messanger/features/sub_settings/account/change_phone_number/presentation/pages/change_phone_number_screen.dart';
import 'package:mail_messanger/features/sub_settings/account/delete_account/presentation/pages/delete_account_screen.dart';
import 'package:mail_messanger/features/sub_settings/account/email/presentation/pages/email_screen.dart';
import 'package:mail_messanger/features/sub_settings/account/two_step_verification/presentation/pages/two_step_verification.dart';
import 'package:mail_messanger/features/sub_settings/chat_settings/chat_settings_screen.dart';
import 'package:mail_messanger/features/sub_settings/notifications/notification_settings_screen.dart';
import 'package:mail_messanger/features/sub_settings/privacy/about/presentation/pages/privacy_about_screen.dart';
import 'package:mail_messanger/features/sub_settings/privacy/blocked_contacts/presentation/pages/privacy_blocked_contacts_screen.dart';
import 'package:mail_messanger/features/sub_settings/privacy/last_seen/presentation/pages/privacy_last_seen_screen.dart';
import 'package:mail_messanger/features/sub_settings/privacy/privacy_screen.dart';
import 'package:mail_messanger/features/sub_settings/privacy/profile_photo/presentation/pages/privacy_profile_photo_screen.dart';

class RouteConfig {
  static Route<dynamic> routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.onboardScreen:
        return MaterialPageRoute(builder: (context) => const OnboardScreen());

      case RouteName.otpScreen:
        return MaterialPageRoute(builder: (context) => const OtpScreen());

      case RouteName.otpVerificationScreen:
        final arguments = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(phoneNumber: arguments),
        );

      case RouteName.contactPermissionScreen:
        return MaterialPageRoute(
          builder: (context) => const ContactPermissionScreen(),
        );

      case RouteName.navigationScreen:
        return MaterialPageRoute(builder: (context) => const AppNavigation());

      case RouteName.chatScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChatScreen(chats: arguments),
        );

      case RouteName.profileScreen:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());

      case RouteName.externalProfileScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ExternalProfile(user: arguments),
        );

      //-- ACCOUNT SCREEN
      case RouteName.accountScreen:
        return MaterialPageRoute(builder: (context) => const AccountScreen());

      case RouteName.twoSVScreen:
        return MaterialPageRoute(
          builder: (context) => const TwoStepVerification(),
        );

      case RouteName.emailScreen:
        return MaterialPageRoute(builder: (context) => const EmailScreen());

      case RouteName.deleteScreen:
        return MaterialPageRoute(builder: (context) => DeleteAccountScreen());

      case RouteName.changePhoneNumberInfoScreen:
        return MaterialPageRoute(
          builder: (context) => const ChangePhoneNumberInfo(),
        );

      case RouteName.changePhoneNumberScreen:
        return MaterialPageRoute(
          builder: (context) => const ChangePhoneNumberScreen(),
        );

      //-- PRIVACY SCREEN
      case RouteName.privacyScreen:
        return MaterialPageRoute(builder: (context) => PrivacyScreen());
      case RouteName.lastSeenScreen:
        return MaterialPageRoute(
          builder: (context) => const PrivacyLastSeenScreen(),
        );
      case RouteName.profilePhotoScreen:
        return MaterialPageRoute(
          builder: (context) => const PrivacyProfilePhotoScreen(),
        );
      case RouteName.aboutScreen:
        return MaterialPageRoute(
          builder: (context) => const PrivacyAboutScreen(),
        );
      case RouteName.blockedContactsScreen:
        return MaterialPageRoute(
          builder: (context) => const PrivacyBlockedContactsScreen(),
        );

      //-- CHATS SCREEN
      case RouteName.chatsSettingsScreen:
        return MaterialPageRoute(
          builder: (context) => const ChatSettingsScreen(),
        );

      //-- NOTIFICATION SCREEN
      case RouteName.notificationScreen:
        return MaterialPageRoute(
          builder: (context) => const NotificationSettingsScreen(),
        );

      //--AUDIO, VIDEO CALL
      case RouteName.audioCallScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => AudioCallScreen(userData: args),
        );

      // case RouteName.videoCallScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => const NotificationSettingsScreen(),
      //  );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("/Route Error"))),
        );
    }
  }
}
