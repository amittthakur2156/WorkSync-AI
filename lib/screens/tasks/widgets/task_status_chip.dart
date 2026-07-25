import 'package:flutter/material.dart';

class TaskStatusChip extends StatelessWidget {
  final String status;

  const TaskStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case "Completed":
        color = Colors.green;
        break;
      case "In Progress":
        color = Colors.blue;
        break;
      default:
        color = Colors.orange;
    }

    return Chip(
      backgroundColor: color.withValues(alpha: .12),
      label: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}