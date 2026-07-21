import 'itinerary_day.dart';
import 'pricing_line.dart';

/// A browsable reference package or template — used both for the Templates
/// grid (summary fields only) and the full Package/Template Detail screen.
class TripPackage {
  const TripPackage({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.badgeLabel,
    required this.priceRange,
    required this.priceUnit,
    required this.category,
    required this.rating,
    required this.about,
    required this.route,
    required this.includedServices,
    required this.itinerary,
    required this.whatsIncluded,
    required this.pricingBreakdown,
    required this.totalPrice,
  });

  final String id;
  final String title;
  final String imageAsset;
  final String badgeLabel;
  final String priceRange;
  final String priceUnit;
  final String category;
  final double rating;
  final String about;
  final List<String> route;
  final List<String> includedServices;
  final List<ItineraryDay> itinerary;
  final List<String> whatsIncluded;
  final List<PricingLine> pricingBreakdown;
  final String totalPrice;
}
