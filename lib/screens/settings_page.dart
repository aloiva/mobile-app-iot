// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app/widgets/settings_page/settings_tile.dart';
import 'package:mobile_app/models/app_config.dart'; // Import the AppConfig model

class SettingsPage extends StatefulWidget {
  final AppConfig appConfig; // Pass AppConfig to the SettingsPage

  const SettingsPage({Key? key, required this.appConfig}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SettingsTile(
                color: Colors.blue,
                icon: CupertinoIcons.profile_circled,
                title: "Login Endpoint",
                onTap: _updateloginEndpoint,
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: Colors.green,
                icon: CupertinoIcons.profile_circled,
                title: "Register Endpoint",
                onTap: _updateregisterEndpoint,
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: const Color.fromARGB(255, 161, 204, 42),
                icon: CupertinoIcons.device_phone_portrait,
                title: "Device Registration Endpoint",
                onTap: _updatedeviceRegisterEndpoint,
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: Colors.black,
                icon: CupertinoIcons.photo,
                title: "Image Data Endpoint",
                onTap: _updateimageEndpoint,
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: Colors.purple,
                icon: CupertinoIcons.location,
                title: "Location Data Endpoint",
                onTap: _updatelocationEndpoint,
              ),
              const SizedBox(height: 20),
              // const Spacer(), // Add a Spacer to push the following widget to the bottom
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to the login page
                    _showLogoutConfirmationDialog();
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout logic here
                // For example, you can navigate to the login page
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _updateloginEndpoint() async {
    _textFieldController.text =
        widget.appConfig.loginEndPoint; // Set initial value in the text field

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('loginEndpoint'),
          content: TextField(
            controller: _textFieldController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the global variable with the text field value
                setState(() {
                  widget.appConfig.loginEndPoint = _textFieldController.text;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateregisterEndpoint() async {
    _textFieldController.text = widget
        .appConfig.registerEndpoint; // Set initial value in the text field

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('registerEndpoint'),
          content: TextField(
            controller: _textFieldController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the global variable with the text field value
                setState(() {
                  widget.appConfig.registerEndpoint = _textFieldController.text;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateimageEndpoint() async {
    _textFieldController.text =
        widget.appConfig.imageEndpoint; // Set initial value in the text field

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('imageEndpoint'),
          content: TextField(
            controller: _textFieldController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the global variable with the text field value
                setState(() {
                  widget.appConfig.imageEndpoint = _textFieldController.text;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updatelocationEndpoint() async {
    _textFieldController.text = widget
        .appConfig.locationEndpoint; // Set initial value in the text field

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('locationEndpoint'),
          content: TextField(
            controller: _textFieldController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the global variable with the text field value
                setState(() {
                  widget.appConfig.locationEndpoint = _textFieldController.text;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updatedeviceRegisterEndpoint() async {
    _textFieldController.text = widget.appConfig
        .deviceRegisterEndpoint; // Set initial value in the text field

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('deviceRegisterEndpoint'),
          content: TextField(
            controller: _textFieldController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the global variable with the text field value
                setState(() {
                  widget.appConfig.deviceRegisterEndpoint =
                      _textFieldController.text;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
