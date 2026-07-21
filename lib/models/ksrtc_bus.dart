enum KsrtcBusCategory { districtToDistrict, interstate }

/// A bookable KSRTC (Kerala State Road Transport Corporation) fleet class —
/// shown on the KSRTC Buses listing, distinct from the generic private
/// [VendorOption] marketplace since KSRTC pricing is a flat institutional
/// bus-hire rate rather than a per-head vendor quote.
class KsrtcBus {
  const KsrtcBus({
    required this.name,
    required this.category,
    required this.busType,
    required this.estimatedFare,
    this.badge,
  });

  final String name;
  final KsrtcBusCategory category;
  final String busType;
  final int estimatedFare;
  final String? badge;
}
