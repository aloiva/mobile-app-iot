// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mobile_app/services/notifications.dart';
import 'package:http/http.dart' as http;

class Tab2Content extends StatefulWidget {
  const Tab2Content({Key? key}) : super(key: key);

  @override
  _Tab2ContentState createState() => _Tab2ContentState();
}

class _Tab2ContentState extends State<Tab2Content> {
  int seconds = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<int>? res;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('button pressed');
              res = Notifications.sendUpdate();
              // Notification.(); // Call the function to send the POST request
            },
            child: const Text('Update your partner now.'),
          ),
          const SizedBox(height: 10), // Adjust the height as needed
          Text('Response: $res'),
        ],
      ),
    );
  }
}
