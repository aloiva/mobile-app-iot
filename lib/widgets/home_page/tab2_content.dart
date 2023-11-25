// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/services/notifications.dart';
// import 'dart:async';
// import 'package:mobile_app/services/notifications.dart';
// import 'package:http/http.dart' as http;

class Tab2Content extends StatefulWidget {
  const Tab2Content({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Tab2ContentState createState() => _Tab2ContentState();
}

class _Tab2ContentState extends State<Tab2Content> {
  bool isRegistered = PreferenceUtils.getBool(UserSettingKeys.isdeviceregistered);
  String lastlocation = '';
  DateTime lastupdatedtime = DateTime.now();
  var updatestatus;
  bool isupdatestatusloading = false;
  bool istheftstatusloading = false;
  bool istheirlocloading = false;
  bool isyourlocloading = false;

  // your location details
  var latitude = null, longitude = null, speed = null, accuracy = null, altitude = null;

  // partner location details
  var olat = null, olon = null, ospeed = null, oacc = null, oalt = null;

  @override
  void initState() {
    super.initState();
    setState(() {
      isRegistered = PreferenceUtils.getBool(UserSettingKeys.isdeviceregistered);
      // isRegistered = true;
    });
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _imeiController = TextEditingController();

  Widget _buildChildItem(String text, [IconData? icon]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          if (icon != null) Icon(icon),
        ],
      ),
    );
  }

