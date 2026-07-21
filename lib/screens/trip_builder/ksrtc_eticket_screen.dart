import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Post-payment — the finished KSRTC e-ticket, with a QR code and the
/// option to share it with the whole travelling group.
class KsrtcETicketScreen extends StatelessWidget {
  const KsrtcETicketScreen({super.key});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();
    final date = booking.travelDate;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(KsrtcETicketStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(KsrtcETicketStrings.postPayment, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => context.push(AppRouter.shareProcessing),
                      child: Text(KsrtcETicketStrings.shareWithGroup, style: AppTextStyles.button()),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(KsrtcETicketStrings.pdf, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E2E2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.confirmation_number_rounded, color: AppColors.accentOrange),
                      const SizedBox(width: 8),
                      Text('TripConsole', style: AppTextStyles.h3(color: AppColors.textDark)),
                    ],
                  ),
                  const Divider(height: 28),
                  Text(KsrtcETicketStrings.bookingReference, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                  Text(booking.bookingReference ?? '—', style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 14),
                  Text(KsrtcETicketStrings.busNumberAndType, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                  Text(booking.selectedBus == null ? '—' : '${booking.selectedBus!.name} · ${booking.selectedBus!.busType}', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(KsrtcETicketStrings.route, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                            Text('${booking.fromLocation} → ${booking.toLocation}', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(KsrtcETicketStrings.passengers, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                          Text('${booking.totalPassengers} Adults', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(KsrtcETicketStrings.dateAndDeparture, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                  Text('${date.day} ${_months[date.month - 1]}, ${date.year}, 06:00 AM', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(KsrtcETicketStrings.confirmedAndPaid, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.qr_code_2_rounded, size: 88, color: AppColors.textDark),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(child: Text(KsrtcETicketStrings.supportNote, style: AppTextStyles.bodySm().copyWith(fontSize: 12))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
