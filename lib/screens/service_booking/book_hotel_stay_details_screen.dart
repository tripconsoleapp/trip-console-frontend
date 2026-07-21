import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/trip_type.dart';
import '../../providers/hotel_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/counter_field.dart';

/// Step 1 of 5 of the standalone "Hotel Only Booking" flow — one screen
/// whose guest-composition fields adapt to [HotelBookingProvider.bookingType]
/// (Solo / School / College / Corporate), same pattern the trip wizard's
/// Basics step uses for [TripType]. Location and dates are picked via
/// dedicated sub-screens; everything else is inline.
class BookHotelStayDetailsScreen extends StatefulWidget {
  const BookHotelStayDetailsScreen({super.key});

  @override
  State<BookHotelStayDetailsScreen> createState() => _BookHotelStayDetailsScreenState();
}

class _BookHotelStayDetailsScreenState extends State<BookHotelStayDetailsScreen> {
  late final TextEditingController _purposeController;

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const _roomOptions = ['Any', 'Triple Sharing', 'Dormitory', 'Double Room'];
  static const _ratingOptions = ['Any', '3★', '4★', '5★', 'Budget'];

  @override
  void initState() {
    super.initState();
    final booking = context.read<HotelBookingProvider>();
    _purposeController = TextEditingController(text: booking.purposeOfStay)
      ..addListener(() => booking.setPurposeOfStay(_purposeController.text));
  }

  @override
  void dispose() {
    _purposeController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) => '${date.day} ${_months[date.month - 1]}';

  Future<void> _pickLocation(BuildContext context) async {
    final result = await context.push<String>(AppRouter.selectStayLocation);
    if (result != null && context.mounted) context.read<HotelBookingProvider>().setDestination(result);
  }

