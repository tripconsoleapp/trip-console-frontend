import 'package:flutter/foundation.dart';

import '../models/trip_type.dart';
import '../models/itinerary_stop.dart';
import '../models/itinerary_block.dart';
import '../models/vendor_option.dart';

/// Holds the in-progress draft of a trip as the organizer moves through the
/// 5-step trip-creation wizard (Basics → Destinations → Participants →
/// Services → Review). Scoped to the wizard's navigation stack.
class NewTripProvider extends ChangeNotifier {
  String tripId = '';
  String tripName = '';
  TripType tripType = TripType.individual;

  // Individual trip fields
  bool travelingWithCompanion = false;
  String companionName = '';

  // Group trip fields
  String groupName = '';
  int membersCount = 0;
  int companionsCount = 0;

  // College/School trip fields
  String institutionName = '';
  int studentsCount = 0;
  int staffCount = 0;

  String emergencyContactName = '';
  String emergencyContactPhone = '';
  String startingLocationName = 'Kochi';
  String startingLocationRegion = 'Ernakulam District, Kerala, India';
  String? sourceTemplateName;
  final List<ItineraryStop> stops = [
    const ItineraryStop(name: 'Munnar', region: 'Idukki District, Kerala, India', nights: 2, etaFromPrevious: '4h 30m from Kochi'),
    const ItineraryStop(name: 'Thekkady', region: 'Periyar, Kerala, India', nights: 1, etaFromPrevious: '3h 15m from Munnar'),
    const ItineraryStop(name: 'Kodaikanal', region: 'Dindigul, Tamil Nadu, India', nights: 1, etaFromPrevious: '4h 45m from Thekkady'),
  ];

  // Services (Step 4) fields
  bool vehicleEnabled = false;
  VendorOption? vehicle;
  bool hotelEnabled = false;
  VendorOption? hotel;
  bool restaurantEnabled = false;
  VendorOption? restaurant;
  bool activitiesEnabled = false;
  final List<VendorOption> activities = [];

  // Itinerary (generated after Services, one block list per day)
  List<List<ItineraryBlock>> dailyItinerary = [];

  void setTripName(String value) {
    tripName = value;
    notifyListeners();
  }

  void setTripType(TripType value) {
    tripType = value;
    notifyListeners();
  }

  void setTravelingWithCompanion(bool value) {
    travelingWithCompanion = value;
    notifyListeners();
  }

  void setCompanionName(String value) {
    companionName = value;
    notifyListeners();
  }

  void setGroupName(String value) {
    groupName = value;
    notifyListeners();
  }

  void setMembersCount(int value) {
    membersCount = value;
    notifyListeners();
  }

  void setCompanionsCount(int value) {
    companionsCount = value;
    notifyListeners();
  }

  void setInstitutionName(String value) {
    institutionName = value;
    notifyListeners();
  }

  void setStudentsCount(int value) {
    studentsCount = value;
    notifyListeners();
  }

  void setStaffCount(int value) {
    staffCount = value;
    notifyListeners();
  }

  void setEmergencyContactName(String value) {
    emergencyContactName = value;
    notifyListeners();
  }

  void setEmergencyContactPhone(String value) {
    emergencyContactPhone = value;
    notifyListeners();
  }

  void setStartingLocation(String name, String region) {
    startingLocationName = name;
    startingLocationRegion = region;
    notifyListeners();
  }

  void addStop(ItineraryStop stop) {
    stops.add(stop);
    notifyListeners();
  }

  void removeStop(int index) {
    stops.removeAt(index);
    notifyListeners();
  }

  void setSourceTemplate(String name) {
    sourceTemplateName = name;
    notifyListeners();
  }

  void setVehicleEnabled(bool value) {
    vehicleEnabled = value;
    notifyListeners();
  }

  void setVehicle(VendorOption option) {
    vehicle = option;
    vehicleEnabled = true;
    notifyListeners();
  }

  void setHotelEnabled(bool value) {
    hotelEnabled = value;
    notifyListeners();
  }

  void setHotel(VendorOption option) {
    hotel = option;
    hotelEnabled = true;
    notifyListeners();
  }

  void setRestaurantEnabled(bool value) {
    restaurantEnabled = value;
    notifyListeners();
  }

  void setRestaurant(VendorOption option) {
    restaurant = option;
    restaurantEnabled = true;
    notifyListeners();
  }

