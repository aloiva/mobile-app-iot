// import 'dart:convert';
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
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
                onTap: () => _updateKey(AppSettingsKeys.loginEndPoint),
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: const Color.fromARGB(255, 175, 170, 76),
                icon: CupertinoIcons.profile_circled,
                title: "Register Endpoint",
                onTap: () => _updateKey(AppSettingsKeys.registerEndpoint),
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: const Color.fromARGB(255, 161, 204, 42),
                icon: CupertinoIcons.device_phone_portrait,
                title: "Device Registration Endpoint",
                onTap: () => _updateKey(AppSettingsKeys.deviceRegisterEndpoint),
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: Colors.black,
                icon: CupertinoIcons.photo,
                title: "Image Data Endpoint",
                onTap: () => _updateKey(AppSettingsKeys.imageEndpoint),
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: const Color.fromARGB(255, 39, 128, 176),
                icon: CupertinoIcons.location,
                title: "Location Data Endpoint",
                onTap: () => _updateKey(AppSettingsKeys.locationEndpoint),
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: Color.fromARGB(255, 19, 204, 41),
                icon: CupertinoIcons.lock,
                title: "Your Token",
                onTap: () => _updateKey(UserSettingKeys.token),
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: Color.fromARGB(255, 168, 112, 224),
                icon: CupertinoIcons.person_2_square_stack,
                title: "Your Partner's Token",
                onTap: () => _updateKey(UserSettingKeys.partnertoken),
              ),
              const SizedBox(height: 20),
              SettingsTile(
                color: const Color.fromARGB(255, 176, 39, 39),
                icon: CupertinoIcons.lock_shield,
                title: "Service Account Auth Token",
                onTap: () => _updateKey(AppSettingsKeys.authtoken),
              ),
              const SizedBox(height: 20),
              // const Spacer(), // Add a Spacer to push the following widget to the bottom
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    print(PreferenceUtils.getBool(UserSettingKeys.isloggedin));
                    if (PreferenceUtils.getBool(UserSettingKeys.isloggedin) == true) {
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
                PreferenceUtils.setBool(UserSettingKeys.isloggedin, false);
                // print(PreferenceUtils.getBool(UserSettingKeys.isloggedin));
                Navigator.pushNamed(context, '/login');
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
}
