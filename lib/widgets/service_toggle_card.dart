import 'package:flutter/material.dart';

import '../models/vendor_option.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';

/// One row on the Services step — a togglable service (Vehicle, Hotel,
/// Restaurant, Activities). Collapsed to just the toggle when off; once on,
/// shows either a "Choose X" prompt or the selected vendor's summary with a
/// "Change" link. [selections] supports Activities' multi-select case.
class ServiceToggleCard extends StatelessWidget {
  const ServiceToggleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onToggle,
    required this.chooseLabel,
    required this.onChoose,
    this.selections = const [],
    this.addAnotherLabel,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final String chooseLabel;
  final VoidCallback onChoose;
  final List<VendorOption> selections;
  final String? addAnotherLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 20, color: AppColors.accentOrange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                    Text(subtitle, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                  ],
                ),
              ),
              Switch(value: enabled, activeThumbColor: AppColors.accentOrange, onChanged: onToggle),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 12),
            if (selections.isEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E2E2))),
                  onPressed: onChoose,
                  child: Text('$chooseLabel →', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600)),
                ),
              )
            else ...[
              for (final selection in selections)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(selection.name, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                            Text(selection.subtitle, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                            Text('₹${selection.price}', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: onChoose,
                        child: Text(ServicesStrings.change, style: AppTextStyles.bodySm(color: AppColors.accentOrange)),
                      ),
                    ],
                  ),
                ),
              if (addAnotherLabel != null)
                TextButton(
                  onPressed: onChoose,
                  child: Text(addAnotherLabel!, style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600)),
                ),
            ],
          ],
        ],
      ),
    );
  }
}