  Future<void> _pickDates(BuildContext context) async {
    final result = await context.push<(DateTime, DateTime)>(AppRouter.selectStayDates);
    if (result != null && context.mounted) context.read<HotelBookingProvider>().setDates(result.$1, result.$2);
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<HotelBookingProvider>();
    final estTotal = booking.nights > 0 && booking.totalGuests > 0 ? booking.totalGuests * booking.nights * 500 : 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(BookHotelStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
        actions: [
          TextButton(onPressed: () {}, child: Text(BookHotelStrings.saveDraft, style: AppTextStyles.bodySm(color: AppColors.accentOrange))),
        ],
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.push(AppRouter.hotelSearchResults),
                child: Text('${BookHotelStrings.searchHotels} →', style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF0095FF).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.hotel_rounded, size: 16, color: Color(0xFF0095FF)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(BookHotelStrings.hotelOnlyBanner, style: AppTextStyles.bodySm(color: const Color(0xFF0095FF)).copyWith(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(BookHotelStrings.tripType, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in TripType.values)
                  _Chip(
                    label: type == TripType.individual ? 'Solo' : type.label.replaceAll(' Trip', ''),
                    selected: booking.bookingType == type,
                    onTap: () => booking.setBookingType(type),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (!booking.isSolo) ...[
              Text(BookHotelStrings.purposeOfStay, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              TextField(
                controller: _purposeController,
                style: AppTextStyles.bodyLg(color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: BookHotelStrings.purposeOfStayHint,
                  hintStyle: AppTextStyles.bodyLg(color: AppColors.textGrey),
                  filled: true,
                  fillColor: const Color(0xFFF5F3F3),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(BookHotelStrings.destinationAndDates, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            Text(BookHotelStrings.stayLocation, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
            const SizedBox(height: 6),
            _TapField(
              icon: Icons.location_on_outlined,
              value: booking.destination.isEmpty ? BookHotelStrings.stayLocationHint : booking.destination,
              placeholder: booking.destination.isEmpty,
              onTap: () => _pickLocation(context),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(BookHotelStrings.checkIn, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
                      const SizedBox(height: 6),
                      _TapField(
                        value: booking.checkIn == null ? BookHotelStrings.selectDates : _formatDate(booking.checkIn!),
                        placeholder: booking.checkIn == null,
                        onTap: () => _pickDates(context),
                      ),
                    ],
                  ),
                ),
                if (booking.nights > 0) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.accentOrange, borderRadius: BorderRadius.circular(6)),
                      child: Text('${booking.nights} ${BookHotelStrings.nightsSuffix}', style: AppTextStyles.labelCaps(color: AppColors.backgroundWhite).copyWith(fontSize: 9)),
                    ),
                  ),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(BookHotelStrings.checkOut, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
                      const SizedBox(height: 6),
                      _TapField(
                        value: booking.checkOut == null ? BookHotelStrings.selectDates : _formatDate(booking.checkOut!),
                        placeholder: booking.checkOut == null,
                        onTap: () => _pickDates(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (booking.isSolo) ...[
              Text(BookHotelStrings.guests, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded, size: 18, color: AppColors.textDark),
                    const SizedBox(width: 8),
                    Text('1 Guest', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(BookHotelStrings.soloTraveler, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Text(BookHotelStrings.groupRequirements, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              CounterField(
                label: booking.primaryGuestLabel,
                sublabel: '',
                value: booking.primaryGuestCount,
                onChanged: booking.setPrimaryGuestCount,
              ),
              const SizedBox(height: 12),
              CounterField(
                label: booking.secondaryGuestLabel,
                sublabel: '',
                value: booking.secondaryGuestCount,
                onChanged: booking.setSecondaryGuestCount,
              ),
              const SizedBox(height: 12),
              CounterField(
                label: BookHotelStrings.roomsRequired,
                sublabel: '${BookHotelStrings.autoCalculatedPrefix}${booking.totalGuests} guests, suggested ${booking.roomsNeeded} rooms',
                value: booking.roomsNeeded,
                onChanged: (_) {},
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(BookHotelStrings.roomPreferences, style: AppTextStyles.labelCaps()),
                TextButton(
                  onPressed: () => context.push(AppRouter.roomTypePreference),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text('View details', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final option in _roomOptions) _Chip(label: option, selected: booking.roomPreference == option, onTap: () => booking.setRoomPreference(option))],
            ),
            const SizedBox(height: 20),
            Text(BookHotelStrings.hotelRating, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final option in _ratingOptions) _Chip(label: option, selected: booking.starRating == option, onTap: () => booking.setStarRating(option))],
            ),
            const SizedBox(height: 20),
            Text(BookHotelStrings.specialRequirements, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            _ToggleRow(label: BookHotelStrings.vegetarianMeals, value: booking.vegetarianMeals, onChanged: booking.toggleVegetarianMeals),
            _ToggleRow(label: BookHotelStrings.acRooms, value: booking.acRooms, onChanged: booking.toggleAcRooms),
            if (!booking.isSolo) _ToggleRow(label: BookHotelStrings.conferenceHall, value: booking.conferenceHall, onChanged: booking.toggleConferenceHall),
            _ToggleRow(label: BookHotelStrings.accessibleRooms, value: booking.accessibleRooms, onChanged: booking.toggleAccessibleRooms),
            if (estTotal > 0) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(BookHotelStrings.estimatedTotal, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                        Text('₹$estTotal', style: AppTextStyles.h3(color: AppColors.textDark)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(BookHotelStrings.perPerson, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                        Text('₹${(estTotal / booking.totalGuests).round()}', style: AppTextStyles.bodyLg(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(color: selected ? AppColors.accentOrange : const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(18)),
        child: Text(label, style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _TapField extends StatelessWidget {
  const _TapField({required this.value, required this.onTap, this.icon, this.placeholder = false});

  final String value;
  final VoidCallback onTap;
  final IconData? icon;
  final bool placeholder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            if (icon != null) ...[Icon(icon, size: 18, color: AppColors.textGrey), const SizedBox(width: 8)],
            Expanded(child: Text(value, style: AppTextStyles.bodyLg(color: placeholder ? AppColors.textGrey : AppColors.textDark))),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodyLg(color: AppColors.textDark))),
          Switch(value: value, activeThumbColor: AppColors.accentOrange, onChanged: onChanged),
        ],
      ),
    );
  }
}
