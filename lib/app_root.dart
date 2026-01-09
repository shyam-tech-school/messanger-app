import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mail_messanger/app_navigation.dart';
import 'package:mail_messanger/core/app_state_manager.dart';
import 'package:mail_messanger/core/storage/onboard_storage.dart';
import 'package:mail_messanger/features/onboard/presentation/pages/onboard/presentation/pages/onboard_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'features/contacts/presentation/pages/contact_permission_screen.dart';
import 'features/otp/presentation/pages/otp_screen.dart';
import 'features/profile/presentation/pages/create_profile_screen.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with WidgetsBindingObserver {
  late Future<Widget> _startScreenFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver((this));
    _startScreenFuture = _decideStartScreen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _startScreenFuture = _decideStartScreen();
      });
    }
  }

  Future<Widget> _decideStartScreen() async {
    final startScreen = await _buildStartScreen();

    FlutterNativeSplash.remove();

    return startScreen;
  }

  Future<Widget> _buildStartScreen() async {
    // Onboard Completed
    final isOnboarded = await OnboardStorage.isCompleted();
    if (!isOnboarded) {
      return const OnboardScreen();
    }

    // Phone verified
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const OtpScreen();
    }

    // Profile completed
    final isProfileCompleted = await AppStateManager.getProfileCompleted();
    if (!isProfileCompleted) {
      return const CreateProfileScreen();
    }

    // Contact permission (fetch from os)
    final contactStatus = await Permission.contacts.status;
    if (!contactStatus.isGranted) {
      return const ContactPermissionScreen();
    }

    // Everything done
    return const AppNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _startScreenFuture,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return snapshot.data!;
      },
    );
  }
}
