import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/image_path_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void splash() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, RouteName.onboardScreen),
    );
  }

  @override
  void initState() {
    super.initState();
    splash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(ImagePathConstants.splash, height: 150),
        ),
      ),
    );
  }
}
