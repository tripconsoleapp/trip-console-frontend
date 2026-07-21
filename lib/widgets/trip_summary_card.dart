import 'package:flutter/material.dart';

import '../models/trip_status.dart';
import '../models/trip_summary.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'trip_status_badge.dart';

/// One trip row on the My Trips - Organizer List screen. The trailing
/// action changes with [TripSummary.status] — Continue for drafts, Track
/// for submitted, Pay Now for verified, and a receipt link for completed.
class TripSummaryCard extends StatelessWidget {
  const TripSummaryCard({super.key, required this.trip, this.onTap, this.onAction});

  final TripSummary trip;
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  String get _actionLabel => switch (trip.status) {
        TripStatus.draft => 'Continue',
        TripStatus.submitted => 'Track Status',
        TripStatus.verified => 'Pay Now',
        TripStatus.paid => 'View Details',
        TripStatus.completed => 'View Receipt',
      };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
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
                  child: Text(
                    trip.name,
                    style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                TripStatusBadge(status: trip.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(trip.subtitle, style: AppTextStyles.bodySm()),
            if (trip.status == TripStatus.draft && trip.progressPercent != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: trip.progressPercent,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFF0F0F0),
                  valueColor: const AlwaysStoppedAnimation(AppColors.accentOrange),
                ),
              ),
              const SizedBox(height: 4),
              Text('${(trip.progressPercent! * 100).round()}% complete', style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(trip.updatedLabel, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                  child: Text(
                    _actionLabel,
                    style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
