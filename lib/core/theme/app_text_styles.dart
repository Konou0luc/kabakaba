import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextTheme getTextTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    final baseStyle = GoogleFonts.plusJakartaSans();

    return TextTheme(
      displayLarge: baseStyle.copyWith(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: primaryColor,
        letterSpacing: -0.02,
      ),
      displayMedium: baseStyle.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.01,
      ),
      displaySmall: baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      bodyLarge: baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      bodyMedium: baseStyle.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: primaryColor,
      ),
      bodySmall: baseStyle.copyWith(
        fontSize: 12.5,
        fontWeight: FontWeight.normal,
        color: primaryColor,
      ),
      labelLarge: baseStyle.copyWith(
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      labelMedium: baseStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: 0.04,
      ),
      titleMedium: baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      titleSmall: baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
    );
  }

  // Maquette-specific styles
  static TextStyle get heroTitle => GoogleFonts.plusJakartaSans(
    fontSize: 21,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
    color: AppColors.white,
  );

  static TextStyle get heroSubtitle => GoogleFonts.plusJakartaSans(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.white.withValues(alpha: 0.62),
  );

  static TextStyle get fieldLabel => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.04,
    color: AppColors.muted,
  );

  static TextStyle get inputText => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static TextStyle get inputPlaceholder => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedSoft,
  );

  static TextStyle get buttonPrimary => GoogleFonts.plusJakartaSans(
    fontSize: 14.5,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle get progressPill => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.02,
    color: AppColors.white.withValues(alpha: 0.85),
  );

  static TextStyle get balanceAmount => GoogleFonts.plusJakartaSans(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
    color: AppColors.white,
  );

  static TextStyle get balanceLabel => GoogleFonts.plusJakartaSans(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.04,
    color: AppColors.white.withValues(alpha: 0.55),
  );

  static TextStyle get sectionTitle => GoogleFonts.plusJakartaSans(
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle get footLink => GoogleFonts.plusJakartaSans(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
  );

  static TextStyle get greetLabel => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.03,
    color: AppColors.white.withValues(alpha: 0.5),
  );

  static TextStyle get greetName => GoogleFonts.plusJakartaSans(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle get hintText => GoogleFonts.plusJakartaSans(
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    height: 1.55,
    color: AppColors.white.withValues(alpha: 0.75),
  );

  static TextStyle get successTitle => GoogleFonts.plusJakartaSans(
    fontSize: 21,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.01,
    color: AppColors.white,
  );

  static TextStyle get successSubtitle => GoogleFonts.plusJakartaSans(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: AppColors.white.withValues(alpha: 0.62),
  );

  // Legacy styles without hardcoded colors for theme adaptation
  static TextStyle get h1 => GoogleFonts.plusJakartaSans(
    fontSize: 21,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
  );
  static TextStyle get h2 => GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  static TextStyle get h3 =>
      GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle get bodyLarge =>
      GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle get bodyMedium =>
      GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.normal);
  static TextStyle get bodySmall =>
      GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.normal);
  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
  static TextStyle get labelMedium =>
      GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600);
  static TextStyle get caption =>
      GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.normal);
}
