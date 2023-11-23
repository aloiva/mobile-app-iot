// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class Notifications {
  final _firebase = FirebaseMessaging.instance;

  Future<void> init() async {
    await _firebase.requestPermission();
    final token = await _firebase.getToken();
    print('token: {$token}');
    // update your token in settings:
    PreferenceUtils.setString(UserSettingKeys.token, token.toString());
    // _firebase.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     // Handle the incoming message when the app is in the foreground
    //     // You can show a local notification or update the UI here
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // Handle the incoming message when the app is launched from terminated state
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // Handle the incoming message when the app is resumed from the background
    //   },
    // );
  }

  static Future<int> sendUpdate() async {
    final url = PreferenceUtils.getString(AppSettingsKeys.firebaseAPIURL);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=${PreferenceUtils.getString(AppSettingsKeys.authtoken)}',
    };

    final data = {
      'to': PreferenceUtils.getString(UserSettingKeys.partnertoken),
      'notification': {
        'body': 'Your partner just updated their device status!',
        'content_available': true,
        'priority': 'high',
        'subtitle': '',
        'title': 'Partner Device Status Update',
      },
      'data': {
        'priority': 'high',
        'sound': 'app_sound.wav',
        'content_available': true,
        'bodyText': 'Your partner just updated their device status!',
        'organization': PreferenceUtils.getString(UserSettingKeys.org),
      },
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print('POST request successful: ${response.body}');
    } else {
      print('Failed to send POST request. Status code: ${response.statusCode}');
    }
    return response.statusCode;
  }

  static Future<int> sendStolen() async {
    final url = PreferenceUtils.getString(AppSettingsKeys.firebaseAPIURL);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=${PreferenceUtils.getString(AppSettingsKeys.authtoken)}',
    };

    final data = {
      'to': PreferenceUtils.getString(UserSettingKeys.partnertoken),
      'notification': {
        'body': 'Your partner just updated their device status!',
        'content_available': true,
        'priority': 'high',
        'subtitle': '',
        'title': 'Partner Device Status Update',
      },
      'data': {
        'priority': 'high',
        'sound': 'app_sound.wav',
        'content_available': true,
        'bodyText': 'Your partner just updated their device status!',
        'organization': PreferenceUtils.getString(UserSettingKeys.org),
      },
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print('POST request successful: ${response.body}');
    } else {
      print('Failed to send POST request. Status code: ${response.statusCode}');
    }
    return response.statusCode;
  }
}
