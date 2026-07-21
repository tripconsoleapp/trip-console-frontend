import 'room_type.dart';

/// A bookable hotel offering, scoped to one destination stop — shown on the
/// Select Hotel listing and expanded on Hotel Detail.
class HotelOption {
  const HotelOption({
    required this.name,
    required this.destination,
    required this.starRating,
    required this.pricePerNight,
    required this.maxGuestsPerRoom,
    required this.about,
    required this.amenities,
    required this.roomTypes,
    this.verified = false,
    this.badge,
    this.insufficientCapacity = false,
  });

  final String name;
  final String destination;
  final int starRating;
  final int pricePerNight;
  final int maxGuestsPerRoom;
  final String about;
  final List<String> amenities;
  final List<RoomType> roomTypes;
  final bool verified;
  final String? badge;

  /// True when this property can't reasonably house the group at all
  /// (shown as "Max N guests — insufficient" instead of a Select button).
  final bool insufficientCapacity;
}