  void setActivitiesEnabled(bool value) {
    activitiesEnabled = value;
    notifyListeners();
  }

  void addActivity(VendorOption option) {
    activities.add(option);
    activitiesEnabled = true;
    notifyListeners();
  }

  int get totalNights => stops.fold(0, (sum, stop) => sum + stop.nights);

  /// Everyone traveling, including non-cost-bearing staff/companions.
  int get totalParticipants => switch (tripType) {
        TripType.individual => 1 + (travelingWithCompanion ? 1 : 0),
        TripType.group => membersCount + companionsCount,
        TripType.college || TripType.school => studentsCount + staffCount,
      };

  /// Only the participants pricing is calculated against.
  int get costBearingCount => switch (tripType) {
        TripType.individual => 1 + (travelingWithCompanion ? 1 : 0),
        TripType.group => membersCount,
        TripType.college || TripType.school => studentsCount,
      };

  /// Synthesizes a day-by-day timeline from whatever's already been chosen
  /// on Destinations/Services — a travel leg, one rotating activity, a meal
  /// block, and a rest/check-in block per day. Idempotent so re-entering
  /// the Itinerary screen doesn't wipe manual edits.
  void generateItinerary() {
    if (dailyItinerary.isNotEmpty) return;
    final dayCount = stops.isEmpty ? 1 : stops.length;
    final result = <List<ItineraryBlock>>[];
    for (var i = 0; i < dayCount; i++) {
      final stop = stops.isEmpty ? null : stops[i];
      final fromName = i == 0 ? startingLocationName : stops[i - 1].name;
      final blocks = <ItineraryBlock>[];
      blocks.add(ItineraryBlock(
        type: BlockType.travel,
        time: '06:00 AM',
        title: stop == null ? 'Depart from $fromName' : '$fromName → ${stop.name}',
        subtitle: stop?.etaFromPrevious ?? 'Local travel',
      ));
      if (activitiesEnabled && activities.isNotEmpty) {
        final activity = activities[i % activities.length];
        blocks.add(ItineraryBlock(
          type: BlockType.activity,
          time: '10:30 AM',
          title: activity.name,
          subtitle: activity.subtitle,
          cost: activity.price,
        ));
      }
      if (restaurantEnabled && restaurant != null) {
        blocks.add(ItineraryBlock(
          type: BlockType.meal,
          time: '01:00 PM',
          title: 'Meals — ${restaurant!.name}',
          subtitle: 'Included in dining plan',
          cost: (restaurant!.price / dayCount).round(),
        ));
      }
      if (hotelEnabled && hotel != null) {
        final isLastDay = i == dayCount - 1;
        blocks.add(ItineraryBlock(
          type: BlockType.rest,
          time: '07:00 PM',
          title: isLastDay ? 'Checkout — ${hotel!.name}' : 'Overnight — ${hotel!.name}',
          subtitle: hotel!.subtitle,
          cost: isLastDay ? null : (hotel!.price / dayCount).round(),
        ));
      }
      result.add(blocks);
    }
    dailyItinerary = result;
    notifyListeners();
  }

  void updateBlock(int day, int index, ItineraryBlock block) {
    dailyItinerary[day][index] = block;
    notifyListeners();
  }

  void addBlock(int day, ItineraryBlock block) {
    dailyItinerary[day].add(block);
    notifyListeners();
  }

  void removeBlock(int day, int index) {
    dailyItinerary[day].removeAt(index);
    notifyListeners();
  }

  int dailyExpense(int day) => dailyItinerary[day].fold(0, (sum, b) => sum + (b.cost ?? 0));

  int get vehicleTotal => vehicleEnabled ? (vehicle?.price ?? 0) : 0;
  int get hotelTotal => hotelEnabled ? (hotel?.price ?? 0) : 0;
  int get diningTotal => restaurantEnabled ? (restaurant?.price ?? 0) : 0;
  int get activitiesTotal => activitiesEnabled ? activities.fold(0, (sum, a) => sum + a.price) : 0;
  int get servicesSubtotal => vehicleTotal + hotelTotal + diningTotal + activitiesTotal;
  int get managementBuffer => (servicesSubtotal * 0.05).round();
  int get servicesGrandTotal => servicesSubtotal + managementBuffer;
  int get perParticipantCost => costBearingCount == 0 ? 0 : (servicesGrandTotal / costBearingCount).round();
}
