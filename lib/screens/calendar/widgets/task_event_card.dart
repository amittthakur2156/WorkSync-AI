import 'package:flutter/material.dart';

class TaskEventCard extends StatelessWidget {
  final String time;
  final String title;
  final String project;
  final Color color;
  final IconData icon;

  const TaskEventCard({
    super.key,
    required this.time,
    required this.title,
    required this.project,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            width: 5,
            height: 70,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  time,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  project,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

              ],
            ),
          ),

          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: .12),
            child: Icon(
              icon,
              color: color,
            ),
          ),

        ],
      ),
    );
  }
}
