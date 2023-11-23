import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/home_page/tab1_content.dart';
import 'package:mobile_app/widgets/home_page/tab2_content.dart';
import 'package:mobile_app/models/app_config.dart';

class HomePage extends StatelessWidget {
  final AppConfig appConfig;

  const HomePage({Key? key, required this.appConfig}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Show the confirmation dialog when the back button is pressed
        bool exit = await showExitConfirmationDialog(context);
        return exit;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Home Page'),
            automaticallyImplyLeading: false,
            actions: [
              // Add a gear icon button to the top right
              IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Navigate to the Settings Page
                    Navigator.pushNamed(context, '/settings');
                  }),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Your Device'),
                Tab(text: 'Your Partner\'s Device'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              // Content for Tab 1
              Tab1Content(),

              // Content for Tab 2
              Tab2Content(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
