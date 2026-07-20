import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Fixed footer used on every trip-creation wizard screen: step counter on
/// the left, Back/Next actions on the right.
class WizardBottomBar extends StatelessWidget {
  const WizardBottomBar({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.stepTitle,
    required this.nextLabel,
    required this.onNext,
    this.onBack,
  });

  final int stepNumber;
  final int totalSteps;
  final String stepTitle;
  final String nextLabel;
  final VoidCallback onNext;
  final VoidCallback? onBack;

  static const double _barHeight = 84;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundWhite,
      elevation: 8,
      child: SizedBox(
        height: _barHeight,
        width: double.infinity,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('STEP $stepNumber OF $totalSteps', style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
                      Text(
                        stepTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (onBack != null) ...[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E2E2)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onPressed: onBack,
                    child: Text('Back', style: AppTextStyles.button(color: AppColors.textDark)),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                  onPressed: onNext,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(nextLabel),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
