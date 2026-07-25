import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../profile_view_model.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileViewModelProvider).user;

    if (user == null) return const SizedBox.shrink();

    // Improved logic for display name
    final bool hasName = user.name.trim().isNotEmpty;
    final bool nameIsEmail = user.name.contains('@') && user.name == user.email;
    
    final String displayName = (!hasName || nameIsEmail) ? 'Set your name' : user.name;
    final Color nameColor = (!hasName || nameIsEmail) ? Colors.grey : Colors.black87;

    return Column(
      children: [
        Text(
          displayName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: nameColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user.email,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Joined ${DateFormat('MMMM yyyy').format(user.createdAt)}",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
