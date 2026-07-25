import 'package:flutter/material.dart';

class CalendarDayCard extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;
  final VoidCallback? onTap;

  const CalendarDayCard({
    super.key,
    required this.day,
    required this.date,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xff1055DC)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              day,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              date,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : Colors.black,
              ),
            ),

          ],
        ),
      ),
    );
  }
}