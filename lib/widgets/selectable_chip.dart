import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// A pill-shaped, single-select choice chip (e.g. trip type). Used anywhere
/// the design shows a set of mutually-exclusive rounded options.
class SelectableChip extends StatelessWidget {
  const SelectableChip({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange.withValues(alpha: 0.08) : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyLg(color: selected ? AppColors.accentOrange : AppColors.textDark)
              .copyWith(fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
        ),
      ),
    );
  }
}
