import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Layer 2 (ends) — the bus is reserved in KSRTC's system; group payment
/// must be completed by the deadline to lock it in.
class KsrtcBookingConfirmationScreen extends StatelessWidget {
  const KsrtcBookingConfirmationScreen({super.key});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static String _fmt(DateTime d) => '${d.day} ${_months[d.month - 1]}, ${d.year}';

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();
    final deadline = booking.travelDate.subtract(const Duration(days: 3));

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(KsrtcBookingConfirmationStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () => context.push(AppRouter.paymentSplitSetup),
                child: Text('${KsrtcBookingConfirmationStrings.collectGroupPayment} →', style: AppTextStyles.button()),
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
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, size: 36, color: AppColors.primaryGreen),
              ),
            ),
            const SizedBox(height: 12),
            Text(KsrtcBookingConfirmationStrings.busBooked, style: AppTextStyles.h2(color: AppColors.textDark), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(KsrtcBookingConfirmationStrings.body, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              children: [
                _ProgressStep(label: KsrtcBookingConfirmationStrings.reserved, done: true, index: 1),
                _ProgressLine(),
                _ProgressStep(label: KsrtcBookingConfirmationStrings.payment, done: false, current: true, index: 2),
                _ProgressLine(),
                _ProgressStep(label: KsrtcBookingConfirmationStrings.ticket, done: false, index: 3),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _Row(label: KsrtcBookingConfirmationStrings.reference, value: booking.bookingReference ?? '—'),
                  _Row(label: KsrtcBookingConfirmationStrings.bus, value: booking.selectedBus?.name ?? '—'),
                  _Row(label: KsrtcBookingConfirmationStrings.routeAndDate, value: '${booking.fromLocation} → ${booking.toLocation} · ${_fmt(booking.travelDate)}'),
                  const Divider(height: 20),
                  _Row(label: KsrtcBookingConfirmationStrings.paymentDue, value: '₹${booking.totalToCollect}'),
                  _Row(label: KsrtcBookingConfirmationStrings.paymentDeadline, value: _fmt(deadline), valueColor: AppColors.error),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Container(height: 150, width: double.infinity, color: AppColors.mintGreen.withValues(alpha: 0.3), child: const Icon(Icons.map_rounded, size: 40, color: AppColors.primaryGreen)),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)),
                      child: Text(KsrtcBookingConfirmationStrings.liveRoutePreview, style: AppTextStyles.labelCaps(color: AppColors.backgroundWhite).copyWith(fontSize: 9)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(KsrtcBookingConfirmationStrings.expiryNote, style: AppTextStyles.bodySm().copyWith(fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySm(color: AppColors.textGrey)),
          Text(value, style: AppTextStyles.bodySm(color: valueColor ?? AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  const _ProgressStep({required this.label, required this.done, required this.index, this.current = false});

  final String label;
  final bool done;
  final bool current;
  final int index;

  @override
  Widget build(BuildContext context) {
    final active = done || current;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle, color: active ? (current ? AppColors.accentOrange : AppColors.primaryGreen) : const Color(0xFFE2E2E2)),
          child: done
              ? const Icon(Icons.check_rounded, size: 16, color: AppColors.backgroundWhite)
              : Text('$index', style: AppTextStyles.bodySm(color: active ? AppColors.backgroundWhite : AppColors.textGrey).copyWith(fontWeight: FontWeight.w700, fontSize: 12)),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodySm(color: active ? AppColors.textDark : AppColors.textGrey).copyWith(fontSize: 10)),
      ],
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine();

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 16), child: Container(height: 2, color: AppColors.primaryGreen.withValues(alpha: 0.4))));
  }
}
