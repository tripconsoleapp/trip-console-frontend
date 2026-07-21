/// A ready-made pilgrimage itinerary — pre-fills route, stay, and meals so
/// the organizer only needs to customise instead of building from scratch.
class PilgrimageTemplate {
  const PilgrimageTemplate({
    required this.name,
    required this.destination,
    required this.subtitle,
    required this.duration,
    required this.pilgrimRange,
    required this.priceFromPerHead,
    this.verified = false,
    this.comingSoon = false,
    this.route,
    this.stayNote,
    this.mealsNote,
  });

  final String name;
  final String destination;
  final String subtitle;
  final String duration;
  final String pilgrimRange;
  final int priceFromPerHead;
  final bool verified;
  final bool comingSoon;
  final String? route;
  final String? stayNote;
  final String? mealsNote;
}
