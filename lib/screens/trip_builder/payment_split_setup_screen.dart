import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/counter_field.dart';

/// Layer 3 (begins) — turns the flat KSRTC fare into a per-member share and
/// picks how it gets collected (UPI link vs manual organizer tracking).
class PaymentSplitSetupScreen extends StatelessWidget {
  const PaymentSplitSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PaymentSplitSetupStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                  booking.startCollection();
                  context.push(AppRouter.memberPaymentCollection);
                },
                child: Text('${PaymentSplitSetupStrings.startCollection} →', style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(PaymentSplitSetupStrings.fareBreakdown, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _Row(label: PaymentSplitSetupStrings.totalBusHire, value: '₹${booking.baseFare}'),
                  _Row(label: PaymentSplitSetupStrings.tripConsoleServiceFee, value: '₹${KsrtcBookingProvider.serviceFeeFlat}'),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(PaymentSplitSetupStrings.totalToCollect, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                      Text('₹${booking.totalToCollect}', style: AppTextStyles.h3(color: AppColors.accentOrange)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('${PaymentSplitSetupStrings.splitAcrossPrefix}${booking.splitMemberCount}${PaymentSplitSetupStrings.splitAcrossSuffix}', style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            CounterField(
              label: PaymentSplitSetupStrings.includeStaff,
              sublabel: '',
              value: booking.splitMemberCount,
              onChanged: booking.setSplitMemberCount,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Switch(value: booking.includeStaffInSplit, activeThumbColor: AppColors.accentOrange, onChanged: booking.setIncludeStaffInSplit),
                const SizedBox(width: 8),
                Text(PaymentSplitSetupStrings.includeStaff, style: AppTextStyles.bodySm(color: AppColors.textDark)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(PaymentSplitSetupStrings.perPersonAmount, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
                  Text('₹${booking.perPersonAmount}', style: AppTextStyles.h2(color: AppColors.accentOrange)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(PaymentSplitSetupStrings.amountAdjustedNote, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
            ),
            const SizedBox(height: 24),
            Text(PaymentSplitSetupStrings.collectionMethod, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            _MethodTile(
              icon: Icons.ios_share_rounded,
              title: PaymentSplitSetupStrings.shareUpiLink,
              body: PaymentSplitSetupStrings.shareUpiLinkBody,
              selected: booking.collectionMethod == PaymentSplitSetupStrings.shareUpiLink,
              onTap: () => booking.setCollectionMethod(PaymentSplitSetupStrings.shareUpiLink),
            ),
            const SizedBox(height: 10),
            _MethodTile(
              icon: Icons.person_pin_circle_rounded,
              title: PaymentSplitSetupStrings.organizerCollects,
              body: PaymentSplitSetupStrings.organizerCollectsBody,
              selected: booking.collectionMethod == PaymentSplitSetupStrings.organizerCollects,
              onTap: () => booking.setCollectionMethod(PaymentSplitSetupStrings.organizerCollects),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textGrey),
                const SizedBox(width: 8),
                Expanded(child: Text(PaymentSplitSetupStrings.automationNote, style: AppTextStyles.bodySm().copyWith(fontSize: 12))),
              ],
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
          Text(label, style: AppTextStyles.bodySm(color: AppColors.textDark)),
          Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({required this.icon, required this.title, required this.body, required this.selected, required this.onTap});

  final IconData icon;
  final String title;
  final String body;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange.withValues(alpha: 0.06) : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? AppColors.accentOrange : AppColors.textGrey),
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
            Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: selected ? AppColors.accentOrange : AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
