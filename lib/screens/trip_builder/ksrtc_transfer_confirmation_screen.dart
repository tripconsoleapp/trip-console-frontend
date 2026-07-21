import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Layer 3 (ends) — the pooled amount has been transferred to KSRTC. Two
/// receipts: the KSRTC transfer itself, and TripConsole's service fee.
class KsrtcTransferConfirmationScreen extends StatelessWidget {
  const KsrtcTransferConfirmationScreen({super.key});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(KsrtcTransferConfirmationStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () => context.push(AppRouter.ksrtcETicket),
                child: Text('${KsrtcTransferConfirmationStrings.downloadETicket} ⬇', style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, size: 40, color: AppColors.primaryGreen),
              ),
            ),
            const SizedBox(height: 12),
            Text(KsrtcTransferConfirmationStrings.paymentTransferred, style: AppTextStyles.h2(color: AppColors.textDark), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Text(KsrtcTransferConfirmationStrings.transferReceipt, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _Row(label: KsrtcTransferConfirmationStrings.amountTransferred, value: '₹${booking.baseFare}'),
                  _Row(label: KsrtcTransferConfirmationStrings.ksrtcAccountReference, value: 'KSRTC-ACC-5521'),
                  _Row(label: KsrtcTransferConfirmationStrings.transactionId, value: booking.transferTransactionId ?? '—'),
                  _Row(label: KsrtcTransferConfirmationStrings.dateAndTime, value: '${now.day} ${_months[now.month - 1]}, ${now.year}, ${TimeOfDay.fromDateTime(now).format(context)}'),
                  _Row(label: KsrtcTransferConfirmationStrings.transferMethod, value: 'UPI'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(KsrtcTransferConfirmationStrings.tripConsoleFeeReceipt, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _Row(label: KsrtcTransferConfirmationStrings.serviceFeeCollected, value: '₹${KsrtcBookingProvider.serviceFeeFlat}'),
                  _Row(label: KsrtcTransferConfirmationStrings.paidBy, value: KsrtcTransferConfirmationStrings.splitAcrossMembers),
                  _Row(label: '', value: '${booking.paidCount}${KsrtcTransferConfirmationStrings.activeMembersContributedSuffix}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(height: 120, width: double.infinity, color: AppColors.mintGreen.withValues(alpha: 0.3), child: const Icon(Icons.directions_bus_filled_rounded, size: 36, color: AppColors.primaryGreen)),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
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
