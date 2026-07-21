import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/hotel_option.dart';
import '../../models/room_type.dart';
import '../../providers/hotel_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Filtered listing of hotels matching the Stay Details criteria — tapping
/// "View Rooms" opens the full [ServiceHotelDetailScreen].
class HotelSearchResultsScreen extends StatefulWidget {
  const HotelSearchResultsScreen({super.key});

  static const _hotels = [
    HotelOption(
      name: 'Kerala Heritage Resort',
      destination: 'Munnar',
      starRating: 5,
      pricePerNight: 2800,
      maxGuestsPerRoom: 3,
      verified: true,
      badge: 'SCHOOL PARTNER',
      about: 'A premium sanctuary designed for large-group expeditions, with dedicated panoramic tea-estate views and 24/7 institutional-grade support.',
      amenities: ['Free WiFi', 'Swimming Pool', 'All Meals', 'AC Rooms', 'Parking', 'Security', 'Treks', 'Bonfire'],
      roomCount: 60,
      sinceYear: 2019,
      townDistanceKm: 6,
      roomTypes: [
        RoomType(name: 'Triple Sharing', pricePerNight: 2800, guestsPerRoom: 3),
        RoomType(name: 'Dormitory', pricePerNight: 1200, guestsPerRoom: 10),
        RoomType(name: 'Double Room', pricePerNight: 3500, guestsPerRoom: 2),
      ],
    ),
    HotelOption(
      name: 'Mountain View Cottages',
      destination: 'Munnar',
      starRating: 4,
      pricePerNight: 1800,
      maxGuestsPerRoom: 3,
      about: 'Budget-friendly cottages with campus WiFi and dedicated bus parking, popular with school and college groups.',
      amenities: ['Free WiFi', 'Bus Parking', 'Breakfast'],
      roomCount: 24,
      sinceYear: 2015,
      townDistanceKm: 3,
      roomTypes: [
        RoomType(name: 'Triple Sharing', pricePerNight: 1800, guestsPerRoom: 3),
        RoomType(name: 'Dormitory', pricePerNight: 950, guestsPerRoom: 8),
      ],
    ),
    HotelOption(
      name: 'Spice Garden Heritage',
      destination: 'Munnar',
      starRating: 5,
      pricePerNight: 4200,
      maxGuestsPerRoom: 2,
      badge: 'HERITAGE',
      about: 'A restored plantation bungalow with spice-garden tours and heritage dining, best suited to smaller premium groups.',
      amenities: ['Free WiFi', 'All Meals', 'Spice Garden Tour', 'AC Rooms'],
      roomCount: 18,
      sinceYear: 2008,
      townDistanceKm: 9,
      roomTypes: [
        RoomType(name: 'Double Room', pricePerNight: 4200, guestsPerRoom: 2),
      ],
    ),
    HotelOption(
      name: 'Green Valley Resort',
      destination: 'Munnar',
      starRating: 3,
      pricePerNight: 1400,
      maxGuestsPerRoom: 3,
      badge: 'BUDGET',
      about: 'A no-frills valley-facing resort with simple, clean rooms and a focus on keeping large-group costs low.',
      amenities: ['Free WiFi', 'Breakfast', 'Parking'],
      roomCount: 30,
      sinceYear: 2012,
      townDistanceKm: 4,
      roomTypes: [
        RoomType(name: 'Triple Sharing', pricePerNight: 1400, guestsPerRoom: 3),
        RoomType(name: 'Dormitory', pricePerNight: 800, guestsPerRoom: 10),
      ],
    ),
  ];

  @override
  State<HotelSearchResultsScreen> createState() => _HotelSearchResultsScreenState();
}

class _HotelSearchResultsScreenState extends State<HotelSearchResultsScreen> {
  String _filter = HotelResultsStrings.filterAll;

  static const _filters = [
    HotelResultsStrings.filterAll,
    HotelResultsStrings.filterBudget,
    HotelResultsStrings.filterHeritage,
    HotelResultsStrings.filterWithMeal,
  ];

  List<HotelOption> get _filtered {
    switch (_filter) {
      case HotelResultsStrings.filterBudget:
        return HotelSearchResultsScreen._hotels.where((h) => h.badge == 'BUDGET' || h.pricePerNight < 2000).toList();
      case HotelResultsStrings.filterHeritage:
        return HotelSearchResultsScreen._hotels.where((h) => h.badge == 'HERITAGE').toList();
      case HotelResultsStrings.filterWithMeal:
        return HotelSearchResultsScreen._hotels.where((h) => h.amenities.contains('All Meals')).toList();
      default:
        return HotelSearchResultsScreen._hotels;
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<HotelBookingProvider>();
    final hotels = _filtered;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(HotelResultsStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  for (final filter in _filters) ...[
                    _FilterChip(label: filter, selected: _filter == filter, onTap: () => setState(() => _filter = filter)),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${hotels.length} ${HotelResultsStrings.hotelsFoundSuffix} · ${booking.destination.toUpperCase()} · ${booking.nights > 0 ? '${booking.nights}N' : ''} · ${booking.totalGuests} ${HotelResultsStrings.paxSuffix}',
                style: AppTextStyles.labelCaps().copyWith(fontSize: 10),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: hotels.length,
                itemBuilder: (context, index) => _HotelCard(
                  hotel: hotels[index],
                  nights: booking.nights == 0 ? 1 : booking.nights,
                  onTap: () => context.push(AppRouter.serviceHotelDetail, extra: hotels[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(color: selected ? AppColors.accentOrange : const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(18)),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  const _HotelCard({required this.hotel, required this.nights, required this.onTap});

  final HotelOption hotel;
  final int nights;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(height: 120, width: double.infinity, color: AppColors.mintGreen.withValues(alpha: 0.3), child: const Icon(Icons.hotel_rounded, size: 36, color: AppColors.primaryGreen)),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(hotel.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700))),
                    const Icon(Icons.star_rounded, size: 14, color: AppColors.accentOrange),
                    Text('${hotel.starRating}', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(hotel.about, style: AppTextStyles.bodySm().copyWith(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('₹${hotel.pricePerNight}', style: AppTextStyles.h3(color: AppColors.textDark)),
                    Text(HotelResultsStrings.perNight, style: AppTextStyles.bodySm()),
                    const Spacer(),
                    Text('${HotelResultsStrings.total} ₹${hotel.pricePerNight * nights}', style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accentOrange)),
                    onPressed: onTap,
                    child: Text('${HotelResultsStrings.viewRooms} →', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
