// import 'dart:convert';
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
import 'package:mobile_app/widgets/settings_page/settings_tile.dart';
import 'package:mobile_app/services/apiClient.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              SettingsTile(
                color: const Color.fromARGB(255, 144, 137, 137),
                icon: CupertinoIcons.link,
                title: "Base URL",
                onTap: () => _updateKey(AppSettingsKeys.baseURL),
              ),
              const SizedBox(height: 20),
              // const Spacer(), // Add a Spacer to push the following widget to the bottom
              ElevatedButton(
                onPressed: () {
                  // Add logic for "Reset Defaults" button
                  _resetDefaults();
                },
                child: const Text('Reset Defaults'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add logic for "Logout" button
                  _showLogoutConfirmationDialog();
                },
                child: const Text('Logout'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add logic for "Delete Account" button
                  _showDeleteConfirmationDialog();
                },
                child: const Text('Delete Account'),
              ),
            ]),
          ),
        ));
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
                _showSuccess(context, "logged out");
                PreferenceUtils.setBool(UserSettingKeys.isloggedin, false);
                PreferenceUtils.setBool(UserSettingKeys.isdeviceregistered, false);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _updateKey(String key) async {
    _textFieldController.text = PreferenceUtils.getString(key);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(key),
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
                  PreferenceUtils.setString(key, _textFieldController.text);
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

  void _showSuccess(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successfully $text'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void _resetDefaults() async {
    await PreferenceUtils.init();
    _showSuccess(context, "reset to defaults.");
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletion confirmation'),
          content: const Text('Are you sure you want to delete account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteAccount();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
                title: Text('Deleting account...'),
                content: LinearProgressIndicator(
                  backgroundColor: Color.fromARGB(2, 91, 9, 9), // Set background color
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Set progress color
                ));
          });
      var id = PreferenceUtils.getString(UserSettingKeys.imei);
      var response = await apiClient.deleteUser(id);
      print(response);
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        PreferenceUtils.setBool(UserSettingKeys.isloggedin, false);
        PreferenceUtils.setBool(UserSettingKeys.isdeviceregistered, false);
        _showSuccess(context, "deleted account");
      } else {
        _showFailure();
      }
    } catch (error) {
      // Close the loading dialog in case of an error
      Navigator.of(context).pop();
      print('Error sending data: $error');
    }
  }

  void _showFailure() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('account deletion failed.'),
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
}
