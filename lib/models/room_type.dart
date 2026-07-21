/// One bookable room category within a [HotelOption] — e.g. Deluxe Double,
/// Standard Triple, Dormitory bed.
class RoomType {
  const RoomType({required this.name, required this.pricePerNight, required this.guestsPerRoom});

  final String name;
  final int pricePerNight;
  final int guestsPerRoom;
}
