// ignore_for_file: deprecated_member_use, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  const RegisterForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ignore: non_constant_identifier_names
  void _Register() async {
    const String apiUrl = 'http://192.168.3.237:3000/send-data';

    Map<String, String> credentials = {
      'type': 'Register',
      'username': _usernameController.text,
      'password': _passwordController.text,
    };
    String jsonString = jsonEncode(credentials);
    print(jsonString);
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              title: Text('Logging in...'),
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
          title: const Text(''),
          content: const Text('Successfully registered user.. now logging in.'),
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
          content: const Text('Are you sure you want to log in?'),
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
