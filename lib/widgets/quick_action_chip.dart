import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Small icon+label pill used for the "service only" quick actions row
/// on the Home dashboard (Hotel / Vehicle / Restaurant).
class QuickActionChip extends StatelessWidget {
  const QuickActionChip({super.key, required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2BFB3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.accentOrange),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.bodySm(color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}
