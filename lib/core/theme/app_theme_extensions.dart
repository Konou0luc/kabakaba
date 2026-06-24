import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeExtension on ThemeData {
  Color get appBackground =>
      brightness == Brightness.light ? AppColors.backgroundLight : AppColors.backgroundDark;

  Color get appSurface =>
      brightness == Brightness.light ? AppColors.surfaceLight : AppColors.surfaceDark;

  Color get appTextPrimary =>
      brightness == Brightness.light ? AppColors.textPrimaryLight : AppColors.textPrimaryDark;

  Color get appTextSecondary =>
      brightness == Brightness.light ? AppColors.textSecondaryLight : AppColors.textSecondaryDark;

  Color get appSurfaceSecondary =>
      brightness == Brightness.light ? AppColors.surfaceSecondaryLight : AppColors.surfaceSecondaryDark;
}
