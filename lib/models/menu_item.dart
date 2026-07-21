enum MealType { breakfast, lunch, dinner, packed }

extension MealTypeLabel on MealType {
  String get label => switch (this) {
        MealType.breakfast => 'BREAKFAST',
        MealType.lunch => 'LUNCH',
        MealType.dinner => 'DINNER',
        MealType.packed => 'PACKED MEALS',
      };
}

/// One dish on a restaurant's menu, prices per head.
class MenuItem {
  const MenuItem({required this.name, required this.price, required this.mealType, required this.isVeg, this.popular = false});

  final String name;
  final int price;
  final MealType mealType;
  final bool isVeg;
  final bool popular;
}
