import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette (from maquette)
  static const Color primary = Color(0xFF1B2A6B); // Indigo
  static const Color indigoDark = Color(0xFF0D1438); // Fond principal sombre
  static const Color cardDark = Color(0xFF111A45); // Card body
  static const Color accent = Color(0xFFF07840); // Orange unique

  // Lines & Fields (verre dépoli)
  static const Color line = Color(0x1FFFFFFF); // rgba(255,255,255,.12)
  static const Color field = Color(0x0DFFFFFF); // rgba(255,255,255,.05)
  static const Color fieldFocus = Color(0x17FFFFFF); // rgba(255,255,255,.09)

  // Text variants
  static const Color text = Color(0xFFFFFFFF);
  static const Color muted = Color(0x7FFFFFFF); // rgba(255,255,255,.5)
  static const Color mutedSoft = Color(0x60FFFFFF); // rgba(255,255,255,.38)

  // Light Mode
  static const Color backgroundLight = Color(0xFFF4F6FF);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF0D1438);
  static const Color textSecondaryLight = Color(0xFF5C6584);
  static const Color surfaceSecondaryLight = Color(0xFFFFE8DC);

  // Dark Mode
  static const Color backgroundDark = Color(0xFF0D1438);
  static const Color surfaceDark = Color(0xFF111A45);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0x7FFFFFFF);
  static const Color surfaceSecondaryDark = Color(0xFF1E293B);

  // Functional Colors (work in both modes)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF94A3B8);
  static const Color greyLight = Color(0xFFE2E8F0);
  static const Color greyDark = Color(0xFF5C6584);
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
