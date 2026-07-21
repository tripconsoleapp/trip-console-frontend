import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// Lifecycle stage of a trip in the organizer's My Trips list, from first
/// draft through to a completed, paid trip.
enum TripStatus { draft, submitted, verified, paid, completed }

extension TripStatusInfo on TripStatus {
  String get label => switch (this) {
        TripStatus.draft => 'Draft',
        TripStatus.submitted => 'Submitted',
        TripStatus.verified => 'Verified',
        TripStatus.paid => 'Paid',
        TripStatus.completed => 'Completed',
      };

  Color get color => switch (this) {
        TripStatus.draft => AppColors.textGrey,
        TripStatus.submitted => const Color(0xFF0095FF),
        TripStatus.verified => AppColors.primaryGreen,
        TripStatus.paid => AppColors.accentOrange,
        TripStatus.completed => AppColors.primaryGreen,
      };
}
