import 'package:flutter/material.dart';

class ProjectTile extends StatelessWidget {
  final String title;
  final String description;
  final double progress;
  final int tasks;
  final int members;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const ProjectTile({
    super.key,
    required this.title,
    required this.description,
    required this.progress,
    required this.tasks,
    required this.members,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
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
                  radius: 24,
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
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// Bottom Row
            Row(
              children: [
                const Icon(
                  Icons.task_alt,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text("$tasks Tasks"),
                const SizedBox(width: 20),
                const Icon(
                  Icons.group_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text("$members Members"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
