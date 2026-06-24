import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primary = Color(0xFF1B2A6B); // Indigo
  static const Color accent = Color(0xFFF07840); // Pêche vif

  // Light Mode
  static const Color backgroundLight = Color(0xFFF4F6FF);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF0D1438);
  static const Color textSecondaryLight = Color(0xFF94A3B8);
  static const Color surfaceSecondaryLight = Color(0xFFFFE8DC);

  // Dark Mode
  static const Color backgroundDark = Color(0xFF0D1438);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color surfaceSecondaryDark = Color(0xFF2D1B2C);

  // Functional Colors (work in both modes)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF94A3B8);
  static const Color greyLight = Color(0xFFE2E8F0);
  static const Color greyDark = Color(0xFF475569);
  static const Color greyDarkMode = Color(0xFF334155);
  static const Color greyLightDarkMode = Color(0xFF1E293B);

  // Dynamic colors based on context
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? backgroundLight
      : backgroundDark;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? textPrimaryLight
      : textPrimaryDark;

  static Color surfaceSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? surfaceSecondaryLight
      : surfaceSecondaryDark;
}
