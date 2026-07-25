import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_providers.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'package:worksync_ai/core/providers/task_providers.dart';
import 'profile_state.dart';

class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    final authAsync = ref.watch(authStateProvider);
    final projectsAsync = ref.watch(myProjectsProvider);
    final tasksAsync = ref.watch(myTasksProvider);

    final currentUser = authAsync.value;
    final projects = projectsAsync.value ?? [];
    final tasks = tasksAsync.value ?? [];

    return ProfileState(
      user: currentUser,
      isLoading: authAsync.isLoading && currentUser == null,
      projectsCount: projects.length,
      tasksCount: tasks.length,
      teamCount: projects.expand((p) => p.memberIds).toSet().length,
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(authUseCasesProvider).signOut();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final profileViewModelProvider = NotifierProvider<ProfileViewModel, ProfileState>(
  ProfileViewModel.new,
);
