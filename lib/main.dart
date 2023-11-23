// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mobile_app/screens/login.dart';
import 'package:mobile_app/screens/register.dart';
import 'package:mobile_app/screens/home_page.dart'; // Replace with the actual path to your home page
import 'package:mobile_app/screens/settings_page.dart'; // Replace with the actual path to your settings page
// import 'package:mobile_app/models/app_config.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
import 'package:mobile_app/services/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

SharedPreferences? globalPrefs;

void main() async {
  // Required for async calls in `main`
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  globalPrefs = await PreferenceUtils.init();

  await Notifications().init();
  await Future.delayed(const Duration(seconds: 1));

  // Initialize PreferenceUtils instance.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: PreferenceUtils.getBool(UserSettingKeys.isloggedin) == true ? '/home' : '/login', // Set the initial route to the login page
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = 0.0;
                const end = 5.0;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                var opacityAnimation = animation.drive(tween);

                return FadeTransition(
                  opacity: opacityAnimation,
                  child: child,
                );
              },
            );
          // Add more cases for other routes as needed
          default:
            // Handle unknown route
            return MaterialPageRoute(builder: (context) => const HomePage());
        }
      },
    );
  }
}
