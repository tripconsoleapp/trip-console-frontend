import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Layer 3 — a dashboard view of collection health: circular gauge, paid/
/// pending/days-left stat blocks, and the vehicle recap. Route into Full
/// Amount Consolidated once the pool is complete.
class PaymentProgressTrackerScreen extends StatelessWidget {
  const PaymentProgressTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();
    final percent = (booking.collectionProgress * 100).round();
    final remaining = booking.totalToCollect - booking.amountCollected;
    final daysLeft = booking.travelDate.difference(DateTime.now()).inDays.clamp(0, 999);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PaymentProgressTrackerStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(value: booking.collectionProgress, strokeWidth: 12, backgroundColor: const Color(0xFFF5F3F3), color: AppColors.accentOrange),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$percent%', style: AppTextStyles.h1(color: AppColors.textDark)),
                        Text(PaymentProgressTrackerStrings.collected, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(child: Text('₹${booking.amountCollected} collected / ₹${booking.totalToCollect} needed', style: AppTextStyles.bodySm())),
            const SizedBox(height: 20),
            Row(
              children: [
                _StatBlock(value: '${booking.paidCount}', label: PaymentProgressTrackerStrings.paid),
                _StatBlock(value: '${booking.pendingCount}', label: PaymentProgressTrackerStrings.pendingLabel),
                _StatBlock(value: '$daysLeft', label: PaymentProgressTrackerStrings.daysLeft),
              ],
            ),
            if (!booking.isFullyCollected) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.accentOrange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$daysLeft ${PaymentProgressTrackerStrings.warningPrefix}₹$remaining${PaymentProgressTrackerStrings.warningSuffix}${booking.pendingCount}${PaymentProgressTrackerStrings.warningMembersSuffix}',
                        style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(PaymentProgressTrackerStrings.vehicleDetails, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(booking.selectedBus?.name ?? '—', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(PaymentProgressTrackerStrings.confirmed, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('${booking.fromLocation} → ${booking.toLocation}', style: AppTextStyles.bodySm()),
                  const SizedBox(height: 6),
                  Text('${booking.splitMemberCount}/${booking.totalPassengers} ${PaymentProgressTrackerStrings.seatsSuffix}', style: AppTextStyles.bodySm()),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRouter.memberPaymentCollection),
                    child: Text(PaymentProgressTrackerStrings.viewMemberStatus, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: booking.isFullyCollected ? () => context.push(AppRouter.fullAmountConsolidated) : booking.sendAllReminders,
                      child: Text(
                        booking.isFullyCollected ? 'Continue →' : PaymentProgressTrackerStrings.sendAllReminders,
                        style: AppTextStyles.button(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.h2(color: AppColors.textDark)),
          Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
        ],
      ),
    );
  }
}
