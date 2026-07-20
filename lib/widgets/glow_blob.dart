import 'dart:ui';
import 'package:flutter/material.dart';

/// Soft blurred circle used as a decorative background accent.
/// Extracted from the splash screen because the "two glowing blobs behind
/// the brand cluster" pattern shows up again on other full-bleed hero screens.
class GlowBlob extends StatelessWidget {
  const GlowBlob({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.blurSigma,
  });

  final double width;
  final double height;
  final Color color;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
    );
  }
}
