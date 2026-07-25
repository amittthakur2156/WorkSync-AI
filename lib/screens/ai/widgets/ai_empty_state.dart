import 'package:flutter/material.dart';

class AIEmptyState extends StatelessWidget {
  const AIEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircleAvatar(
          radius: 38,
          child: Icon(
            Icons.smart_toy_outlined,
            size: 38,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Hello, Amit 👋",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "How can I help you today?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}