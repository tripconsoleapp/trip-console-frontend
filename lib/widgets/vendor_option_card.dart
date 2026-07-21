import 'package:flutter/material.dart';

import '../models/vendor_option.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';

/// One vendor row in a listing screen (vehicle operator, hotel, restaurant,
/// or activity) — rating/trip count, subtitle, price, and a Select action.
class VendorOptionCard extends StatelessWidget {
  const VendorOptionCard({super.key, required this.option, required this.onSelect});

  final VendorOption option;
  final VoidCallback onSelect;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(option.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
              ),
              if (option.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(option.badge!, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
                ),
            ],
          ),
          if (option.rating != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 14, color: AppColors.accentOrange),
                const SizedBox(width: 2),
                Text('${option.rating}', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                if (option.tripsCount != null) ...[
                  const SizedBox(width: 4),
                  Text('(${option.tripsCount} ${VendorListingStrings.tripsSuffix})', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                ],
              ],
            ),
          ],
          const SizedBox(height: 4),
          Text(option.subtitle, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('₹${option.price}', style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(width: 2),
                  Text(VendorListingStrings.perTrip, style: AppTextStyles.bodySm()),
                ],
              ),
              SizedBox(
                height: 36,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.accentOrange),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: onSelect,
                  child: Text(VendorListingStrings.select, style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
