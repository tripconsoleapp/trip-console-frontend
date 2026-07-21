import 'package:flutter/material.dart';

import '../models/activity_item.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// One row in the Home dashboard's Recent Activity feed.
class ActivityItemTile extends StatelessWidget {
  const ActivityItemTile({super.key, required this.item});

  final ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: item.iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(item.icon, size: 18, color: item.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.tripName, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(item.description, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(item.timeLabel, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}
