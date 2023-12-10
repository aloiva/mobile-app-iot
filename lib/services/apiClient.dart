// ignore_for_file: camel_case_types

import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class apiClient {
  // static const String baseUrl = "http://172.20.242.44:23456";
  static final String baseUrl = PreferenceUtils.getString(AppSettingsKeys.baseURL);

  static Future<http.Response> getUser(String userID) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userID'));
    return response;
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    return _handleListResponse(response);
  }

  static Future<http.Response> getUserLocation(String userID) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userID/location'));
    return response;
  }

  static Future<http.Response> getUserPartner(String userID) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userID/partner'));
    return response;
  }

  static Future<http.Response> updateNotification(String userID) async {
    final response = await http.post(Uri.parse('$baseUrl/user/$userID/notification/update'));
    return response;
  }

  static Future<http.Response> stolenNotification(String userID) async {
    final response = await http.post(Uri.parse('$baseUrl/user/$userID/notification/stolen'));
    return response;
  }

  static Future<http.Response> registerUser(Map<String, dynamic> userData) async {
    // needed:id, username, token, latitude, longitude, altitude, speed, accuracy
    // userdata only has username, id
    print(userData);
    userData["token"] = PreferenceUtils.getString(UserSettingKeys.token);
    Position pos = await _determinePosition();
    userData["latitude"] = "${pos.latitude}";
    userData["longitude"] = "${pos.longitude}";
    userData["speed"] = "${pos.speed}";
    userData["accuracy"] = "${pos.accuracy}";
    userData["altitude"] = "${pos.altitude}";
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      body: jsonEncode(userData),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  static Future<http.Response> loginUser(Map<String, dynamic> userData) async {
    // needed:id, username, token, latitude, longitude, altitude, speed, accuracy
    // userdata only has username, id
    print(userData);
    userData["token"] = PreferenceUtils.getString(UserSettingKeys.token);
    Position pos = await _determinePosition();
    userData["latitude"] = "${pos.latitude}";
    userData["longitude"] = "${pos.longitude}";
    userData["speed"] = "${pos.speed}";
    userData["accuracy"] = "${pos.accuracy}";
    userData["altitude"] = "${pos.altitude}";
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      body: jsonEncode(userData),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  static Future<http.Response> deleteUser(String userID) async {
    final response = await http.delete(Uri.parse('$baseUrl/user/$userID'));
    return response;
  }

  static Future<http.Response> registerPartner(String userID, String partnerUsername, String partnerID) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/$userID/partner/register'),
      body: jsonEncode({'partnerusername': partnerUsername, 'partnerid': partnerID}),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  static Future<http.Response> unregisterPartner(String userID) async {
    final response = await http.put(Uri.parse('$baseUrl/user/$userID/partner/unregister'));
    return response;
  }

  static Future<http.Response> updateLocation(String userID) async {
    Position pos = await _determinePosition();
    var locationData = {
      'latitude': '${pos.latitude}',
      'longitude': '${pos.longitude}',
      'speed': '${pos.speed}',
      'accuracy': '${pos.accuracy}',
      'altitude': '${pos.altitude}'
    };
    final response = await http.put(
      Uri.parse('$baseUrl/user/$userID/location'),
      body: jsonEncode(locationData),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    // return
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to perform the request. Status code: ${response.statusCode}');
    }
  }

  static List<Map<String, dynamic>> _handleListResponse(http.Response response) {
    if (response.statusCode == 200) {
      // Assuming the response is a List
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to perform the request. Status code: ${response.statusCode}');
    }
  }

  static Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
