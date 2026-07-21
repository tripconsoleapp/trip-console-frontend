import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_booking_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../utils/app_router.dart';

/// Final confirmation step of the Restaurant Only Booking flow. Unlike
/// Hotel's checkbox-gated sheet, this one is a single note + Confirm button
/// (no payment collected here — matches the Figma "no payment required at
/// this step" copy), then hands off to the Sending Meal Request screen.
class ConfirmMealBookingSheet extends StatelessWidget {
  const ConfirmMealBookingSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const ConfirmMealBookingSheet(),
    );
  }

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<RestaurantBookingProvider>();
    final dates = booking.sortedMealDates;
    final dateRange = dates.isEmpty ? '—' : '${dates.first.day} ${_months[dates.first.month - 1]} – ${dates.last.day} ${_months[dates.last.month - 1]}';
    final mealTypesText = [
      if (booking.breakfastNeeded) BookRestaurantStrings.breakfast,
      if (booking.lunchNeeded) BookRestaurantStrings.lunch,
      if (booking.dinnerNeeded) BookRestaurantStrings.dinner,
    ].join(' + ');

    return Container(
      decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ConfirmMealBookingStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded)),
            ],
          ),
          const SizedBox(height: 4),
          Text(booking.selectedRestaurant?.name ?? '', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _Row(label: 'DATES', value: '$dateRange (${booking.mealDaysCount} Days)'),
                _Row(label: 'GROUP', value: '${booking.totalGuests} Participants · ${mealTypesText.isEmpty ? '—' : mealTypesText}'),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(MealBookingSentStrings.totalAmount, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
                    Text('₹${booking.grandTotal}', style: AppTextStyles.h2(color: AppColors.accentOrange)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textGrey),
              const SizedBox(width: 8),
              Expanded(child: Text(ConfirmMealBookingStrings.noPaymentNote, style: AppTextStyles.bodySm().copyWith(fontSize: 12))),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRouter.sendingMealRequest);
              },
              child: Text('${ConfirmMealBookingStrings.confirm} →', style: AppTextStyles.button()),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
          Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