  Widget _buildChildItemWithCopy(String text, [IconData? icon]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          GestureDetector(
            onTap: () {
              _copyToClipboard(text);
            },
            child: const Text(
              'Copy',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // register device form
  Widget _buildViewOne(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Partner\'s username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter partner\'s username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _tokenController,
                decoration: const InputDecoration(labelText: 'Partner Device\'s token'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter their token';
                  }
                  // Add additional token validation logic if needed
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _imeiController,
                decoration: const InputDecoration(labelText: 'Partner Device\'s IMEI (optional)'),
                // No validator for optional field
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Validate the form
                  // Perform registration or submission logic here
                  // Access the input values using _usernameController.text, _tokenController.text, _imeiController.text
                  if (_usernameController.text.isEmpty || _tokenController.text.isEmpty) {
                    _showAlertDialog(context);
                  } else {
                    PreferenceUtils.setBool(UserSettingKeys.isdeviceregistered, true);
                    PreferenceUtils.setString(PartnerSettingKeys.partnerusername, _usernameController.text);
                    PreferenceUtils.setString(PartnerSettingKeys.partnertoken, _tokenController.text);
                    _showSuccess(context, "registered.");
                    setState(() {
                      // send registered data

                      // Toggle the boolean value
                      isRegistered = true;
                    });
                  }
                  print('Username: ${_usernameController.text}');
                  print('token: ${_tokenController.text}');
                  print('Optional Field: ${_imeiController.text}');
                  print(isRegistered);
                },
                child: const Text('Register as your partner\'s device'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // when registered, have their details and last location, last image.
  Widget _buildViewTwo(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // your partners device details
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Your partner\'s device details'),
                children: <Widget>[
                  _buildChildItemWithCopy('Username: ${PreferenceUtils.getString(PartnerSettingKeys.partnerusername)}'),
                  _buildChildItemWithCopy('Token: ${PreferenceUtils.getString(PartnerSettingKeys.partnertoken)}'),
                ],
              ),
            ),
          ),

          // partner's last location
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Your partner\'s last location'),
                children: <Widget>[
                  if (istheirlocloading)
                    const LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  _buildChildItemWithCopy('Latitude: $olat'),
                  _buildChildItemWithCopy('Longitude: $olon'),
                  _buildChildItemWithCopy('Altitude: $oalt'),
                  _buildChildItemWithCopy('Speed: $ospeed'),
                  _buildChildItemWithCopy('Accuracy: $oacc'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                _handleTheirLocation();
              },
              child: const Text('Update Partner\'s last location.'),
            ),
            const SizedBox(width: 10),
            if (istheirlocloading) CircularProgressIndicator(),
          ]),

          // your last location
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Your last location'),
                children: <Widget>[
                  if (isyourlocloading)
                    const LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  _buildChildItemWithCopy('Latitude: $latitude'),
                  _buildChildItemWithCopy('Longitude: $longitude'),
                  _buildChildItemWithCopy('Altitude: $altitude'),
                  _buildChildItemWithCopy('Speed: $speed'),
                  _buildChildItemWithCopy('Accuracy: $accuracy'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                _handleYourLoc();
              },
              child: const Text('Update your location'),
            ),
            const SizedBox(width: 10),
            if (isyourlocloading) CircularProgressIndicator(),
          ]),

          // status of last update
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Status of Your last Update'),
                children: <Widget>[
                  if (isupdatestatusloading || istheftstatusloading)
                    const LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  _buildChildItemWithCopy('Last updated: $lastupdatedtime'),
                  _buildChildItemWithCopy('status: $updatestatus'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                _handleUpdate();
              },
              child: const Text('Send update to your Partner'),
            ),
            const SizedBox(width: 10),
            if (isupdatestatusloading) CircularProgressIndicator(),
            // Container(
            //   width: 20,
            //   height: 20,
            //   if (isupdatestatusloading) CircularProgressIndicator() ,
            // decoration: BoxDecoration(
            //   shape: BoxShape.circle,
            //   color: isupdatestatusloading ? Colors.green : Colors.red,
            // ),
            // margin: const EdgeInsets.only(left: 5),
          ]),

          // unregister button
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                _handletheft();
              },
              child: const Text('Send theft notification.'),
            ),
            const SizedBox(width: 10),
            if (istheftstatusloading) CircularProgressIndicator(),
            // Container(
            //   width: 20,
            //   height: 20,
            //   if (isupdatestatusloading) CircularProgressIndicator() ,
            // decoration: BoxDecoration(
            //   shape: BoxShape.circle,
            //   color: isupdatestatusloading ? Colors.green : Colors.red,
            // ),
            // margin: const EdgeInsets.only(left: 5),
          ]),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Toggle the boolean value
                isRegistered = false;
              });
            },
            child: const Text('Unregister this Partner.'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isRegistered ? _buildViewTwo(context) : _buildViewOne(context),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Username and token cannot be empty. Please get token from your partner\'s mobile app.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('okay'),
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

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // You can add a snackbar or any other feedback here to indicate that the text has been copied.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
      ),
    );
  }

  void _handleUpdate() async {
    setState(() {
      isupdatestatusloading = true;
      isyourlocloading = true;
    });
    var response = await Notifications.sendUpdate();
    // send the above data to location-endpoint.
    var pos = await _determinePosition();
    final String url = PreferenceUtils.getString(AppSettingsKeys.locationEndpoint);
    final Map<String, dynamic> jsonData = {
      'latitude': '${pos.latitude}',
      'longitude': '${pos.longitude}',
      'speed': '${pos.speed}',
      'accuracy': '${pos.accuracy}',
      'altitude': '${pos.altitude}'
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );
      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    var statuscode = response["success"];
    setState(() {
      updatestatus = (statuscode == 1) ? 'success' : 'failed. please check partner\'s token and re register';
      lastupdatedtime = DateTime.now();
      latitude = pos.latitude;
      longitude = pos.longitude;
      speed = pos.speed;
      accuracy = pos.accuracy;
      altitude = pos.altitude;
      isyourlocloading = false;
      isupdatestatusloading = false;
    });
  }

  void _handletheft() async {
    setState(() {
      istheftstatusloading = true;
      isyourlocloading = true;
    });
    var response = await Notifications.sendStolen();
    // send the above data to location-endpoint.
    var pos = await _determinePosition();
    final String url = PreferenceUtils.getString(AppSettingsKeys.locationEndpoint);
    final Map<String, dynamic> jsonData = {
      'latitude': '${pos.latitude}',
      'longitude': '${pos.longitude}',
      'speed': '${pos.speed}',
      'accuracy': '${pos.accuracy}',
      'altitude': '${pos.altitude}'
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );
      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    var statuscode = response["success"];
    setState(() {
      updatestatus = (statuscode == 1) ? 'success' : 'failed. please check partner\'s token and re register';
      lastupdatedtime = DateTime.now();
      latitude = pos.latitude;
      longitude = pos.longitude;
      speed = pos.speed;
      accuracy = pos.accuracy;
      altitude = pos.altitude;
      isyourlocloading = false;
      istheftstatusloading = false;
    });
  }

  Future<Position> _determinePosition() async {
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

  void _handleTheirLocation() {}

  void _handleYourLoc() async {
    setState(() {
      isyourlocloading = true;
    });
    var pos = await _determinePosition();

    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
      speed = pos.speed;
      accuracy = pos.accuracy;
      altitude = pos.altitude;
      isyourlocloading = false;
    });
  }
}
