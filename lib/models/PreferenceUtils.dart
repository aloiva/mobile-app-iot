// ignore_for_file: file_names

import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/main.dart';

class PreferenceUtils {
  static SharedPreferences? _prefsInstance;
  // static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    setDefaults();
    return _prefsInstance!;
  }

  static String getString(String key, [String? defValue]) {
    _prefsInstance ??= globalPrefs!;
    var res = _prefsInstance!.getString(key) ?? defValue ?? "";
    globalPrefs = _prefsInstance;
    return res;
  }

  static bool getBool(String key) {
    _prefsInstance ??= globalPrefs!;
    var res = _prefsInstance!.getBool(key) ?? false;
    globalPrefs = _prefsInstance;
    return res;
  }

  static Future<bool> setString(String key, String value) async {
    _prefsInstance ??= globalPrefs!;
    //   var prefs = await _instance;
    //   return prefs.setString(key, value);
    var res = _prefsInstance!.setString(key, value);
    globalPrefs = _prefsInstance;
    return res;
  }

  static Future<bool> setBool(String key, bool value) async {
    _prefsInstance ??= globalPrefs!;
    var res = _prefsInstance!.setBool(key, value);
    globalPrefs = _prefsInstance;
    return res;
  }

  static void setDefaults() {
    PreferenceUtils.setString(AppSettingsKeys.loginEndPoint, 'https://httpbin.org/status/200');
    PreferenceUtils.setString(AppSettingsKeys.registerEndpoint, 'https://httpbin.org/status/200');
    PreferenceUtils.setString(AppSettingsKeys.locationEndpoint, 'https://httpbin.org/status/200');
    PreferenceUtils.setString(AppSettingsKeys.imageEndpoint, 'https://httpbin.org/status/200');
    PreferenceUtils.setString(AppSettingsKeys.deviceRegisterEndpoint, 'https://httpbin.org/status/200');
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
