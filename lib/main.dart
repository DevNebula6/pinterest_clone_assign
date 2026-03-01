import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'presentation/providers/core_providers.dart';

// app entry point - sets up orientation, status bar and loads env vars
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //load env variables from .env file
  await dotenv.load(fileName: '.env');
  
  // portrait only, pinterest doesnt really need landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // make status bar transparent so the collage bleeds under it
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: ClerkAuth(
        config: ClerkAuthConfig(
          publishableKey: dotenv.env['CLERK_PUBLISHABLE_KEY'] ?? '',
        ),
        child: const App(),
      ),
    ),
  );
}
