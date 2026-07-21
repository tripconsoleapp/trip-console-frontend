import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Layer 3 — the pool is complete; recap the collected/fee split and show
/// the pipeline moving from "pooled" to "ready to transfer to KSRTC".
class FullAmountConsolidatedScreen extends StatelessWidget {
  const FullAmountConsolidatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(FullAmountConsolidatedStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () {
                  booking.completeTransfer();
                  context.push(AppRouter.ksrtcTransferConfirmation);
                },
                child: Text('${FullAmountConsolidatedStrings.transferToKsrtc} →', style: AppTextStyles.button()),
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen),
                  const SizedBox(width: 10),
                  Expanded(child: Text('${FullAmountConsolidatedStrings.fullyCollectedPrefix}${booking.totalToCollect}', style: AppTextStyles.bodyLg(color: AppColors.primaryGreen).copyWith(fontWeight: FontWeight.w700))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(height: 130, width: double.infinity, color: AppColors.mintGreen.withValues(alpha: 0.3), child: const Icon(Icons.verified_rounded, size: 40, color: AppColors.primaryGreen)),
            ),
            const SizedBox(height: 8),
            Center(child: Text(FullAmountConsolidatedStrings.consolidationVerified, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600))),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _Row(label: FullAmountConsolidatedStrings.totalCollectedFromMembers, value: '₹${booking.amountCollected}'),
                  _Row(label: FullAmountConsolidatedStrings.tripConsoleServiceFee, value: '₹${KsrtcBookingProvider.serviceFeeFlat}'),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(FullAmountConsolidatedStrings.totalReceivable, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                          Text('₹${booking.totalToCollect}', style: AppTextStyles.h3(color: AppColors.textDark)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(FullAmountConsolidatedStrings.secured, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textGrey),
                const SizedBox(width: 8),
                Expanded(child: Text(FullAmountConsolidatedStrings.transferNote, style: AppTextStyles.bodySm().copyWith(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 24),
            Text(FullAmountConsolidatedStrings.processTimeline, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 10),
            _TimelineTile(label: FullAmountConsolidatedStrings.memberPoolingCompleted, done: true),
            _TimelineTile(label: FullAmountConsolidatedStrings.readyForKsrtcTransfer, done: false, current: true),
            _TimelineTile(label: FullAmountConsolidatedStrings.finalReceiptGeneration, done: false),
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
          Text(label, style: AppTextStyles.bodySm(color: AppColors.textDark)),
          Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.label, required this.done, this.current = false});

  final String label;
  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.primaryGreen : (current ? AppColors.accentOrange : const Color(0xFFD0D0D0));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(done ? Icons.check_circle_rounded : Icons.circle_outlined, size: 18, color: color),
          const SizedBox(width: 10),
          Text(label, style: AppTextStyles.bodyLg(color: done || current ? AppColors.textDark : AppColors.textGrey)),
        ],
      ),
    );
  }
}
