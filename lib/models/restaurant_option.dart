import 'menu_item.dart';

/// A bookable restaurant/caterer, shown on Choose a Restaurant and expanded
/// into a day-by-day menu builder.
class RestaurantOption {
  const RestaurantOption({
    required this.name,
    required this.rating,
    required this.tripsCount,
    required this.capacity,
    required this.mealsPerDay,
    required this.avgCostPerHead,
    required this.menu,
    this.verified = false,
    this.badge,
    this.sinceYear,
    this.dietaryVegPercent,
    this.about,
  });

  final String name;
  final double rating;
  final int tripsCount;
  final int capacity;
  final int mealsPerDay;
  final int avgCostPerHead;
  final List<MenuItem> menu;
  final bool verified;
  final String? badge;

  // Used by the standalone Service-Only Restaurant booking flow's richer
  // search-results and detail views.
  final int? sinceYear;
  final int? dietaryVegPercent;
  final String? about;

  bool get hasVeg => menu.any((item) => item.isVeg);
  bool get hasNonVeg => menu.any((item) => !item.isVeg);
}
