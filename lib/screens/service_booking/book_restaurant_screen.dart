import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/trip_type.dart';
import '../../providers/restaurant_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/counter_field.dart';

/// Step 1 of 5 of the standalone "Restaurant Only Booking" flow — one screen
/// whose guest-composition fields adapt to
/// [RestaurantBookingProvider.bookingType], same pattern as the Hotel Only
/// flow's Stay Details screen. Meal dates/location are picked via dedicated
/// sub-screens; meal-type toggles, diet preference and catering style are
/// inline.
class BookRestaurantScreen extends StatefulWidget {
  const BookRestaurantScreen({super.key});

  @override
  State<BookRestaurantScreen> createState() => _BookRestaurantScreenState();
}

class _BookRestaurantScreenState extends State<BookRestaurantScreen> {
  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const _dietOptions = [BookRestaurantStrings.vegOnly, BookRestaurantStrings.nonVegAvailable, BookRestaurantStrings.both];
  static const _cateringOptions = [BookRestaurantStrings.buffet, BookRestaurantStrings.packedLunch, BookRestaurantStrings.preOrderedFixedMenu];

  String _formatDates(List<DateTime> dates) {
    if (dates.isEmpty) return BookRestaurantStrings.selectDates;
    final sorted = dates.toList()..sort();
    if (sorted.length == 1) return '${sorted.first.day} ${_months[sorted.first.month - 1]}';
    return '${sorted.first.day} ${_months[sorted.first.month - 1]} – ${sorted.last.day} ${_months[sorted.last.month - 1]}';
  }

  Future<void> _pickLocation(BuildContext context) async {
    final result = await context.push<String>(AppRouter.selectMealLocation);
    if (result != null && context.mounted) context.read<RestaurantBookingProvider>().setLocation(result);
  }

  Future<void> _pickDates(BuildContext context) async {
    final result = await context.push<Set<DateTime>>(AppRouter.selectMealDates);
    if (result != null && context.mounted) context.read<RestaurantBookingProvider>().setMealDates(result);
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<RestaurantBookingProvider>();
    final estTotal = booking.mealDaysCount > 0 && booking.totalGuests > 0 ? booking.totalGuests * booking.mealDaysCount * booking.mealTypesCount * 130 : 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(BookRestaurantStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () => context.push(AppRouter.restaurantSearchResults),
                child: Text('${BookRestaurantStrings.searchRestaurants} →', style: AppTextStyles.button()),
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
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.restaurant_rounded, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(child: Text(BookRestaurantStrings.restaurantOnlyBanner, style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(BookRestaurantStrings.tripType, style: AppTextStyles.labelCaps()),
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
            Text(BookRestaurantStrings.mealLocation, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
            const SizedBox(height: 6),
            _TapField(
              icon: Icons.location_on_outlined,
              value: booking.location.isEmpty ? BookRestaurantStrings.mealLocationHint : booking.location,
              placeholder: booking.location.isEmpty,
              onTap: () => _pickLocation(context),
            ),
            const SizedBox(height: 12),
            Text(BookRestaurantStrings.mealDates, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
            const SizedBox(height: 6),
            _TapField(
              icon: Icons.date_range_outlined,
              value: booking.mealDates.isEmpty
                  ? BookRestaurantStrings.selectDates
                  : '${_formatDates(booking.sortedMealDates)} · ${booking.mealDates.length}${BookRestaurantStrings.daysSelectedSuffix}',
              placeholder: booking.mealDates.isEmpty,
              onTap: () => _pickDates(context),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(BookRestaurantStrings.mealsRequired, style: AppTextStyles.labelCaps()),
                TextButton(
                  onPressed: () => context.push(AppRouter.selectMealTypes),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text(BookRestaurantStrings.editHeadcounts, style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _MealToggleRow(label: BookRestaurantStrings.breakfast, value: booking.breakfastNeeded, onChanged: (v) => booking.setMealTypeNeeded(SelectMealTypesStrings.breakfast, v)),
            _MealToggleRow(label: BookRestaurantStrings.lunch, value: booking.lunchNeeded, onChanged: (v) => booking.setMealTypeNeeded(SelectMealTypesStrings.lunch, v)),
            _MealToggleRow(label: BookRestaurantStrings.dinner, value: booking.dinnerNeeded, onChanged: (v) => booking.setMealTypeNeeded(SelectMealTypesStrings.dinner, v)),
            const SizedBox(height: 20),
            if (booking.isSolo) ...[
              Text(BookRestaurantStrings.groupRequirements, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded, size: 18, color: AppColors.textDark),
                    const SizedBox(width: 8),
                    Text('1 Guest', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ] else ...[
              Text(BookRestaurantStrings.groupRequirements, style: AppTextStyles.labelCaps()),
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
            ],
            const SizedBox(height: 20),
            Text(BookRestaurantStrings.dietPreference, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final option in _dietOptions) _Chip(label: option, selected: booking.dietPreference == option, onTap: () => booking.setDietPreference(option))],
            ),
            const SizedBox(height: 20),
            Text(BookRestaurantStrings.cateringStyle, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final option in _cateringOptions) _Chip(label: option, selected: booking.cateringStyle == option, onTap: () => booking.setCateringStyle(option))],
            ),
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
                        Text(BookRestaurantStrings.estimatedTotal, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                        Text('₹$estTotal', style: AppTextStyles.h3(color: AppColors.textDark)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(BookRestaurantStrings.perPerson, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
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

class _MealToggleRow extends StatelessWidget {
  const _MealToggleRow({required this.label, required this.value, required this.onChanged});

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
