import 'package:flutter/material.dart';

/// Centralized color palette for WorkSync AI.
/// Do not hardcode colors in screens/widgets — always reference AppColors.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF6C4CE0);
  static const Color primaryDark = Color(0xFF4B2FC9);
  static const Color secondary = Color(0xFF00B8A9);
  static const Color tertiary = Color(0xFFFFA726);

  // Light surface
  static const Color lightBackground = Color(0xFFF7F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEDEBF5);
  static const Color lightOutline = Color(0xFFDDDBE8);

  // Dark surface
  static const Color darkBackground = Color(0xFF121016);
  static const Color darkSurface = Color(0xFF1C1A22);
  static const Color darkSurfaceVariant = Color(0xFF2A2732);
  static const Color darkOutline = Color(0xFF3A3745);

  // Text
  static const Color textPrimaryLight = Color(0xFF1B1B1F);
  static const Color textSecondaryLight = Color(0xFF6E6B78);
  static const Color textPrimaryDark = Color(0xFFF2F0F7);
  static const Color textSecondaryDark = Color(0xFFAEA9BC);

  // Status
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2F80ED);

  // Task priority
  static const Color priorityHigh = Color(0xFFE53935);
  static const Color priorityMedium = Color(0xFFF5A623);
  static const Color priorityLow = Color(0xFF2ECC71);

  // Task status
  static const Color statusTodo = Color(0xFF9E9E9E);
  static const Color statusInProgress = Color(0xFF2F80ED);
  static const Color statusDone = Color(0xFF2ECC71);

  static const List<Color> aiGradient = [
    Color(0xFF6C4CE0),
    Color(0xFF00B8A9),
  ];
}