import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// A caps-label over a bold value, used in the route/cost summary grids
/// throughout trip creation (total stops, nights, distance, drive time).
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h3(color: AppColors.textDark)),
      ],
    );
  }
}
