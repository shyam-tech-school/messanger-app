import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mail_messanger/app_provider.dart';
import 'package:mail_messanger/app_root.dart';
import 'package:mail_messanger/core/routes/route_config.dart';
import 'package:mail_messanger/core/themes/app_themes.dart';
import 'package:mail_messanger/core/utils/app_logger.dart';
import 'package:mail_messanger/firebase_options.dart';
import 'package:mail_messanger/core/services/firebase_messaging_service.dart';
import 'package:mail_messanger/core/services/presence_service.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //! Remove this in prod
  if (kDebugMode) {
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
    AppLogger.w('Firebase app verification disabled for testing');
  }

  // Initialize Presence Service
  PresenceService().initialize();

  runApp(const MessangerApp());
}

class MessangerApp extends StatelessWidget {
  const MessangerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.provider,
      child: MaterialApp(
        theme: AppThemes.darkThemeData,
        darkTheme: AppThemes.darkThemeData,
        themeMode: ThemeMode.dark,
        home: const AppRoot(),
        onGenerateRoute: RouteConfig.routeGenerator,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// 153088
