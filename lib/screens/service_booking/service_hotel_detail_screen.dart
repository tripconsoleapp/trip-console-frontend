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
import '../../widgets/select_meal_plan_sheet.dart';

/// Full hotel detail for the Hotel Only Booking flow — stats, amenities,
/// room-type picker, a meal-plan selector, and reviews, with a sticky
/// bottom CTA that carries the running total into Booking Summary.
class ServiceHotelDetailScreen extends StatefulWidget {
  const ServiceHotelDetailScreen({super.key, required this.hotel});

  final HotelOption hotel;

  @override
  State<ServiceHotelDetailScreen> createState() => _ServiceHotelDetailScreenState();
}

class _ServiceHotelDetailScreenState extends State<ServiceHotelDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final booking = context.read<HotelBookingProvider>();
      booking.selectHotel(widget.hotel);
      if (booking.selectedRoomType == null) booking.selectRoomType(widget.hotel.roomTypes.first);
    });
  }

  int _roomsNeededFor(RoomType room, int totalGuests) => (totalGuests / room.guestsPerRoom).ceil().clamp(1, 999);

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<HotelBookingProvider>();
    final nights = booking.nights == 0 ? 1 : booking.nights;
    final selectedRoom = booking.selectedRoomType;
    final roomsNeeded = booking.roomsNeeded;
    final total = booking.subtotal;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: selectedRoom == null ? null : () => context.push(AppRouter.hotelBookingSummary),
                child: Text(
                  '$roomsNeeded ${ServiceHotelDetailStrings.roomsNightsPrefix}$nights${ServiceHotelDetailStrings.nightsSuffix} · ₹$total  ${ServiceHotelDetailStrings.proceed} →',
                  style: AppTextStyles.button(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.mintGreen.withValues(alpha: 0.3),
            pinned: true,
            expandedHeight: 200,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                child: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: AppColors.backgroundWhite, size: 20), onPressed: () => Navigator.of(context).maybePop()),
              ),
            ),
            flexibleSpace: const FlexibleSpaceBar(background: Icon(Icons.hotel_rounded, size: 56, color: AppColors.primaryGreen)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(widget.hotel.name, style: AppTextStyles.h2(color: AppColors.textDark))),
                      if (widget.hotel.verified) const Icon(Icons.verified_rounded, size: 20, color: AppColors.primaryGreen),
                    ],
                  ),
                  if (widget.hotel.badge != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text('${widget.hotel.badge} SINCE ${widget.hotel.sinceYear}', style: AppTextStyles.labelCaps(color: AppColors.accentOrange).copyWith(fontSize: 9)),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _StatBlock(label: ServiceHotelDetailStrings.capacity, value: '${widget.hotel.roomCount} Rooms'),
                      _StatBlock(label: ServiceHotelDetailStrings.rating, value: '${widget.hotel.starRating}★'),
                      _StatBlock(label: ServiceHotelDetailStrings.since, value: 'Est. ${widget.hotel.sinceYear}'),
                      _StatBlock(label: ServiceHotelDetailStrings.town, value: '${widget.hotel.townDistanceKm} km'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(ServiceHotelDetailStrings.about, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 6),
                  Text(widget.hotel.about, style: AppTextStyles.bodySm()),
                  const SizedBox(height: 20),
                  Text(ServiceHotelDetailStrings.amenities, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (final amenity in widget.hotel.amenities) Chip(label: Text(amenity), labelStyle: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontSize: 12), backgroundColor: const Color(0xFFF5F3F3), side: BorderSide.none)],
                  ),
                  const SizedBox(height: 20),
                  Text(ServiceHotelDetailStrings.roomTypes, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  for (final room in widget.hotel.roomTypes)
                    _RoomTypeTile(
                      room: room,
                      selected: selectedRoom == room,
                      roomsNeeded: _roomsNeededFor(room, booking.totalGuests),
                      onTap: () => booking.selectRoomType(room),
                    ),
                  const SizedBox(height: 20),
                  Text(ServiceHotelDetailStrings.mealPlan, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => SelectMealPlanSheet.show(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          const Icon(Icons.restaurant_menu_rounded, size: 18, color: AppColors.textGrey),
                          const SizedBox(width: 10),
                          Expanded(child: Text(booking.selectedMealPlan ?? SelectMealPlanStrings.roomOnly, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600))),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ServiceHotelDetailStrings.reviews, style: AppTextStyles.h3(color: AppColors.textDark)),
                      TextButton(onPressed: () {}, child: Text(ServiceHotelDetailStrings.seeAll, style: AppTextStyles.bodySm(color: AppColors.accentOrange))),
                    ],
                  ),
                  const _ReviewTile(name: 'Anish S.', rating: '5.0', body: "Perfect for our university trip. The staff handled everything effortlessly and the views are just..."),
                  const _ReviewTile(name: 'RK', rating: '4.8', body: 'Great highland coordination and hospitality.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 8)),
          Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _RoomTypeTile extends StatelessWidget {
  const _RoomTypeTile({required this.room, required this.selected, required this.roomsNeeded, required this.onTap});

  final RoomType room;
  final bool selected;
  final int roomsNeeded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange.withValues(alpha: 0.08) : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${room.name} · ${room.guestsPerRoom} Pax', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  Text('₹${room.pricePerNight}/night', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                ],
              ),
            ),
            Text(
              selected ? ServiceHotelDetailStrings.selected : ServiceHotelDetailStrings.select,
              style: AppTextStyles.bodySm(color: selected ? AppColors.primaryGreen : AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.name, required this.rating, required this.body});

  final String name;
  final String rating;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: AppColors.mintGreen.withValues(alpha: 0.4), child: Text(name[0], style: const TextStyle(color: AppColors.primaryGreen, fontSize: 12))),
              const SizedBox(width: 8),
              Text(name, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: 6),
              const Icon(Icons.star_rounded, size: 14, color: AppColors.accentOrange),
              Text(rating, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text(body, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
