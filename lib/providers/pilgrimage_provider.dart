import 'package:flutter/foundation.dart';

import '../models/pilgrimage_template.dart';

/// Drives the standalone "Pilgrimage Console" shell — trip mode, setup
/// choice, template selection, trip structure, and group size — before
/// handing off either to the KSRTC booking pipeline or the generic
/// private-vendor vehicle flow, both of which already exist.
class PilgrimageProvider extends ChangeNotifier {
  static const String selfManaged = 'Self-Managed Trip';
  static const String ksrtcCollaboration = 'KSRTC Collaboration';
  static const String startFromScratch = 'Start from Scratch';
  static const String useTemplate = 'Use a Template';
  static const String customise = 'Customise';
  static const String fixedPackage = 'Fixed Package';
  static const String largeGroup = 'Large Group';
  static const String smallGroup = 'Small Group';

  String tripMode = selfManaged;
  String setupChoice = '';
  PilgrimageTemplate? selectedTemplate;
  String structureType = customise;
  String groupSizeCategory = largeGroup;
  String destination = 'Sabarimala';

  void reset() {
    tripMode = selfManaged;
    setupChoice = '';
    selectedTemplate = null;
    structureType = customise;
    groupSizeCategory = largeGroup;
    destination = 'Sabarimala';
    notifyListeners();
  }

  void setTripMode(String value) {
    tripMode = value;
    notifyListeners();
  }

  void setSetupChoice(String value) {
    setupChoice = value;
    notifyListeners();
  }

  void selectTemplate(PilgrimageTemplate template) {
    selectedTemplate = template;
    destination = template.destination;
    notifyListeners();
  }

  void setStructureType(String value) {
    structureType = value;
    notifyListeners();
  }

  void setGroupSizeCategory(String value) {
    groupSizeCategory = value;
    notifyListeners();
  }

  bool get isKsrtcCollaboration => tripMode == ksrtcCollaboration;

  /// Group size is chosen as a category (Large/Small), not entered
  /// manually — matches the Figma source, where Seat Count & Capacity's
  /// PASSENGER COUNT downstream is shown auto-filled and locked, not
  /// editable. Illustrative defaults, not authoritative headcounts.
  int get totalPilgrims => groupSizeCategory == largeGroup ? 46 : 18;
}
