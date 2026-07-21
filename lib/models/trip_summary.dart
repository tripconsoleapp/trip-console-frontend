import 'trip_status.dart';

/// One row in the organizer's My Trips list.
class TripSummary {
  const TripSummary({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.status,
    required this.updatedLabel,
    this.progressPercent,
    this.receiptAvailable = false,
  });

  final String id;
  final String name;
  final String subtitle;
  final TripStatus status;
  final String updatedLabel;

  /// Only set for [TripStatus.draft] — how far the wizard got before saving.
  final double? progressPercent;

  final bool receiptAvailable;
}
