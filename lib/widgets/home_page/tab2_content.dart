// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';
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
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        seconds++;
      });
    });
  }

  Future<void> _sendPostRequest() async {
    // Replace 'YOUR_URL' with the actual URL where you want to send the POST request
    final String url = 'YOUR_URL';

    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        print('POST request successful');
      } else {
        print('Failed to send POST request. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending POST request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Seconds Elapsed: $seconds',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('Button pressed');
              _sendPostRequest(); // Call the function to send the POST request
            },
            child: const Text('Button in Tab 2'),
          ),
        ],
      ),
    );
  }
}
