import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/restaurant_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Terminal success screen for the Restaurant Only Booking flow — the
/// request has been sent but isn't confirmed yet (no payment collected),
/// so this leans on a "What's Next?" explainer rather than a receipt.
class MealBookingSentScreen extends StatelessWidget {
  const MealBookingSentScreen({super.key});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context) {
    final booking = context.read<RestaurantBookingProvider>();
    final dates = booking.sortedMealDates;
    final dateRange = dates.isEmpty ? '—' : '${dates.first.day} ${_months[dates.first.month - 1]} – ${dates.last.day} ${_months[dates.last.month - 1]}, ${dates.last.year}';
    final restaurantName = booking.selectedRestaurant?.name ?? '';
    final totalAmount = booking.grandTotal;
    final totalGuests = booking.totalGuests;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, size: 40, color: AppColors.accentOrange),
              ),
            ),
            const SizedBox(height: 16),
            Text(MealBookingSentStrings.title, style: AppTextStyles.h2(color: AppColors.accentOrange), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(MealBookingSentStrings.awaitingConfirmation, style: AppTextStyles.labelCaps(color: AppColors.accentOrange).copyWith(fontSize: 10)),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurantName, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(MealBookingSentStrings.dates, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                          Text(dateRange, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(MealBookingSentStrings.group, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                          Text('$totalGuests Participants', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(MealBookingSentStrings.totalAmount, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                      Text('₹$totalAmount', style: AppTextStyles.bodyLg(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(MealBookingSentStrings.whatsNext, style: AppTextStyles.h3(color: AppColors.textDark), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            _NextStepTile(number: 1, title: MealBookingSentStrings.step1Title, body: MealBookingSentStrings.step1Body),
            _NextStepTile(number: 2, title: MealBookingSentStrings.step2Title, body: MealBookingSentStrings.step2Body),
            _NextStepTile(number: 3, title: MealBookingSentStrings.step3Title, body: MealBookingSentStrings.step3Body),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.read<RestaurantBookingProvider>().reset();
                  context.go(AppRouter.myTrips);
                },
                child: Text(MealBookingSentStrings.viewAllBookings),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  context.read<RestaurantBookingProvider>().reset();
                  context.go(AppRouter.home);
                },
                child: Text(MealBookingSentStrings.goToDashboard, style: AppTextStyles.button()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextStepTile extends StatelessWidget {
  const _NextStepTile({required this.number, required this.title, required this.body});

  final int number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), shape: BoxShape.circle),
            child: Text('$number', style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                Text(body, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
