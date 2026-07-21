import 'package:flutter/material.dart';

import '../models/trip_status.dart';
import '../utils/app_text_styles.dart';

/// Small pill showing a trip's lifecycle stage — used on My Trips cards.
class TripStatusBadge extends StatelessWidget {
  const TripStatusBadge({super.key, required this.status});

  final TripStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: AppTextStyles.labelCaps(color: status.color).copyWith(fontSize: 10),
      ),
    );
  }
}
