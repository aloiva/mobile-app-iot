// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
// import 'dart:async';
// import 'package:mobile_app/services/notifications.dart';
// import 'package:http/http.dart' as http;

class Tab2Content extends StatefulWidget {
  const Tab2Content({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Tab2ContentState createState() => _Tab2ContentState();
}

class _Tab2ContentState extends State<Tab2Content> {
  bool isRegistered = true;
  @override
  void initState() {
    super.initState();
    setState(() {
      isRegistered = PreferenceUtils.getBool(UserSettingKeys.isdeviceregistered);
      // isRegistered = true;
    });
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _imeiController = TextEditingController();

  Widget _buildChildItem(String text, [IconData? icon]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          if (icon != null) Icon(icon),
        ],
      ),
    );
  }

  Widget _buildChildItemWithCopy(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          GestureDetector(
            onTap: () {
              _copyToClipboard(text);
            },
            child: const Text(
              'Copy',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // register device form
  Widget _buildViewOne(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Partner\'s username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter partner\'s username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _tokenController,
                decoration: const InputDecoration(labelText: 'Partner Device\'s token'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter their token';
                  }
                  // Add additional token validation logic if needed
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _imeiController,
                decoration: const InputDecoration(labelText: 'Partner Device\'s IMEI (optional)'),
                // No validator for optional field
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Validate the form
                  // Perform registration or submission logic here
                  // Access the input values using _usernameController.text, _tokenController.text, _imeiController.text
                  if (_usernameController.text.isEmpty || _tokenController.text.isEmpty) {
                    _showAlertDialog(context);
                  } else {
                    PreferenceUtils.setBool(UserSettingKeys.isdeviceregistered, true);
                    PreferenceUtils.setString(PartnerSettingKeys.partnerusername, _usernameController.text);
                    PreferenceUtils.setString(PartnerSettingKeys.partnertoken, _tokenController.text);
                    _showSuccess(context, "registered.");
                    setState(() {
                      // Toggle the boolean value
                      isRegistered = !isRegistered;
                    });
                  }
                  print('Username: ${_usernameController.text}');
                  print('token: ${_tokenController.text}');
                  print('Optional Field: ${_imeiController.text}');
                  print(isRegistered);
                },
                child: const Text('Register as your partner\'s device'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // when registered, have their details and last location, last image.
  Widget _buildViewTwo(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Permissions Overview'),
                children: <Widget>[
                  _buildChildItem('Camera Access'),
                  _buildChildItem('Notifications Access'),
                  _buildChildItem('Location Access'),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Toggle the boolean value
                isRegistered = true;
              });
            },
            child: const Text('Unregister this Partner.'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isRegistered ? _buildViewOne(context) : _buildViewTwo(context),
      ],
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Username and token cannot be empty. Please get token from your partner\'s mobile app.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('okay'),
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
              },
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // You can add a snackbar or any other feedback here to indicate that the text has been copied.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
      ),
    );
  }
}
