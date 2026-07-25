import 'package:flutter/material.dart';

class ProfileStatsCard extends StatelessWidget {
  final int projects;
  final int tasks;
  final int teams;

  const ProfileStatsCard({
    super.key,
    required this.projects,
    required this.tasks,
    required this.teams,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            value: projects.toString(),
            title: "Projects",
          ),
          const SizedBox(
            height: 45,
            child: VerticalDivider(),
          ),
          _StatItem(
            value: tasks.toString(),
            title: "Tasks",
          ),
          const SizedBox(
            height: 45,
            child: VerticalDivider(),
          ),
          _StatItem(
            value: teams.toString(),
            title: "Teams",
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String title;

  const _StatItem({
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
