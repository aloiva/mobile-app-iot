// ignore_for_file: deprecated_member_use, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_app/models/PreferenceUtils.dart';

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
        appBar: AppBar(title: const Text('Register'), automaticallyImplyLeading: false, actions: [
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
          child: RegisterForm(),
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
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedProvider = 'Jio';

  List<String> providerList = ['Jio', 'Airtel', 'Vi', 'Other'];

  // ignore: non_constant_identifier_names
  void _Register() async {
    String apiUrl = PreferenceUtils.getString(AppSettingsKeys.registerEndpoint);

    Map<String, String> credentials = {
      'type': 'register',
      'username': _usernameController.text,
      'password': _passwordController.text,
      'carrier': selectedProvider,
    };
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
        },
      );

      var response = await http.post(
        Uri.parse(apiUrl),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );
      // Close the loading dialog
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
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        const SizedBox(height: 16.0),
        DropdownButton<String>(
          value: selectedProvider,
          onChanged: (String? newValue) {
            setState(() {
              selectedProvider = newValue!;
            });
          },
          items: providerList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _checkConfirmation,
          child: const Text('Register'),
        ),
        const SizedBox(height: 8.0), // Add some spacing
        TextButton(
          onPressed: () {
            // Navigate to the registration route
            Navigator.pushNamed(context, '/login');
          },
          child: const Text("Existing user? Login here."),
        ),
      ],
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration successful.'),
          content: const Text('You will be logged in now.'),
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
          title: const Text(''),
          content: const Text('Registering failed. Please try again.'),
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
          title: const Text('Register Confirmation'),
          content: const Text('Are you sure you want to register?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: _Register,
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
