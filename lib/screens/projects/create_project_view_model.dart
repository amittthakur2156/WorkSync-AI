import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/constants/enums.dart';
import 'package:worksync_ai/core/providers/auth_providers.dart';
import 'package:worksync_ai/core/providers/notification_providers.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'package:worksync_ai/domain/entities/app_user_entity.dart';
import 'package:worksync_ai/domain/entities/project_entity.dart';
import 'create_project_state.dart';

class CreateProjectViewModel extends Notifier<CreateProjectState> {
  @override
  CreateProjectState build() {
    return const CreateProjectState();
  }

  void updateProjectName(String value) =>
      state = state.copyWith(projectName: value, clearError: true);
  void updateDescription(String value) =>
      state = state.copyWith(description: value, clearError: true);
  void updateAiPrompt(String value) =>
      state = state.copyWith(aiPrompt: value, clearError: true);
  void updateColor(Color color) =>
      state = state.copyWith(selectedColor: color);
  void updateIcon(IconData icon) =>
      state = state.copyWith(selectedIcon: icon);

  void addMember(AppUserEntity user) {
    if (state.selectedMembers.any((m) => m.uid == user.uid)) return;
    if (state.selectedMembers.length >= 4) {
      state = state.copyWith(errorMessage: "Maximum 4 members allowed");
      return;
    }
    state = state.copyWith(
      selectedMembers: [...state.selectedMembers, user],
      clearError: true,
    );
  }

  void removeMember(String uid) {
    state = state.copyWith(
      selectedMembers: state.selectedMembers.where((m) => m.uid != uid).toList(),
    );
  }

  Future<void> generateWithAI() async {
    if (state.aiPrompt.isEmpty) {
      state = state.copyWith(errorMessage: "Please describe your idea first");
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      projectName: "AI: ${state.aiPrompt}",
      description: "This project was generated based on your idea: ${state.aiPrompt}",
    );
  }

  Future<void> createProject() async {
    if (state.projectName.trim().isEmpty) {
      state = state.copyWith(errorMessage: "Project name is required");
      return;
    }

    state = state.copyWith(isLoading: true, isSuccess: false, clearError: true);

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception("User not authenticated");

      final project = ProjectEntity(
        id: '', 
        ownerId: user.uid,
        title: state.projectName,
        description: state.description,
        status: ProjectStatus.active,
        color: state.selectedColor,
        icon: state.selectedIcon,
        progress: 0.0,
        memberIds: [user.uid], // Only add owner initially
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final projectId = await ref.read(projectUsecasesProvider).createProject(project);

      // Send invitations to selected members
      for (final member in state.selectedMembers) {
        await ref.read(notificationUsecasesProvider).sendInvitation(
          targetUserId: member.uid,
          projectId: projectId,
          projectTitle: project.title,
          senderName: user.name,
        );
      }

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final createProjectViewModelProvider =
    NotifierProvider<CreateProjectViewModel, CreateProjectState>(
  CreateProjectViewModel.new,
);
