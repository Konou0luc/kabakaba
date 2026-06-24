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

    final baseStyle = GoogleFonts.montserrat();

    return TextTheme(
      displayLarge: baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      displayMedium: baseStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        letterSpacing: -0.5,
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
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: primaryColor,
      ),
      labelLarge: baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.1,
      ),
      labelMedium: baseStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: primaryColor,
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

  // Styles without hardcoded colors for better theme adaptation
  static TextStyle get h1 => GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  static TextStyle get h2 => GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  static TextStyle get h3 =>
      GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle get bodyLarge =>
      GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle get bodyMedium =>
      GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.normal);
  static TextStyle get bodySmall =>
      GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.normal);
  static TextStyle get labelLarge => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
  static TextStyle get labelMedium =>
      GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w600);
  static TextStyle get caption =>
      GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.normal);
}
