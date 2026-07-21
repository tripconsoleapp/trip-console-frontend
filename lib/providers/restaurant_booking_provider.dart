import 'package:flutter/foundation.dart';

import '../models/menu_item.dart';
import '../models/restaurant_option.dart';
import '../models/trip_type.dart';
import '../utils/app_constants.dart';

/// Holds the in-progress draft for the standalone "Restaurant Only Booking"
/// (meal/catering) service — reached from Home's Service Only quick
/// actions, no full trip required. Reuses [TripType] for the same
/// guest-composition split the Hotel Only flow uses.
///
/// Menu selection is intentionally flat rather than day-by-day: one set of
/// dishes and one quantity-per-dish apply uniformly across every selected
/// meal date, the same "one choice, multiplied by duration" simplification
/// used by the Hotel Only flow's room selection.
class RestaurantBookingProvider extends ChangeNotifier {
  TripType bookingType = TripType.school;
  String location = 'Munnar, Kerala';
  final Set<DateTime> mealDates = {};

  bool breakfastNeeded = false;
  bool lunchNeeded = true;
  bool dinnerNeeded = true;
  final Map<String, int> mealHeadcounts = {};

  int primaryGuestCount = 0;
  int secondaryGuestCount = 0;
  String dietPreference = BookRestaurantStrings.both;
  String cateringStyle = BookRestaurantStrings.buffet;

  RestaurantOption? selectedRestaurant;
  final Set<MenuItem> selectedItems = {};
  final Map<MenuItem, int> quantities = {};

  void reset() {
    bookingType = TripType.school;
    location = 'Munnar, Kerala';
    mealDates.clear();
    breakfastNeeded = false;
    lunchNeeded = true;
    dinnerNeeded = true;
    mealHeadcounts.clear();
    primaryGuestCount = 0;
    secondaryGuestCount = 0;
    dietPreference = BookRestaurantStrings.both;
    cateringStyle = BookRestaurantStrings.buffet;
    selectedRestaurant = null;
    selectedItems.clear();
    quantities.clear();
    notifyListeners();
  }

  void setBookingType(TripType value) {
    bookingType = value;
    if (value == TripType.individual) {
      primaryGuestCount = 1;
      secondaryGuestCount = 0;
    }
    notifyListeners();
  }

  void setLocation(String value) {
    location = value;
    notifyListeners();
  }

  void setMealDates(Set<DateTime> dates) {
    mealDates
      ..clear()
      ..addAll(dates);
    notifyListeners();
  }

  void setMealTypeNeeded(String meal, bool value) {
    switch (meal) {
      case SelectMealTypesStrings.breakfast:
        breakfastNeeded = value;
      case SelectMealTypesStrings.lunch:
        lunchNeeded = value;
      case SelectMealTypesStrings.dinner:
        dinnerNeeded = value;
    }
    notifyListeners();
  }

  void setMealHeadcount(String meal, int value) {
    mealHeadcounts[meal] = value;
    notifyListeners();
  }

  void setPrimaryGuestCount(int value) {
    primaryGuestCount = value;
    notifyListeners();
  }

  void setSecondaryGuestCount(int value) {
    secondaryGuestCount = value;
    notifyListeners();
  }

  void setDietPreference(String value) {
    dietPreference = value;
    notifyListeners();
  }

  void setCateringStyle(String value) {
    cateringStyle = value;
    notifyListeners();
  }

  void selectRestaurant(RestaurantOption restaurant) {
    selectedRestaurant = restaurant;
    notifyListeners();
  }

  void setItemQuantity(MenuItem item, int quantity) {
    if (quantity <= 0) {
      selectedItems.remove(item);
      quantities.remove(item);
    } else {
      selectedItems.add(item);
      quantities[item] = quantity;
    }
    notifyListeners();
  }

  bool get isSolo => bookingType == TripType.individual;

  String get primaryGuestLabel => switch (bookingType) {
        TripType.individual => 'Guest',
        TripType.school => 'Students (Ages 5-18)',
        TripType.college => 'Students (18+)',
        TripType.group => 'Members',
      };

  String get secondaryGuestLabel => switch (bookingType) {
        TripType.individual => '',
        TripType.school => 'Staff (Chaperones/Teachers)',
        TripType.college => 'Faculty & Staff',
        TripType.group => 'Team Leaders',
      };

  int get totalGuests => isSolo ? 1 : primaryGuestCount + secondaryGuestCount;

  int get mealTypesCount => (breakfastNeeded ? 1 : 0) + (lunchNeeded ? 1 : 0) + (dinnerNeeded ? 1 : 0);

  int get mealDaysCount => mealDates.isEmpty ? 1 : mealDates.length;

  List<DateTime> get sortedMealDates => mealDates.toList()..sort();

  int headcountFor(String meal) => mealHeadcounts[meal] ?? totalGuests;

  int costForMealType(MealType type) => selectedItems
      .where((item) => item.mealType == type)
      .fold(0, (sum, item) => sum + item.price * (quantities[item] ?? 0)) *
      mealDaysCount;

  int get subtotalPerDay => selectedItems.fold(0, (sum, item) => sum + item.price * (quantities[item] ?? 0));

  int get subtotal => subtotalPerDay * mealDaysCount;

  int get serviceCharge => (subtotal * 0.05).round();

  int get grandTotal => subtotal + serviceCharge;
}
