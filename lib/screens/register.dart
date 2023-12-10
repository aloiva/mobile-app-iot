// ignore_for_file: deprecated_member_use, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:mobile_app/services/apiClient.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
// import 'package:mobile_app/screens/home_page.dart';
// import 'package:mobile_app/models/app_config.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the confirmation dialog when the back button is pressed
        bool exit = await showExitConfirmationDialog(context);
        return exit;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('register'), automaticallyImplyLeading: false, actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings route
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ]),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: registerForm(),
        ),
      ),
    );
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}

class registerForm extends StatefulWidget {
  const registerForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _registerFormState createState() => _registerFormState();
}

class _registerFormState extends State<registerForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  void _register() async {
    Map<String, String> credentials = {'username': _usernameController.text, 'id': _idController.text};
    String jsonString = jsonEncode(credentials);
    print(jsonString);
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
                title: Text('Registering...'),
                content: LinearProgressIndicator(
                  backgroundColor: Color.fromARGB(2, 91, 9, 9), // Set background color
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Set progress color
                ));
          });

      var response = await apiClient.registerUser(credentials);
      print(response);
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        PreferenceUtils.setBool(UserSettingKeys.isloggedin, true);
        print(PreferenceUtils.getBool(UserSettingKeys.isloggedin));
        _showSuccess();
      } else {
        _showFailure();
      }
    } catch (error) {
      // Close the loading dialog in case of an error
      Navigator.of(context).pop();
      print('Error sending data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _idController,
          obscureText: false,
          decoration: const InputDecoration(labelText: 'IMEI'),
        ),
        const SizedBox(height: 16.0),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _checkConfirmation,
          child: const Text('register'),
        ),
        const SizedBox(height: 8.0), // Add some spacing
        TextButton(
          onPressed: () {
            // Navigate to the registration route
            Navigator.pushNamed(context, '/login');
          },
          child: const Text("New user? login here."),
        ),
      ],
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Succesful.'),
          // content: const Text(''),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Okay'),
            )
          ],
        );
      },
    );
  }

  void _showFailure() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('register failed. Please check your id.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Okay'),
            )
          ],
        );
      },
    );
  }

  void _checkConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('register Confirmation'),
          content: const Text('Are you sure you want to register?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: _register,
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
