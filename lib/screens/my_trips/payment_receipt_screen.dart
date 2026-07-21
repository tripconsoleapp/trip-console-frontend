import 'package:flutter/material.dart';

import '../../models/trip_summary.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';

/// Formal, shareable payment receipt for a trip — issued-on date,
/// advance/balance breakdown, transaction ID, and who it's billed to.
class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({super.key, required this.trip});

  final TripSummary trip;

  static const _months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}, ${date.year}';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final advancePaid = trip.amountPaid < trip.totalCost ? trip.amountPaid : (trip.totalCost * 0.2).round();
    final balancePaid = trip.amountPaid >= trip.totalCost ? trip.totalCost - advancePaid : 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PaymentReceiptStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('↓ ${PaymentReceiptStrings.downloadAsPdf}', style: AppTextStyles.button()),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(onPressed: () {}, child: Text(PaymentReceiptStrings.shareReceipt)),
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
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: AppColors.accentOrange, borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: const Icon(Icons.explore_rounded, size: 18, color: AppColors.backgroundWhite),
                ),
                const SizedBox(width: 8),
                Text('TripConsole', style: AppTextStyles.h3(color: AppColors.textDark)),
              ],
            ),
            const SizedBox(height: 20),
            Text(PaymentReceiptStrings.receiptFor, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
            Text(trip.name, style: AppTextStyles.h2(color: AppColors.textDark)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(PaymentReceiptStrings.tripReference, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                      Text(trip.caseReference, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(PaymentReceiptStrings.issuedOn, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                      Text(_formatDate(now), style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFE2E2E2)),
            const SizedBox(height: 12),
            if (advancePaid > 0)
              _AmountRow(label: PaymentReceiptStrings.advancePayment, amount: advancePaid),
            if (balancePaid > 0)
              _AmountRow(label: PaymentReceiptStrings.balancePayment, amount: balancePaid),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFFE2E2E2)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(PaymentReceiptStrings.totalPaid, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                Text('₹${trip.amountPaid}', style: AppTextStyles.h3(color: AppColors.accentOrange)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Transaction ID: TXN-TC-2025-${trip.id.padLeft(4, '0')}', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
            Text('Payment Method: Visa ending in 4242', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
            const SizedBox(height: 24),
            Text(PaymentReceiptStrings.billedTo, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const CircleAvatar(radius: 18, backgroundColor: AppColors.accentOrange, child: Text('RM', style: TextStyle(color: AppColors.backgroundWhite, fontSize: 12, fontWeight: FontWeight.w700))),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rahul M.', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                      Text('rahul.menon@stmarysschool.edu', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                      Text("St. Mary's Higher Secondary School", style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(PaymentReceiptStrings.emailedNote, style: AppTextStyles.bodySm().copyWith(fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySm(color: AppColors.textDark)),
          Text('₹$amount', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
