import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Trip.Console typography scale.
/// Headings -> Outfit, body/labels -> Work Sans (Material 3 type scale).
class AppTextStyles {
  AppTextStyles._();

  // ─── Headings (Outfit) ────────────────────────────────────────────────
  static TextStyle h1({Color color = AppColors.textDark}) => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.02 * 32,
        color: color,
      );

  static TextStyle h2({Color color = AppColors.textDark}) => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.01 * 24,
        color: color,
      );

  static TextStyle h3({Color color = AppColors.textDark}) => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      );

  // ─── Body (Work Sans) ─────────────────────────────────────────────────
  static TextStyle bodyLg({Color color = AppColors.textDark}) => GoogleFonts.workSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: color,
      );

  static TextStyle bodySm({Color color = AppColors.textGrey}) => GoogleFonts.workSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle button({Color color = AppColors.backgroundWhite}) => GoogleFonts.workSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: color,
      );

  static TextStyle labelCaps({Color color = AppColors.textGrey}) => GoogleFonts.workSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.0,
        letterSpacing: 0.1 * 12,
        color: color,
      );
}
