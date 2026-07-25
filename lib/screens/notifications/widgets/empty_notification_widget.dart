import 'package:flutter/material.dart';

class EmptyNotificationWidget extends StatelessWidget {
  const EmptyNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            Icons.notifications_off_outlined,
            size: 90,
            color: Colors.blue,
          ),

          SizedBox(height: 20),

          Text(
            "No Notifications",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10),

          Text(
            "You're all caught up.\nNew notifications will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),

        ],
      ),
    );
  }
}