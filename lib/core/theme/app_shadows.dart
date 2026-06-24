import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get soft => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get hard => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.12),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ];
}
