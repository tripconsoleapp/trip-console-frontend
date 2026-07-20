import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// The 5-dot progress row at the top of every trip-creation wizard screen
/// (Basics → Destinations → Services → Itinerary → Review).
class WizardStepIndicator extends StatelessWidget {
  const WizardStepIndicator({super.key, required this.currentStep, required this.labels});

  /// 1-indexed current step.
  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          final leftStep = (i ~/ 2) + 1;
          return Expanded(
            child: Container(
              height: 2,
              color: leftStep < currentStep ? AppColors.accentOrange : const Color(0xFFE2E2E2),
            ),
          );
        }
        final step = (i ~/ 2) + 1;
        final isDone = step < currentStep;
        final isActive = step == currentStep;
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone || isActive ? AppColors.accentOrange : const Color(0xFFE2E2E2),
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 14, color: AppColors.backgroundWhite)
                    : Text(
                        '$step',
                        style: AppTextStyles.labelCaps(
                          color: isActive ? AppColors.backgroundWhite : AppColors.textGrey,
                        ).copyWith(fontSize: 11),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[step - 1],
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelCaps(
                  color: isActive ? AppColors.accentOrange : AppColors.textGrey,
                ).copyWith(fontSize: 8),
              ),
            ],
          ),
        );
      }),
    );
  }
}
