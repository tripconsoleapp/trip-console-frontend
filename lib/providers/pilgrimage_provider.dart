import 'package:flutter/foundation.dart';

import '../models/pilgrimage_template.dart';

/// Drives the standalone "Pilgrimage Console" shell — trip mode, setup
/// choice, template selection, group structure, and headcount — before
/// handing off either to the KSRTC booking pipeline or the generic
/// private-vendor vehicle flow, both of which already exist.
class PilgrimageProvider extends ChangeNotifier {
  static const String selfManaged = 'Self-Managed Trip';
  static const String ksrtcCollaboration = 'KSRTC Collaboration';
  static const String startFromScratch = 'Start from Scratch';
  static const String useTemplate = 'Use a Template';
  static const String largeGroup = 'Large Group';
  static const String smallGroup = 'Small Group';

  String tripMode = selfManaged;
  String setupChoice = '';
  PilgrimageTemplate? selectedTemplate;
  String structureChoice = largeGroup;
  int pilgrimCount = 0;
  int staffCount = 0;
  String destination = 'Sabarimala';

  void reset() {
    tripMode = selfManaged;
    setupChoice = '';
    selectedTemplate = null;
    structureChoice = largeGroup;
    pilgrimCount = 0;
    staffCount = 0;
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

  void setStructureChoice(String value) {
    structureChoice = value;
    notifyListeners();
  }

  void setPilgrimCount(int value) {
    pilgrimCount = value;
    notifyListeners();
  }

  void setStaffCount(int value) {
    staffCount = value;
    notifyListeners();
  }

  bool get isKsrtcCollaboration => tripMode == ksrtcCollaboration;

  int get totalPilgrims => pilgrimCount + staffCount;
}
