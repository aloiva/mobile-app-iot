// ignore_for_file: avoid_print, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
import 'package:mobile_app/services/checkPermissions.dart';

class Tab1Content extends StatefulWidget {
  const Tab1Content({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Tab1ContentState createState() => _Tab1ContentState();
}

class _Tab1ContentState extends State<Tab1Content> {
  bool isRegistered = true;
  bool allPermissions = true;

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

  Widget _buildChildItemWithCopy(String text, [IconData? icon]) {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Permissions Overview'),
                children: <Widget>[
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/check_permissions');
                    },
                    child: const Text('Recheck permissions.'),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Partner Registration Status'),
                children: <Widget>[
                  PreferenceUtils.getBool(UserSettingKeys.isdeviceregistered)
                      ? _buildChildItem('Registered', Icons.check)
                      : _buildChildItem('Unregistered', Icons.close),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Token'),
                children: <Widget>[
                  _buildChildItemWithCopy(PreferenceUtils.getString(UserSettingKeys.token), Icons.redo),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Username'),
                children: <Widget>[
                  _buildChildItemWithCopy(PreferenceUtils.getString(UserSettingKeys.username), Icons.redo),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('IMEI'),
                children: <Widget>[
                  _buildChildItemWithCopy(PreferenceUtils.getString(UserSettingKeys.imei), Icons.redo),
                ],
              ),
            ),
          ),
        ],
      ),
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
