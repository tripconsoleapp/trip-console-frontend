import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

enum _Strength { weak, medium, strong }

/// Segmented strength bar shown under a password field while signing up.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.password});

  final String password;

  _Strength _evaluate() {
    if (password.isEmpty) return _Strength.weak;
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    if (score >= 3) return _Strength.strong;
    if (score >= 2) return _Strength.medium;
    return _Strength.weak;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    final strength = _evaluate();
    final filledSegments = switch (strength) {
      _Strength.weak => 1,
      _Strength.medium => 2,
      _Strength.strong => 3,
    };
    final color = switch (strength) {
      _Strength.weak => AppColors.error,
      _Strength.medium => AppColors.accentOrange,
      _Strength.strong => AppColors.primaryGreen,
    };
    final label = switch (strength) {
      _Strength.weak => 'WEAK',
      _Strength.medium => 'MEDIUM',
      _Strength.strong => 'STRONG',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (i) {
            final filled = i < filledSegments;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i == 2 ? 0 : 4),
                height: 3,
                decoration: BoxDecoration(
                  color: filled ? color : const Color(0xFFE3E2E2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text('STRENGTH $label', style: AppTextStyles.labelCaps(color: color).copyWith(fontSize: 10)),
      ],
    );
  }
}
