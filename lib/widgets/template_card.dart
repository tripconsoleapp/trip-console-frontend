import 'package:flutter/material.dart';

import '../models/trip_package.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Grid card for the Templates browse screen — photo, badge, title and
/// price. Same visual language as [TripRecommendationCard] but sized to
/// fill a grid cell rather than a fixed horizontal-scroll width.
class TemplateCard extends StatelessWidget {
  const TemplateCard({super.key, required this.package, this.onTap});

  final TripPackage package;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(package.imageAsset, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(6)),
                    child: Text(package.badgeLabel, style: AppTextStyles.labelCaps(color: AppColors.backgroundWhite).copyWith(fontSize: 9)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            package.title,
            style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(package.priceRange, style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600, fontSize: 12)),
              Text(' ${package.priceUnit}', style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
