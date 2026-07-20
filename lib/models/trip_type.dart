/// The kind of group a trip is being organized for — drives eligible
/// templates and pricing throughout the trip-creation wizard.
enum TripType { school, college, group, individual }

extension TripTypeLabel on TripType {
  String get label => switch (this) {
        TripType.school => 'School Trip',
        TripType.college => 'College Trip',
        TripType.group => 'Group Trip',
        TripType.individual => 'Individual Trip',
      };
}
