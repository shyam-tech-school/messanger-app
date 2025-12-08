import 'package:flutter/material.dart';
import 'package:mail_messanger/core/routes/route_config.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/core/themes/app_themes.dart';
import 'package:mail_messanger/features/onboard/presentation/pages/splash/splash_screen.dart';

void main(List<String> args) {
  runApp(const MessangerApp());
}

class MessangerApp extends StatelessWidget {
  const MessangerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      theme: AppThemes.lightThemeData,
      darkTheme: AppThemes.lightThemeData,
      themeMode: ThemeMode.light,
      initialRoute: RouteName.splashScreen,
      onGenerateRoute: RouteConfig.routeGenerator,
      debugShowCheckedModeBanner: false,
    );
  }
}
