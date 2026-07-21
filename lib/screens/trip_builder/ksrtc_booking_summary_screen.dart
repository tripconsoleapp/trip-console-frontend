import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Layer 2 (begins) — recap of the verified bus and institutional fare
/// before it's registered with KSRTC.
class KsrtcBookingSummaryScreen extends StatelessWidget {
  const KsrtcBookingSummaryScreen({super.key});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();
    final bus = booking.selectedBus;
    final date = booking.travelDate;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(KsrtcBookingSummaryStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(KsrtcBookingSummaryStrings.changeBus, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        booking.confirmBooking();
                        context.push(AppRouter.ksrtcBookingConfirmation);
                      },
                      child: Text(KsrtcBookingSummaryStrings.confirmBooking, style: AppTextStyles.button()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(height: 140, width: double.infinity, color: AppColors.mintGreen.withValues(alpha: 0.3), child: const Icon(Icons.directions_bus_filled_rounded, size: 44, color: AppColors.primaryGreen)),
            ),
            const SizedBox(height: 16),
            Text(booking.tripName, style: AppTextStyles.h2(color: AppColors.textDark)),
            Text('${date.day} ${_months[date.month - 1]}, ${date.year}', style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(KsrtcBookingSummaryStrings.route, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                  Text('${booking.fromLocation} → ${booking.toLocation}', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(KsrtcBookingSummaryStrings.busDetails, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                  Text(bus == null ? '—' : '${bus.name} · ${bus.busType}', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(KsrtcBookingSummaryStrings.totalPassengers, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                  Text('${booking.totalPassengers} Students/Staff', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(KsrtcBookingSummaryStrings.baseFare, style: AppTextStyles.bodySm(color: AppColors.textDark)),
                      Text('₹${booking.baseFare}', style: AppTextStyles.h3(color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(KsrtcBookingSummaryStrings.costPerPerson, style: AppTextStyles.bodySm(color: AppColors.textGrey)),
                      Text('₹${booking.costPerPerson}', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700)),
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
                Expanded(child: Text(KsrtcBookingSummaryStrings.registerNote, style: AppTextStyles.bodySm().copyWith(fontSize: 12))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
