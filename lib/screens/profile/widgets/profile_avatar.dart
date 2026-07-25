import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../profile_view_model.dart';

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final user = state.user;
    
    final bool hasValidPhoto = user?.photoUrl != null && user!.photoUrl!.trim().isNotEmpty;

    return CircleAvatar(
      radius: 55,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: hasValidPhoto
            ? Image.network(
                user.photoUrl!,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 55, color: Colors.grey);
                },
              )
            : const Icon(Icons.person, size: 55, color: Colors.grey),
      ),
    );
  }
}
