import 'package:flutter/material.dart';

class TaskSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const TaskSectionTitle({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text("See All"),
        ),
      ],
    );
  }
}