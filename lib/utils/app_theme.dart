import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Material 3 ThemeData for Trip.Console.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textDark),
      displayMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textDark),
      headlineLarge: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textDark),
      headlineMedium: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark),
      titleLarge: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
      bodyLarge: GoogleFonts.workSans(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textDark),
      bodyMedium: GoogleFonts.workSans(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textGrey),
      labelLarge: GoogleFonts.workSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.backgroundWhite),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentOrange,
        tertiary: AppColors.mintGreen,
        surface: AppColors.backgroundWhite,
        error: AppColors.error,
      ),
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentOrange,
          foregroundColor: AppColors.backgroundWhite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundWhite,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        titleTextStyle: textTheme.headlineMedium,
      ),
    );
  }
}
