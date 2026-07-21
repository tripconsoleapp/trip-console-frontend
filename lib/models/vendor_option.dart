/// A bookable vendor offering for a service (vehicle, hotel, restaurant, or
/// activity) — shown in a listing screen, and stored on [NewTripProvider]
/// once selected.
class VendorOption {
  const VendorOption({
    required this.name,
    required this.subtitle,
    required this.price,
    this.badge,
    this.rating,
    this.tripsCount,
    this.seatCapacity,
  });

  final String name;
  final String subtitle;
  final int price;
  final String? badge;
  final double? rating;
  final int? tripsCount;

  /// Vehicles only — used to flag a capacity mismatch against headcount.
  final int? seatCapacity;
}
