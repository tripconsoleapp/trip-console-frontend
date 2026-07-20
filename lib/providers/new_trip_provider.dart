import 'package:flutter/foundation.dart';

import '../models/trip_type.dart';
import '../models/itinerary_stop.dart';

/// Holds the in-progress draft of a trip as the organizer moves through the
/// 5-step trip-creation wizard (Basics → Destinations → Services →
/// Participants → Review). Scoped to the wizard's navigation stack.
class NewTripProvider extends ChangeNotifier {
  String tripId = '';
  String tripName = '';
  TripType tripType = TripType.individual;
  bool travelingWithCompanion = false;
  String companionName = '';
  String emergencyContactName = '';
  String emergencyContactPhone = '';
  final List<ItineraryStop> stops = [
    const ItineraryStop(name: 'Munnar', region: 'Idukki District, Kerala, India', nights: 2, etaFromPrevious: '4h 30m from Kochi'),
    const ItineraryStop(name: 'Thekkady', region: 'Periyar, Kerala, India', nights: 1, etaFromPrevious: '3h 15m from Munnar'),
    const ItineraryStop(name: 'Kodaikanal', region: 'Dindigul, Tamil Nadu, India', nights: 1, etaFromPrevious: '4h 45m from Thekkady'),
  ];

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

  void setEmergencyContactName(String value) {
    emergencyContactName = value;
    notifyListeners();
  }

  void setEmergencyContactPhone(String value) {
    emergencyContactPhone = value;
    notifyListeners();
  }

  int get totalNights => stops.fold(0, (sum, stop) => sum + stop.nights);
}
