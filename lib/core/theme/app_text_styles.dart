import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized text styles for WorkSync AI.
/// Use via Theme.of(context).textTheme in widgets, not these statics directly,
/// unless a one-off style outside the TextTheme scale is needed.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  static TextTheme lightTextTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: AppColors.textPrimaryLight),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: AppColors.textPrimaryLight),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.textPrimaryLight),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimaryLight),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondaryLight),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondaryLight),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
  );

  static TextTheme darkTextTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: AppColors.textPrimaryDark),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: AppColors.textPrimaryDark),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.textPrimaryDark),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimaryDark),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondaryDark),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondaryDark),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondaryDark),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondaryDark),
  );
}