import 'trip_summary.dart';

/// Carries one payment's context (which trip, how much, what kind) through
/// the Payment Method → Processing → Result → Receipt screens.
class PaymentArgs {
  const PaymentArgs({required this.trip, required this.amount, required this.isAdvance, required this.isBalance});

  final TripSummary trip;
  final int amount;

  /// True when this is the 20% advance option (vs. paying in full).
  final bool isAdvance;

  /// True when this is clearing a previously-outstanding balance rather
  /// than an initial payment.
  final bool isBalance;
}
