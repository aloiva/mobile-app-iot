// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyPermissionScreen extends StatefulWidget {
  const MyPermissionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyPermissionScreenState createState() => _MyPermissionScreenState();
}

class _MyPermissionScreenState extends State<MyPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions Checker'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            requestPermissions();
            _showSuccess(context, "granted all permissions.");
          },
          child: const Text('Request Permissions'),
        ),
      ),
    );
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.location,
      Permission.bluetooth,
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.notification,
    ].request();

    // Check the status of each requested permission
    statuses.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        showPermissionDeniedDialog(permission);
      }
    });
  }

  void showPermissionDeniedDialog(Permission permission) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: Text('This app needs ${permission.toString()} permission to function properly.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Open app settings so the user can grant the permission
              },
              child: const Text('Open Settings'),
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
}
