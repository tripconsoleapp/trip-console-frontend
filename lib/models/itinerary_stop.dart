/// One destination stop within a trip's route, as shown on the
/// Destinations & Route step of trip creation.
class ItineraryStop {
  const ItineraryStop({
    required this.name,
    required this.region,
    required this.nights,
    required this.etaFromPrevious,
  });

  final String name;
  final String region;
  final int nights;
  final String etaFromPrevious;
}
