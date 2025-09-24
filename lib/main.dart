import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:afrisight/app/routes/app_pages.dart';
import 'package:afrisight/app/routes/app_routes.dart';
import 'package:afrisight/app/themes/app_theme.dart';
import 'package:afrisight/app/bindings/app_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AfrisightApp());
}

class AfrisightApp extends StatelessWidget {
  const AfrisightApp({super.key});

  Future<String> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    final bool isOnboarded = prefs.getBool('onboarded') ?? false;
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final bool hasUserData = prefs.containsKey('user_data');

    // First launch always goes to splash
    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
      return Routes.splash;
    }

    // From splash, app decides routing:
    if (!isOnboarded) {
      return Routes.onboarding; // Show onboarding if not done
    } else if (isLoggedIn || hasUserData) {
      if (!isLoggedIn && hasUserData) {
        await prefs.setBool('isLoggedIn', true);
      }
      return Routes.home;
    } else {
      return Routes.signin;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Show a basic splash UI while deciding route
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/afrisight_logo.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        }

        return GetMaterialApp(
          title: 'Afrisight',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: snapshot.data ?? Routes.splash,
          getPages: AppPages.pages,
          initialBinding: AppBindings(),
        );
      },
    );
  }
}
