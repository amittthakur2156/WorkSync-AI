import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worksync_ai/core/routes/app_routes.dart';
import 'profile_view_model.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stats_card.dart';
import 'widgets/profile_section_title.dart';
import 'widgets/profile_menu_tile.dart';
import 'widgets/logout_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);

    ref.listen(profileViewModelProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
      }
    });

    if (state.isLoading && state.user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const ProfileAvatar(),
              const SizedBox(height: 18),
              const ProfileHeader(),
              const SizedBox(height: 28),
              ProfileStatsCard(
                projects: state.projectsCount,
                tasks: state.tasksCount,
                teams: state.teamCount,
              ),
              const SizedBox(height: 35),
              const ProfileSectionTitle(title: "Account"),
              ProfileMenuTile(
                icon: Icons.person_outline,
                title: "Edit Profile",
                onTap: () => context.push(AppRoutes.editProfilePath),
              ),
              ProfileMenuTile(
                icon: Icons.lock_outline,
                title: "Security",
                onTap: () => context.push(AppRoutes.changePasswordPath),
              ),
              ProfileMenuTile(
                icon: Icons.notifications_none,
                title: "Notifications",
                onTap: () => context.push(AppRoutes.notifications),
              ),
              const SizedBox(height: 24),
              const ProfileSectionTitle(title: "Support"),
              ProfileMenuTile(
                icon: Icons.help_outline,
                title: "Help Center",
                onTap: () => _showComingSoon(context, "Help center"),
              ),
              ProfileMenuTile(
                icon: Icons.description_outlined,
                title: "Terms & Privacy",
                onTap: () => _showComingSoon(context, "Terms & Privacy"),
              ),
              ProfileMenuTile(
                icon: Icons.star_border,
                title: "Rate App",
                onTap: () => _showComingSoon(context, "App rating"),
              ),
              const SizedBox(height: 40),
              const LogoutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$feature coming soon! ✨")),
    );
  }
}
