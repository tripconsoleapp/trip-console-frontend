import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Icon + explanatory text in a tinted box — used for pricing/policy notes
/// that appear throughout the trip-creation wizard.
class InfoNote extends StatelessWidget {
  const InfoNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentOrange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accentOrange),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodySm(color: AppColors.textGrey))),
        ],
      ),
    );
  }
}
