import 'package:flutter/material.dart';
import 'priority_badge.dart';
import 'task_status_chip.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String project;
  final String dueDate;
  final String priority;
  final String status;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const TaskTile({
    super.key,
    required this.title,
    required this.project,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
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

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Top Row
            Row(
              children: [

                CircleAvatar(
                  radius: 22,
                  backgroundColor: color.withValues(alpha: .12),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
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

                TaskStatusChip(status: status),

              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                PriorityBadge(priority: priority),

                const Spacer(),

                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Colors.grey,
                ),

                const SizedBox(width: 6),

                Text(
                  dueDate,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
