import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:worksync_ai/widgets/app_bottom_navbar.dart';

/// Shell screen used by GoRouter's StatefulShellRoute. Each branch
/// (Dashboard/Projects/Tasks/Calendar/Profile) keeps its own navigation
/// stack and state when switching tabs.
class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}