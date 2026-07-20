import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// A caps-label above a rounded, filled text field — the standard form
/// field pattern used throughout the trip-creation wizard.
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.trailing,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final Widget? trailing;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.labelCaps()),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyLg(color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyLg(color: AppColors.textGrey),
            filled: true,
            fillColor: const Color(0xFFF5F3F3),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
