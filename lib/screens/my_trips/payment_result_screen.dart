import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/payment_args.dart';
import '../../models/trip_status.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Payment success confirmation — wording and the paid/remaining progress
/// bar change with whether this was a full payment, an advance, or clearing
/// a balance, but the layout is shared.
class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({super.key, required this.args});

  final PaymentArgs args;

  @override
  Widget build(BuildContext context) {
    final newAmountPaid = args.isBalance ? args.trip.totalCost : args.amount;
    final updatedTrip = args.trip.copyWith(
      status: newAmountPaid >= args.trip.totalCost ? TripStatus.paid : TripStatus.paid,
      amountPaid: newAmountPaid,
      updatedLabel: args.isAdvance ? 'Advance paid just now' : 'Paid in full just now',
    );
    final remaining = args.trip.totalCost - newAmountPaid;
    final paidPercent = args.trip.totalCost == 0 ? 100 : ((newAmountPaid / args.trip.totalCost) * 100).round();

    final title = args.isBalance
        ? PaymentResultStrings.balanceSuccessTitle
        : args.isAdvance
            ? PaymentResultStrings.advanceSuccessTitle
            : PaymentResultStrings.fullSuccessTitle;
    final body = args.isBalance
        ? PaymentResultStrings.balanceSuccessBody
        : args.isAdvance
            ? PaymentResultStrings.advanceSuccessBody
            : PaymentResultStrings.fullSuccessBody;

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
                decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, size: 40, color: AppColors.primaryGreen),
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.h3(color: AppColors.textDark), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(body, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    args.isBalance ? PaymentResultStrings.balanceAmountPaid : PaymentResultStrings.amountPaid,
                    style: AppTextStyles.labelCaps().copyWith(fontSize: 9),
                  ),
                  Text('₹${args.amount}', style: AppTextStyles.h2(color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  _ReceiptRow(label: PaymentResultStrings.transactionId, value: 'TXN-TC-2025-${args.trip.id.padLeft(4, '0')}'),
                  _ReceiptRow(label: PaymentResultStrings.dateTime, value: 'Mar 15, 2025 · 10:30 AM'),
                  _ReceiptRow(label: PaymentResultStrings.paymentMethod, value: 'Visa ending in 4242'),
                  if (args.isAdvance) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: paidPercent / 100,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFE2E2E2),
                        valueColor: const AlwaysStoppedAnimation(AppColors.accentOrange),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$paidPercent% ${PaymentResultStrings.paidPercent}', style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                        Text('${100 - paidPercent}% ${PaymentResultStrings.remainingPercent}', style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _ReceiptRow(label: PaymentResultStrings.remainingBalance, value: '₹$remaining'),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.mintGreen.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.landscape_rounded, color: AppColors.primaryGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(updatedTrip.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                        Text(updatedTrip.subtitle, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.push(AppRouter.tripDetail, extra: updatedTrip),
                child: Text(PaymentResultStrings.viewTripDetails, style: AppTextStyles.button()),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push(AppRouter.paymentReceipt, extra: updatedTrip),
                child: Text(PaymentResultStrings.downloadReceipt),
              ),
            ),
            const SizedBox(height: 16),
            Text('${PaymentResultStrings.emailNote} rahul.menon@stmarysschool.edu', style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text('${PaymentResultStrings.needHelp} ${PaymentResultStrings.contactConcierge}', style: AppTextStyles.bodySm(color: AppColors.accentOrange)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
          Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}
