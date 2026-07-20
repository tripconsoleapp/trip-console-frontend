import 'package:flutter/material.dart';

import '../models/trip_recommendation.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Photo card for a suggested trip package, used in the Home dashboard's
/// horizontally-scrolling "Recommended for You" row.
class TripRecommendationCard extends StatelessWidget {
  const TripRecommendationCard({super.key, required this.recommendation, this.onTap});

  final TripRecommendation recommendation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 168,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    recommendation.imageAsset,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      recommendation.badgeLabel,
                      style: AppTextStyles.labelCaps(color: AppColors.backgroundWhite).copyWith(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recommendation.title,
              style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  recommendation.priceRange,
                  style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                ),
                Text(' ${recommendation.priceUnit}', style: AppTextStyles.bodySm()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
