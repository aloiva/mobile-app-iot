import 'package:flutter/material.dart';
import 'package:mobile_app/screens/login.dart';
import 'package:mobile_app/screens/register.dart';
import 'package:mobile_app/screens/home_page.dart'; // Replace with the actual path to your home page
import 'package:mobile_app/screens/settings_page.dart'; // Replace with the actual path to your settings page
import 'package:mobile_app/models/app_config.dart';

AppConfig globalAppConfig = AppConfig.initial();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/login', // Set the initial route to the login page
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomePage(appConfig: globalAppConfig),
        '/settings': (context) => SettingsPage(appConfig: globalAppConfig),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  HomePage(appConfig: settings.arguments as AppConfig),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = 0.0;
                const end = 5.0;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

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
            return MaterialPageRoute(
                builder: (context) => HomePage(appConfig: globalAppConfig));
        }
      },
    );
  }
}
