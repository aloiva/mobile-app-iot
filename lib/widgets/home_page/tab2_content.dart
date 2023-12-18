// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/models/PreferenceUtils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/services/notifications.dart';
import 'package:mobile_app/services/apiClient.dart';
import 'package:permission_handler/permission_handler.dart';

class Tab2Content extends StatefulWidget {
  const Tab2Content({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Tab2ContentState createState() => _Tab2ContentState();
}

class _Tab2ContentState extends State<Tab2Content> {
  bool isRegistered = PreferenceUtils.getBool(UserSettingKeys.isdeviceregistered);
  DateTime lastupdatedtime = DateTime.now();
  var lastnotificationstatus;

  //////////
  String partnerusername = "null", partnerid = "null";

  var lat = "null", long = "null", speed = "null", acc = "null", alt = "null";

  // partner location details
  var olat = "null", olon = "null", ospeed = "null", oacc = "null", oalt = "null";

  bool isgetyourlocloading = false;
  bool isgettheirlocloading = false;

  bool isupdatelocloading = false;
  bool isupdatenotifloading = false;
  bool istheftnotifloading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isRegistered = PreferenceUtils.getBool(UserSettingKeys.isdeviceregistered);
    });
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _imeiController = TextEditingController();

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
                controller: _imeiController,
                decoration: const InputDecoration(labelText: 'Partner Device\'s IMEI'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter their IMEI';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _showRegistrationConfirmationDialog();
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
                  _buildChildItemWithCopy('Username: $partnerusername'),
                  _buildChildItemWithCopy('IMEI: $partnerid'),
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
                  if (isgettheirlocloading)
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
                _getPartnerLoc();
              },
              child: const Text('Get Partner\'s last location.'),
            ),
            const SizedBox(width: 10),
            if (isgettheirlocloading) const CircularProgressIndicator(),
          ]),

          // your last location
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Your last location as per your partner'),
                children: <Widget>[
                  if (isgetyourlocloading)
                    const LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  _buildChildItemWithCopy('Latitude: $lat'),
                  _buildChildItemWithCopy('Longitude: $long'),
                  _buildChildItemWithCopy('Altitude: $alt'),
                  _buildChildItemWithCopy('Speed: $speed'),
                  _buildChildItemWithCopy('Accuracy: $acc'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                _getYourLoc();
              },
              child: const Text('Get your last location.'),
            ),
            const SizedBox(width: 10),
            if (isgetyourlocloading) const CircularProgressIndicator(),
          ]),

          // status of last update
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: ExpansionTile(
                leading: const Icon(Icons.star),
                title: const Text('Last update and notification status'),
                children: <Widget>[
                  if (isupdatenotifloading || istheftnotifloading || isupdatelocloading)
                    const LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  _buildChildItemWithCopy('Last updated location on network: $lastupdatedtime'),
                  _buildChildItemWithCopy('Last sent notification status: $lastnotificationstatus'),
                ],
              ),
            ),
          ),

          // update location on server
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                _handleUpdateLocation();
              },
              child: const Text('Update your last location to fabric.'),
            ),
            const SizedBox(width: 10),
            if (isupdatelocloading) const CircularProgressIndicator(),
          ]),

          // update notification
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                _handleUpdateNotif();
              },
              child: const Text('Send update notification to partner.'),
            ),
            const SizedBox(width: 10),
            if (isupdatenotifloading) const CircularProgressIndicator(),
          ]),

          // theft notification button
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                _handleTheftNotif();
              },
              child: const Text('Send theft notification to partner.'),
            ),
            const SizedBox(width: 10),
            if (istheftnotifloading) const CircularProgressIndicator(),
          ]),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _showUnregisterConfirmationDialog();
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

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // You can add a snackbar or any other feedback here to indicate that the text has been copied.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
      ),
    );
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

  void _getPartnerLoc() async {
    setState(() {
      isgettheirlocloading = true;
    });
    try {
      final response = await apiClient.getUserLocation(PreferenceUtils.getString(PartnerSettingKeys.partnerimei));
      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
        var pos = jsonDecode(response.body);
        setState(() {
          olat = pos["latitude"];
          olon = pos["longitude"];
          oalt = pos["altitude"];
          oacc = pos["accuracy"];
          ospeed = pos["speed"];
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    setState(() {
      isgettheirlocloading = false;
    });
  }

  void _getYourLoc() async {
    setState(() {
      isgetyourlocloading = true;
    });
    try {
      final response = await apiClient.getUserLocation(PreferenceUtils.getString(UserSettingKeys.imei));
      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
        var pos = jsonDecode(response.body);
        setState(() {
          lat = pos["latitude"];
          long = pos["longitude"];
          alt = pos["altitude"];
          acc = pos["accuracy"];
          speed = pos["speed"];
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    setState(() {
      isgetyourlocloading = false;
    });
  }

  void _handleUpdateLocation() async {
    setState(() {
      isupdatelocloading = true;
    });
    try {
      final response = await apiClient.updateLocation(PreferenceUtils.getString(UserSettingKeys.imei));
      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    setState(() {
      isupdatelocloading = false;
      lastupdatedtime = DateTime.now();
    });
  }

  void _handleUpdateNotif() async {
    setState(() {
      isupdatenotifloading = true;
    });
    try {
      final response = await apiClient.updateNotification(PreferenceUtils.getString(UserSettingKeys.imei));
      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
        setState(() {
          lastnotificationstatus = response.statusCode;
        });
      } else {
        setState(() {
          lastnotificationstatus = response.statusCode;
        });
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    setState(() {
      isupdatenotifloading = false;
    });
  }

  void _handleTheftNotif() async {
    setState(() {
      istheftnotifloading = true;
    });
    try {
      final response = await apiClient.stolenNotification(PreferenceUtils.getString(UserSettingKeys.imei));
      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    setState(() {
      istheftnotifloading = false;
    });
  }

  void _showUnregisterConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Partner unregistration confirmation'),
          content: const Text('Are you sure you want to unregister this partner?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _unregisterPartner();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _unregisterPartner() async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
                title: Text('Unregistering partner...'),
                content: LinearProgressIndicator(
                  backgroundColor: Color.fromARGB(2, 91, 9, 9), // Set background color
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Set progress color
                ));
          });
      var id = PreferenceUtils.getString(UserSettingKeys.imei);
      var response = await apiClient.unregisterPartner(id);
      print(response);
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        PreferenceUtils.setBool(UserSettingKeys.isdeviceregistered, false);
        setState(() {
          isRegistered = false;
        });
        _showSuccess(context, "unregistered partner");
      } else {
        _showFailure(context, "unregister partner");
      }
    } catch (error) {
      // Close the loading dialog in case of an error
      Navigator.of(context).pop();
      print('Error sending data: $error');
    }
  }

  void _showRegistrationConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Partner registration confirmation'),
          content: const Text('Are you sure you want to register this partner?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _registerPartner();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _registerPartner() async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
                title: Text('Registering partner...'),
                content: LinearProgressIndicator(
                  backgroundColor: Color.fromARGB(2, 91, 9, 9), // Set background color
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Set progress color
                ));
          });
      var id = PreferenceUtils.getString(UserSettingKeys.imei);
      setState(() {
        partnerusername = _usernameController.text;
        partnerid = _imeiController.text;
      });
      var response = await apiClient.registerPartner(id, partnerusername, partnerid);
      print(response);
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        PreferenceUtils.setBool(UserSettingKeys.isdeviceregistered, true);
        setState(() {
          isRegistered = true;
        });
        _showSuccess(context, "registered partner");
      } else {
        _showFailure(context, "register partner");
      }
    } catch (error) {
      // Close the loading dialog in case of an error
      Navigator.of(context).pop();
      print('Error sending data: $error');
    }
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

  void _showFailure(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Failed to $text'),
          content: const Text('Check entered details, or try again in a while.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Okay'),
            )
          ],
        );
      },
    );
  }
}
