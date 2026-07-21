/// A bookable local tour guide, offered as an optional add-on once a trip's
/// core services are booked.
class TourGuide {
  const TourGuide({
    required this.name,
    required this.rating,
    required this.tripsCount,
    required this.languages,
    required this.yearsExperience,
    required this.specialty,
    required this.pricePerDay,
    required this.about,
    required this.specialties,
    this.topRated = false,
  });

  final String name;
  final double rating;
  final int tripsCount;
  final List<String> languages;
  final int yearsExperience;
  final String specialty;
  final int pricePerDay;
  final String about;
  final List<String> specialties;
  final bool topRated;
}
