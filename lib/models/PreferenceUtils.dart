// ignore: file_names
import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static SharedPreferences? _prefsInstance;
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  // call this method from iniState() function of mainApp().
  static Future<Object> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance ?? '';
  }

  static String getString(String key, [String? defValue]) {
    return _prefsInstance?.getString(key) ?? defValue ?? "";
  }

  static bool getBool(String key) {
    return _prefsInstance?.getBool(key) ?? false;
  }

  static Future<bool> setString(String key, String value) async {
    // var prefs = await _instance;
    // return prefs.setString(key, value);
    return _prefsInstance?.setString(key, value) ?? Future(() => false);
  }

  static Future<bool> setBool(String key, bool value) async {
    return _prefsInstance?.setBool(key, value) ?? Future(() => false);
  }
}

class AppSettingsKeys {
  // Declare static variables
  static String loginEndPoint = "loginEndPoint";
  static String registerEndpoint = "registerEndpoint";
  static String locationEndpoint = "locationEndpoint";
  static String imageEndpoint = "imageEndpoint";
  static String deviceRegisterEndpoint = "deviceRegisterEndpoint";
  // Private constructor to prevent instantiation
  AppSettingsKeys._();
}

class UserDataKeys {
  static String isloggedin = 'isloggedin';
  static String isdeviceregistered = 'isregistered';
  static String username = 'username';
  static String password = 'password';
  static String imei = 'imei';
  static String partnerusername = 'partnerusername';
  static String partnerimei = 'partnerimei';
}
