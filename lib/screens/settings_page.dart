// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app/models/preferenceUtils.dart';
import 'package:mobile_app/widgets/settings_page/settings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
                    print(PreferenceUtils.getBool(UserDataKeys.isloggedin));
                    if (PreferenceUtils.getBool(UserDataKeys.isloggedin) == true) {
                      _showLogoutConfirmationDialog();
                    }
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
                PreferenceUtils.setBool(UserDataKeys.isloggedin, false);
                // print(PreferenceUtils.getBool(UserDataKeys.isloggedin));
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
    _textFieldController.text = PreferenceUtils.getString(AppSettingsKeys.loginEndPoint);

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
                setState(() {
                  PreferenceUtils.setString(AppSettingsKeys.loginEndPoint, _textFieldController.text);
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
    _textFieldController.text = PreferenceUtils.getString(AppSettingsKeys.registerEndpoint);

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
                  PreferenceUtils.setString(AppSettingsKeys.registerEndpoint, _textFieldController.text);
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
    _textFieldController.text = PreferenceUtils.getString(AppSettingsKeys.imageEndpoint);

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
                  PreferenceUtils.setString(AppSettingsKeys.imageEndpoint, _textFieldController.text);
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
    _textFieldController.text = PreferenceUtils.getString(AppSettingsKeys.locationEndpoint);

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
                  PreferenceUtils.setString(AppSettingsKeys.locationEndpoint, _textFieldController.text);
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
    _textFieldController.text = PreferenceUtils.getString(AppSettingsKeys.deviceRegisterEndpoint);
    // .deviceRegisterEndpoint; // Set initial value in the text field

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
                  PreferenceUtils.setString(AppSettingsKeys.deviceRegisterEndpoint, _textFieldController.text);
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
