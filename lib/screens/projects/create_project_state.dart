import 'package:flutter/material.dart';
import '../../domain/entities/app_user_entity.dart';

class CreateProjectState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String projectName;
  final String description;
  final String aiPrompt;
  final List<AppUserEntity> selectedMembers;
  final Color selectedColor;
  final IconData selectedIcon;

  const CreateProjectState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.projectName = '',
    this.description = '',
    this.aiPrompt = '',
    this.selectedMembers = const [],
    this.selectedColor = const Color(0xFF6366F1),
    this.selectedIcon = Icons.folder,
  });

  CreateProjectState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? projectName,
    String? description,
    String? aiPrompt,
    List<AppUserEntity>? selectedMembers,
    Color? selectedColor,
    IconData? selectedIcon,
    bool clearError = false,
  }) {
    return CreateProjectState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      aiPrompt: aiPrompt ?? this.aiPrompt,
      selectedMembers: selectedMembers ?? this.selectedMembers,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedIcon: selectedIcon ?? this.selectedIcon,
    );
  }
}
