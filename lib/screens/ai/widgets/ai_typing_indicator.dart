import 'package:flutter/material.dart';

class AITypingIndicator extends StatelessWidget {
  const AITypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          "AI is typing...",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}