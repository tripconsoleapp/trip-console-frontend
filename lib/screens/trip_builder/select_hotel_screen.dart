import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/hotel_option.dart';
import '../../models/room_type.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Hotel listing, scoped to whichever destination is selected — filters by
/// destination and star rating, and flags properties too small for the
/// group. Tapping a card opens [HotelDetailScreen] for room-type + meal
/// selection.
class SelectHotelScreen extends StatefulWidget {
  const SelectHotelScreen({super.key});

  static const _hotels = [
    HotelOption(
      name: 'Kerala Heritage Resort',
      destination: 'Munnar',
      starRating: 4,
      pricePerNight: 4500,
      maxGuestsPerRoom: 2,
      verified: true,
      badge: 'SCHOOL PREFERRED',
      about: 'A premium sanctuary designed for large-group expeditions and corporate retreats. Colonial-era architecture merged with modern comfort, overlooking the valley.',
      amenities: ['Free WiFi', 'All Meals', 'AC Rooms', 'Parking', 'Conference', 'First Aid', 'Swimming Pool', 'Campfire Area', 'Training Ground'],
      roomTypes: [
        RoomType(name: 'Deluxe Double Room', pricePerNight: 4500, guestsPerRoom: 2),
        RoomType(name: 'Standard Triple Room', pricePerNight: 6000, guestsPerRoom: 3),
        RoomType(name: 'Dormitory', pricePerNight: 1200, guestsPerRoom: 1),
      ],
    ),
    HotelOption(
      name: 'Misty Mountain Lodge',
      destination: 'Munnar',
      starRating: 3,
      pricePerNight: 3200,
      maxGuestsPerRoom: 2,
      about: 'A cosy mid-range lodge with valley views, popular with school and college groups looking for comfortable, no-frills stays.',
      amenities: ['Free WiFi', 'Breakfast', 'Parking', 'First Aid'],
      roomTypes: [
        RoomType(name: 'Standard Double Room', pricePerNight: 3200, guestsPerRoom: 2),
        RoomType(name: 'Standard Triple Room', pricePerNight: 4200, guestsPerRoom: 3),
      ],
    ),
    HotelOption(
      name: 'Green Valley Homestay',
      destination: 'Munnar',
      starRating: 3,
      pricePerNight: 2400,
      maxGuestsPerRoom: 20,
      insufficientCapacity: true,
      about: 'A family-run homestay with a handful of rooms — best suited to small groups.',
      amenities: ['Breakfast', 'Parking'],
      roomTypes: [RoomType(name: 'Family Room', pricePerNight: 2400, guestsPerRoom: 4)],
    ),
    HotelOption(
      name: 'Periyar Lake View Resort',
      destination: 'Thekkady',
      starRating: 4,
      pricePerNight: 3800,
      maxGuestsPerRoom: 2,
      verified: true,
      about: 'Lakeside resort steps from the Periyar boat jetty, with group-friendly dining and activity spaces.',
      amenities: ['Free WiFi', 'All Meals', 'AC Rooms', 'Parking', 'First Aid'],
      roomTypes: [
        RoomType(name: 'Lake View Double Room', pricePerNight: 3800, guestsPerRoom: 2),
        RoomType(name: 'Standard Triple Room', pricePerNight: 5000, guestsPerRoom: 3),
      ],
    ),
  ];

  @override
  State<SelectHotelScreen> createState() => _SelectHotelScreenState();
}

class _SelectHotelScreenState extends State<SelectHotelScreen> {
  String? _destinationFilter;
  int _minRating = 0;

  static const _ratingFilters = [5, 4, 3];

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final filtered = SelectHotelScreen._hotels.where((h) {
      final matchesDestination = _destinationFilter == null || h.destination == _destinationFilter;
      final matchesRating = h.starRating >= _minRating;
      return matchesDestination && matchesRating;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(SelectHotelStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatChip(icon: Icons.groups_rounded, label: '${draft.totalParticipants} people'),
                  StatChip(icon: Icons.nights_stay_rounded, label: '${draft.totalNights} nights total'),
                  StatChip(icon: Icons.place_rounded, label: '${draft.stops.length} destinations'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: AppTextStyles.bodyLg(color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: SelectHotelStrings.searchHint,
                  hintStyle: AppTextStyles.bodyLg(color: AppColors.textGrey),
                  filled: true,
                  fillColor: const Color(0xFFF5F3F3),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textGrey),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _Chip(label: SelectHotelStrings.allDestinations, selected: _destinationFilter == null, onTap: () => setState(() => _destinationFilter = null)),
                  for (final stop in draft.stops) ...[
                    const SizedBox(width: 8),
                    _Chip(
                      label: '${stop.name} (${stop.nights}N)',
                      selected: _destinationFilter == stop.name,
                      onTap: () => setState(() => _destinationFilter = stop.name),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _Chip(label: SelectHotelStrings.allRatings, selected: _minRating == 0, onTap: () => setState(() => _minRating = 0)),
                  for (final rating in _ratingFilters) ...[
                    const SizedBox(width: 8),
                    _Chip(label: '$rating★', selected: _minRating == rating, onTap: () => setState(() => _minRating = rating)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: filtered.length,
                itemBuilder: (context, index) => _HotelCard(
                  hotel: filtered[index],
                  fits: draft.totalParticipants,
                  onTap: filtered[index].insufficientCapacity
                      ? null
                      : () => context.push(AppRouter.hotelDetail, extra: filtered[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatChip extends StatelessWidget {
  const StatChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textGrey),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange : const Color(0xFFF5F3F3),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  const _HotelCard({required this.hotel, required this.fits, required this.onTap});

  final HotelOption hotel;
  final int fits;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(hotel.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600))),
              if (hotel.verified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: const Icon(Icons.verified_rounded, size: 14, color: AppColors.primaryGreen),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.star_rounded, size: 14, color: AppColors.accentOrange),
              Text('${hotel.starRating}-Star', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
              const SizedBox(width: 8),
              Text(hotel.destination, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
              if (hotel.badge != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(hotel.badge!, style: AppTextStyles.labelCaps(color: AppColors.accentOrange).copyWith(fontSize: 9)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('₹${hotel.pricePerNight}', style: AppTextStyles.h3(color: AppColors.textDark)),
              Text(SelectHotelStrings.perNight, style: AppTextStyles.bodySm()),
            ],
          ),
          const SizedBox(height: 8),
          if (hotel.insufficientCapacity)
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.error),
                const SizedBox(width: 6),
                Text(
                  '${SelectHotelStrings.insufficientCapacityPrefix} ${hotel.maxGuestsPerRoom} ${SelectHotelStrings.insufficientCapacitySuffix}',
                  style: AppTextStyles.bodySm(color: AppColors.error).copyWith(fontSize: 12),
                ),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primaryGreen),
                const SizedBox(width: 6),
                Text(SelectHotelStrings.fitsYourGroup, style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontSize: 12)),
              ],
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              child: Text(SelectHotelStrings.selectThisHotel, style: AppTextStyles.button()),
            ),
          ),
        ],
      ),
    );
  }
}
