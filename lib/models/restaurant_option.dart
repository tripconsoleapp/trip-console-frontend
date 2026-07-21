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
  });

  final String name;
  final double rating;
  final int tripsCount;
  final int capacity;
  final int mealsPerDay;
  final int avgCostPerHead;
  final List<MenuItem> menu;

  bool get hasVeg => menu.any((item) => item.isVeg);
  bool get hasNonVeg => menu.any((item) => !item.isVeg);
}
