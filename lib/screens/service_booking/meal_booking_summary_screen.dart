import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/menu_item.dart';
import '../../providers/restaurant_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../widgets/confirm_meal_booking_sheet.dart';

/// Step 4 of 5 — final recap of meal details and cost before confirmation.
class MealBookingSummaryScreen extends StatelessWidget {
  const MealBookingSummaryScreen({super.key});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static String _formatDate(DateTime date) => '${date.day} ${_months[date.month - 1]}';

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<RestaurantBookingProvider>();
    final dates = booking.sortedMealDates;
    final scheduleText = dates.isEmpty ? '—' : (dates.length == 1 ? _formatDate(dates.first) : '${_formatDate(dates.first)} – ${_formatDate(dates.last)} (${dates.length} days)');
    final mealTypesText = [
      if (booking.breakfastNeeded) BookRestaurantStrings.breakfast,
      if (booking.lunchNeeded) BookRestaurantStrings.lunch,
      if (booking.dinnerNeeded) BookRestaurantStrings.dinner,
    ].join(' + ');

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(MealBookingSummaryStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () => ConfirmMealBookingSheet.show(context),
                child: Text(MealBookingSummaryStrings.confirmAndProceed, style: AppTextStyles.button()),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
              child: Text(MealBookingSummaryStrings.stepPrefix, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 10)),
            ),
            const SizedBox(height: 20),
            Text(MealBookingSummaryStrings.mealDetails, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _SummaryRow(label: MealBookingSummaryStrings.location, value: booking.selectedRestaurant?.name ?? booking.location),
                  _SummaryRow(label: MealBookingSummaryStrings.schedule, value: scheduleText),
                  _SummaryRow(label: MealBookingSummaryStrings.mealType, value: mealTypesText.isEmpty ? '—' : mealTypesText),
                  _SummaryRow(label: MealBookingSummaryStrings.dietaryPreferences, value: booking.dietPreference, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.groups_rounded, size: 20, color: AppColors.primaryGreen),
                  const SizedBox(width: 10),
                  Text('${booking.totalGuests}', style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MealBookingSummaryStrings.totalGuests, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                      Text(MealBookingSummaryStrings.participants, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(MealBookingSummaryStrings.costBreakdown, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  if (booking.lunchNeeded) _SummaryRow(label: '${BookRestaurantStrings.lunch} (${booking.totalGuests} Guests × ${booking.mealDaysCount} Days)', value: '₹${booking.costForMealType(MealType.lunch)}'),
                  if (booking.dinnerNeeded) _SummaryRow(label: '${BookRestaurantStrings.dinner} (${booking.totalGuests} Guests × ${booking.mealDaysCount} Days)', value: '₹${booking.costForMealType(MealType.dinner)}'),
                  if (booking.breakfastNeeded) _SummaryRow(label: '${BookRestaurantStrings.breakfast} (${booking.totalGuests} Guests × ${booking.mealDaysCount} Days)', value: '₹${booking.costForMealType(MealType.breakfast)}'),
                  _SummaryRow(label: MealBookingSummaryStrings.serviceCharge, value: '₹${booking.serviceCharge}', isLast: true),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(MealBookingSummaryStrings.totalPayable, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                      Text('₹${booking.grandTotal}', style: AppTextStyles.h2(color: AppColors.accentOrange)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(MealBookingSummaryStrings.bookingTerms, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 6),
            Text(MealBookingSummaryStrings.bookingTermsBody, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
            const SizedBox(height: 24),
            Text(MealBookingSummaryStrings.onSiteContact, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const CircleAvatar(radius: 20, backgroundColor: AppColors.mintGreen, child: Icon(Icons.person_rounded, color: AppColors.primaryGreen)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Restaurant Manager', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                        Text('+91 98470 12345', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.call_rounded, color: AppColors.primaryGreen),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.isLast = false});

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodySm(color: AppColors.textGrey))),
          Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
