import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Label + sublabel next to a -/value/+ stepper. Used for Members,
/// Companions, Students, and Staff counts on Trip Basics.
class CounterField extends StatelessWidget {
  const CounterField({
    super.key,
    required this.label,
    required this.sublabel,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
  });

  final String label;
  final String sublabel;
  final int value;
  final int minValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
            Text(sublabel, style: AppTextStyles.bodySm()),
          ],
        ),
        Row(
          children: [
            _StepButton(icon: Icons.remove, onTap: value > minValue ? () => onChanged(value - 1) : null),
            SizedBox(
              width: 32,
              child: Text('$value', textAlign: TextAlign.center, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
            ),
            _StepButton(icon: Icons.add, onTap: () => onChanged(value + 1)),
          ],
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: enabled ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
        ),
        child: Icon(icon, size: 16, color: enabled ? AppColors.accentOrange : AppColors.textGrey),
      ),
    );
  }
}
