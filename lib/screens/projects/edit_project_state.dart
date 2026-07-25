import 'package:flutter/material.dart';

class EditProjectState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Color selectedColor;
  final IconData selectedIcon;

  const EditProjectState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.selectedColor = const Color(0xFF6366F1),
    this.selectedIcon = Icons.folder,
  });

  EditProjectState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Color? selectedColor,
    IconData? selectedIcon,
    bool clearError = false,
  }) {
    return EditProjectState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedColor: selectedColor ?? this.selectedColor,
      selectedIcon: selectedIcon ?? this.selectedIcon,
    );
  }
}
