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
    this.totalCost = 0,
    this.amountPaid = 0,
  });

  final String id;
  final String name;
  final String subtitle;
  final TripStatus status;
  final String updatedLabel;

  /// Only set for [TripStatus.draft] — how far the wizard got before saving.
  final double? progressPercent;

  final bool receiptAvailable;

  /// Set from [TripStatus.verified] onward — what payment screens work from.
  final int totalCost;

  /// 0 before payment, a partial amount after an advance, equal to
  /// [totalCost] once fully paid.
  final int amountPaid;

  int get balanceDue => totalCost - amountPaid;

  /// A case-reference-looking string derived from [id] — e.g. "TC-2025-0047".
  String get caseReference => 'TC-2025-${id.padLeft(4, '0')}';

  TripSummary copyWith({TripStatus? status, String? updatedLabel, int? amountPaid}) {
    return TripSummary(
      id: id,
      name: name,
      subtitle: subtitle,
      status: status ?? this.status,
      updatedLabel: updatedLabel ?? this.updatedLabel,
      progressPercent: progressPercent,
      receiptAvailable: receiptAvailable,
      totalCost: totalCost,
      amountPaid: amountPaid ?? this.amountPaid,
    );
  }
}
