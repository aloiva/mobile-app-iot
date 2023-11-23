// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class Tab1Content extends StatefulWidget {
  const Tab1Content({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Tab1ContentState createState() => _Tab1ContentState();
}

class _Tab1ContentState extends State<Tab1Content> {
  bool isRegistered = true;
  bool allPermissions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 1,
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 3,
          physics: const BouncingScrollPhysics(),
          children: [
            Visibility(
              visible: true,
              child: DashboardItem(
                title: allPermissions
                    ? 'Permissions up to Date'
                    : 'Give Required Permissions',
                icon: Icons.update,
                onTap: () {},
              ),
            ),
            Visibility(
              visible: true,
              child: DashboardItem(
                title: isRegistered
                    ? 'Current Device Registered.'
                    : 'Register This Device',
                icon: Icons.device_hub,
                onTap: () {},
              ),
            ),
            Visibility(
              visible: isRegistered,
              child: DashboardItem(
                title: 'Your IMEI',
                icon: Icons.phone_android,
                onTap: () {
                  // Handle the tap for Your IMEI
                  print('Tapped Your IMEI');
                },
              ),
            ),
            Visibility(
              visible: isRegistered,
              child: DashboardItem(
                title: 'Internet Status',
                icon: Icons.wifi,
                onTap: () {},
              ),
            ),
            Visibility(
              visible: isRegistered,
              child: DashboardItem(
                title: 'Your IP Address',
                icon: Icons.network_check,
                onTap: () {
                  // Handle the tap for Your IP
                  print('Tapped Your IP');
                },
              ),
            ),
            Visibility(
              visible: isRegistered,
              child: DashboardItem(
                title: 'Bluetooth Status',
                icon: Icons.bluetooth,
                onTap: () {},
              ),
            ),
            Visibility(
              visible: isRegistered,
              child: DashboardItem(
                title: 'MAC Address',
                icon: Icons.devices,
                onTap: () {},
              ),
            ),
            Visibility(
              visible: isRegistered,
              child: DashboardItem(
                title: 'Notifications',
                icon: Icons.notifications,
                onTap: () {
                  // Handle the tap for Notification Daemon Status
                  print('Tapped Notification Daemon Status');
                },
              ),
            ),
            Visibility(
              visible: isRegistered,
              child: DashboardItem(
                title: 'Camera Access',
                icon: Icons.camera_alt,
                onTap: () {
                  // Handle the tap for Camera Access
                  print('Tapped Camera Access');
                },
              ),
            ),
            Visibility(
              visible: isRegistered,
              child: DashboardItem(
                title: 'Location Access',
                icon: Icons.location_on,
                onTap: () {
                  // Handle the tap for Location Access
                  print('Tapped Location Access');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isEditable;
  final String editableText;
  final ValueChanged<String>? onTextEdited;

  const DashboardItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isEditable = false,
    this.editableText = '',
    this.onTextEdited,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.blue,
            ),
            const SizedBox(width: 8.0),
            isEditable
                ? Expanded(
                    child: TextField(
                      controller: TextEditingController(text: editableText),
                      onChanged: onTextEdited,
                    ),
                  )
                : Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
