// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
import 'dart:async';
import 'package:mobile_app/services/apiClient.dart';

class Notifications {
  final _firebase = FirebaseMessaging.instance;
  static final id = PreferenceUtils.getString(UserSettingKeys.imei);

  Future<void> init() async {
    await _firebase.requestPermission();
    final token = await _firebase.getToken();
    print('token: {$token}');
    // update your token in settings:
    PreferenceUtils.setString(UserSettingKeys.token, token.toString());
  }

  static Future<Map<String, dynamic>> sendUpdate() async {
    final response = await apiClient.updateNotification(id);
    if (response.statusCode == 200) {
      print('POST request successful: ${response.body}');
    } else {
      print('Failed to send POST request. Status code: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> sendStolen() async {
    final response = await apiClient.stolenNotification(id);
    if (response.statusCode == 200) {
      print('POST request successful: ${response.body}');
    } else {
      print('Failed to send POST request. Status code: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }
}
