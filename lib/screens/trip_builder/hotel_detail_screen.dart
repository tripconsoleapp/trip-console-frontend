import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/hotel_option.dart';
import '../../models/room_type.dart';
import '../../models/vendor_option.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Full hotel detail — amenities, room-type picker, and optional meal
/// plan — with a live-computed total that writes back into
/// [NewTripProvider] as a single summary [VendorOption] on confirm.
class HotelDetailScreen extends StatefulWidget {
  const HotelDetailScreen({super.key, required this.hotel});

  final HotelOption hotel;

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  late RoomType _selectedRoom = widget.hotel.roomTypes.first;
  bool _breakfast = true;
  bool _lunch = false;
  bool _dinner = false;

  static const _breakfastPerHead = 150;
  static const _lunchPerHead = 250;
  static const _dinnerPerHead = 300;

  int _nightsAtDestination(NewTripProvider draft) {
    final match = draft.stops.where((s) => s.name == widget.hotel.destination);
    return match.isEmpty ? 1 : match.first.nights;
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final nights = _nightsAtDestination(draft);
    final roomsNeeded = (draft.totalParticipants / _selectedRoom.guestsPerRoom).ceil();
    final roomTotal = roomsNeeded * _selectedRoom.pricePerNight * nights;
    final mealTotal = (_breakfast ? _breakfastPerHead : 0) * draft.totalParticipants * nights +
        (_lunch ? _lunchPerHead : 0) * draft.totalParticipants * nights +
        (_dinner ? _dinnerPerHead : 0) * draft.totalParticipants * nights;
    final grandTotal = roomTotal + mealTotal;

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
                onPressed: () {
                  context.read<NewTripProvider>().setHotel(
                        VendorOption(
                          name: widget.hotel.name,
                          subtitle: '${_selectedRoom.name} · $nights night${nights == 1 ? '' : 's'} · ${widget.hotel.destination}',
                          price: grandTotal,
                        ),
                      );
                  context.go(AppRouter.tripServices);
                },
                child: Text('${HotelDetailStrings.addToTrip} — ₹$grandTotal', style: AppTextStyles.button()),
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
            expandedHeight: 180,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.backgroundWhite, size: 20),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              background: Icon(Icons.hotel_rounded, size: 56, color: AppColors.primaryGreen),
            ),
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
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: AppColors.accentOrange),
                      Text('${widget.hotel.starRating}-Star', style: AppTextStyles.bodySm()),
                      const SizedBox(width: 6),
                      Text('· ${widget.hotel.destination}', style: AppTextStyles.bodySm()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(HotelDetailStrings.about, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 6),
                  Text(widget.hotel.about, style: AppTextStyles.bodySm()),
                  const SizedBox(height: 20),
                  Text(HotelDetailStrings.amenities, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final amenity in widget.hotel.amenities)
                        Chip(
                          label: Text(amenity),
                          labelStyle: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontSize: 12),
                          backgroundColor: const Color(0xFFF5F3F3),
                          side: BorderSide.none,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${HotelDetailStrings.roomTypes} · ${draft.totalParticipants} ${HotelDetailStrings.guestsSuffix}',
                    style: AppTextStyles.h3(color: AppColors.textDark),
                  ),
                  const SizedBox(height: 10),
                  for (final room in widget.hotel.roomTypes)
                    _RoomTypeTile(
                      room: room,
                      selected: room == _selectedRoom,
                      roomsNeeded: (draft.totalParticipants / room.guestsPerRoom).ceil(),
                      onTap: () => setState(() => _selectedRoom = room),
                    ),
                  const SizedBox(height: 20),
                  Text(HotelDetailStrings.mealPlan, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  _MealCheckbox(label: HotelDetailStrings.breakfast, pricePerHead: _breakfastPerHead, value: _breakfast, onChanged: (v) => setState(() => _breakfast = v)),
                  _MealCheckbox(label: HotelDetailStrings.lunch, pricePerHead: _lunchPerHead, value: _lunch, onChanged: (v) => setState(() => _lunch = v)),
                  _MealCheckbox(label: HotelDetailStrings.dinner, pricePerHead: _dinnerPerHead, value: _dinner, onChanged: (v) => setState(() => _dinner = v)),
                ],
              ),
            ),
          ),
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
                  Text(room.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  Text('₹${room.pricePerNight}/room/night', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                  Text('$roomsNeeded room${roomsNeeded == 1 ? '' : 's'} needed', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontSize: 12)),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.accentOrange),
          ],
        ),
      ),
    );
  }
}

class _MealCheckbox extends StatelessWidget {
  const _MealCheckbox({required this.label, required this.pricePerHead, required this.value, required this.onChanged});

  final String label;
  final int pricePerHead;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Checkbox(value: value, activeColor: AppColors.accentOrange, onChanged: (v) => onChanged(v ?? false)),
            Expanded(child: Text(label, style: AppTextStyles.bodyLg(color: AppColors.textDark))),
            Text('₹$pricePerHead/head', style: AppTextStyles.bodySm()),
          ],
        ),
      ),
    );
  }
}
