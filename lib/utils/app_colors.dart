import 'package:flutter/material.dart';

/// Trip.Console brand palette — do not introduce ad-hoc colors elsewhere;
/// add new tokens here so the palette stays a single source of truth.
class AppColors {
  AppColors._();

  static const Color primaryGreen = Color(0xFF0D4A3A);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color mintGreen = Color(0xFFA8D5C5);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFF666666);

  // Tonal shades derived from accentOrange, used for gradients/blur accents
  // (matches the Figma splash background: base #FF6B35 with darker blur blobs).
  static const Color accentOrangeDark = Color(0xFFA83900);
  static const Color accentOrangeDarker = Color(0xFF812900);

  static const Color error = Color(0xFFBA1A1A);
}
