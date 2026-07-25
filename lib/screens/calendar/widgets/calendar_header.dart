import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  final String month;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const CalendarHeader({
    super.key,
    required this.month,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),

        Expanded(
          child: Center(
            child: Text(
              month,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}