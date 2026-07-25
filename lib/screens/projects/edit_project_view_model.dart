import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'package:worksync_ai/domain/entities/project_entity.dart';
import 'edit_project_state.dart';

class EditProjectViewModel extends Notifier<EditProjectState> {
  @override
  EditProjectState build() {
    return const EditProjectState();
  }

  void init(ProjectEntity project) {
    state = state.copyWith(
      selectedColor: project.color,
      selectedIcon: project.icon,
    );
  }

  void updateColor(Color color) => state = state.copyWith(selectedColor: color);
  void updateIcon(IconData icon) => state = state.copyWith(selectedIcon: icon);

  Future<void> updateProject(ProjectEntity project) async {
    state = state.copyWith(isLoading: true, clearError: true, isSuccess: false);
    try {
      await ref.read(projectUsecasesProvider).updateProject(project);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteProject(String projectId) async {
    state = state.copyWith(isLoading: true, clearError: true, isSuccess: false);
    try {
      await ref.read(projectUsecasesProvider).deleteProject(projectId);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final editProjectViewModelProvider = NotifierProvider<EditProjectViewModel, EditProjectState>(
  EditProjectViewModel.new,
);
