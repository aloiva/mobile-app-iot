import 'package:flutter/material.dart';

class Tab2Content extends StatelessWidget {
  const Tab2Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Content for Tab 2'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle button press for Tab 2
              // You can add logic to update data or perform actions
            },
            child: const Text('Button in Tab 2'),
          ),
        ],
      ),
    );
  }
}
