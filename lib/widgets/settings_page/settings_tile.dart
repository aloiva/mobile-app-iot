import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    Key? key,
    required this.color,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(60),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: color,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                // fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  // color: Colors.grey.shade200,
                  // borderRadius: BorderRadius.circular(15),
                  ),
              child: const Icon(CupertinoIcons.forward),
            ),
          ],
        ),
      ),
    );
  }
}
