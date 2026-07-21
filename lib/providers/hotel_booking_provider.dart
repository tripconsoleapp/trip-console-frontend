import 'package:flutter/foundation.dart';

import '../models/hotel_option.dart';
import '../models/room_type.dart';
import '../models/trip_type.dart';

/// Holds the in-progress draft for the standalone "Hotel Only Booking" flow
/// — reached from Home's Service Only quick actions, no full trip required.
/// Reuses [TripType] to drive which guest-composition fields Stay Details
/// shows (individual → solo traveler, school/college → students+staff,
/// group → corporate members+team leaders), the same pattern the trip
/// wizard's Basics step already uses.
class HotelBookingProvider extends ChangeNotifier {
  TripType bookingType = TripType.school;
  String purposeOfStay = '';
  String destination = 'Munnar, Kerala';
  DateTime? checkIn;
  DateTime? checkOut;
  int primaryGuestCount = 0;
  int secondaryGuestCount = 0;
  String roomPreference = 'Any';
  String starRating = 'Any';

  bool vegetarianMeals = true;
  bool breakfastIncluded = true;
  bool acRooms = false;
  bool conferenceHall = false;
  bool accessibleRooms = false;
  bool earlyCheckIn = false;

  HotelOption? selectedHotel;
  RoomType? selectedRoomType;
  String? selectedMealPlan;
  int? selectedMealPlanPricePerDay;

  void reset() {
    bookingType = TripType.school;
    purposeOfStay = '';
    destination = 'Munnar, Kerala';
    checkIn = null;
    checkOut = null;
    primaryGuestCount = 0;
    secondaryGuestCount = 0;
    roomPreference = 'Any';
    starRating = 'Any';
    vegetarianMeals = true;
    breakfastIncluded = true;
    acRooms = false;
    conferenceHall = false;
    accessibleRooms = false;
    earlyCheckIn = false;
    selectedHotel = null;
    selectedRoomType = null;
    selectedMealPlan = null;
    selectedMealPlanPricePerDay = null;
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

  void setPurposeOfStay(String value) {
    purposeOfStay = value;
    notifyListeners();
  }

  void setDestination(String value) {
    destination = value;
    notifyListeners();
  }

  void setDates(DateTime checkInDate, DateTime checkOutDate) {
    checkIn = checkInDate;
    checkOut = checkOutDate;
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

  void setRoomPreference(String value) {
    roomPreference = value;
    notifyListeners();
  }

  void setStarRating(String value) {
    starRating = value;
    notifyListeners();
  }

  void toggleVegetarianMeals(bool value) {
    vegetarianMeals = value;
    notifyListeners();
  }

  void toggleBreakfastIncluded(bool value) {
    breakfastIncluded = value;
    notifyListeners();
  }

  void toggleAcRooms(bool value) {
    acRooms = value;
    notifyListeners();
  }

  void toggleConferenceHall(bool value) {
    conferenceHall = value;
    notifyListeners();
  }

  void toggleAccessibleRooms(bool value) {
    accessibleRooms = value;
    notifyListeners();
  }

  void toggleEarlyCheckIn(bool value) {
    earlyCheckIn = value;
    notifyListeners();
  }

  void selectHotel(HotelOption hotel) {
    selectedHotel = hotel;
    notifyListeners();
  }

  void selectRoomType(RoomType room) {
    selectedRoomType = room;
    notifyListeners();
  }

  void selectMealPlan(String plan, int pricePerDay) {
    selectedMealPlan = plan;
    selectedMealPlanPricePerDay = pricePerDay;
    notifyListeners();
  }

  int get nights => checkIn != null && checkOut != null ? checkOut!.difference(checkIn!).inDays : 0;

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

  int get roomCapacity => switch (roomPreference) {
        'Dormitory' => 10,
        'Double Room' => 2,
        'Twin Sharing' => 2,
        _ => 3,
      };

  int get roomsNeeded {
    if (isSolo) return 1;
    final capacity = selectedRoomType?.guestsPerRoom ?? roomCapacity;
    return (totalGuests / capacity).ceil().clamp(1, 999);
  }

  int get roomCost => selectedRoomType == null ? 0 : selectedRoomType!.pricePerNight * roomsNeeded * (nights == 0 ? 1 : nights);

  int get mealCost => selectedMealPlanPricePerDay == null ? 0 : selectedMealPlanPricePerDay! * totalGuests * (nights == 0 ? 1 : nights);

  int get subtotal => roomCost + mealCost;

  int get taxes => (subtotal * 0.18).round();

  int get grandTotal => subtotal + taxes;
}
