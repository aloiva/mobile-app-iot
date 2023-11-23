import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class Notifications {
  final _firebase = FirebaseMessaging.instance;

  Future<void> init() async {
    await _firebase.requestPermission();
    final token = await _firebase.getToken();
    print('token: {$token}');
  }
}
