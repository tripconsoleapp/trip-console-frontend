import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/hotel_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../widgets/confirm_hotel_booking_sheet.dart';

/// Step 4 of 5 — final recap of stay details and cost before confirmation.
class HotelBookingSummaryScreen extends StatelessWidget {
  const HotelBookingSummaryScreen({super.key});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static String _formatDate(DateTime? date) => date == null ? '—' : '${date.day} ${_months[date.month - 1]}';

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<HotelBookingProvider>();
    final nights = booking.nights == 0 ? 1 : booking.nights;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(HotelBookingSummaryStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () => ConfirmHotelBookingSheet.show(context),
                child: Text(HotelBookingSummaryStrings.confirmAndProceed, style: AppTextStyles.button()),
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
              child: Text(HotelBookingSummaryStrings.stepPrefix, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 10)),
            ),
            const SizedBox(height: 20),
            Text(HotelBookingSummaryStrings.stayDetails, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _SummaryRow(label: HotelBookingSummaryStrings.hotel, value: booking.selectedHotel?.name ?? '—'),
                  _SummaryRow(label: HotelBookingSummaryStrings.roomType, value: booking.selectedRoomType?.name ?? '—'),
                  _SummaryRow(label: HotelBookingSummaryStrings.checkIn, value: _formatDate(booking.checkIn)),
                  _SummaryRow(label: HotelBookingSummaryStrings.checkOut, value: _formatDate(booking.checkOut)),
                  _SummaryRow(label: HotelBookingSummaryStrings.duration, value: '$nights Nights · ${booking.roomsNeeded} Rooms'),
                  _SummaryRow(label: HotelBookingSummaryStrings.guests, value: '${booking.totalGuests}'),
                  _SummaryRow(label: HotelBookingSummaryStrings.mealPlan, value: booking.selectedMealPlan ?? SelectMealPlanStrings.roomOnly, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(HotelBookingSummaryStrings.costBreakdown, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _SummaryRow(label: HotelBookingSummaryStrings.roomCost, value: '₹${booking.roomCost}'),
                  _SummaryRow(label: HotelBookingSummaryStrings.mealCost, value: '₹${booking.mealCost}'),
                  _SummaryRow(label: HotelBookingSummaryStrings.taxes, value: '₹${booking.taxes}', isLast: true),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(HotelBookingSummaryStrings.totalAmount, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                          Text(HotelBookingSummaryStrings.allInclusive, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                        ],
                      ),
                      Text('₹${booking.grandTotal}', style: AppTextStyles.h2(color: AppColors.accentOrange)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(HotelBookingSummaryStrings.cancellationPolicy, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 6),
            Text(HotelBookingSummaryStrings.cancellationPolicyBody, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
            const SizedBox(height: 24),
            Text(HotelBookingSummaryStrings.hotelManager, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                        Text('Rajesh Menon', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                        Text('+91 98470 XXXXX', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
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
          Text(label, style: AppTextStyles.bodySm(color: AppColors.textGrey)),
          Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
