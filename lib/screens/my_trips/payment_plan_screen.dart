import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/payment_args.dart';
import '../../models/trip_summary.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// First step of paying for a verified trip — full amount now, or a 20%
/// advance with the remainder due closer to departure.
class PaymentPlanScreen extends StatefulWidget {
  const PaymentPlanScreen({super.key, required this.trip});

  final TripSummary trip;

  @override
  State<PaymentPlanScreen> createState() => _PaymentPlanScreenState();
}

class _PaymentPlanScreenState extends State<PaymentPlanScreen> {
  bool _payFull = true;

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  String get _dueDateLabel {
    final due = DateTime.now().add(const Duration(days: 21));
    return '${_months[due.month - 1]} ${due.day}, ${due.year}';
  }

  @override
  Widget build(BuildContext context) {
    final advanceAmount = (widget.trip.totalCost * 0.2).round();
    final remaining = widget.trip.totalCost - advanceAmount;
    final payAmount = _payFull ? widget.trip.totalCost : advanceAmount;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PaymentPlanStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () => context.push(
                  AppRouter.paymentMethod,
                  extra: PaymentArgs(trip: widget.trip, amount: payAmount, isAdvance: !_payFull, isBalance: false),
                ),
                child: Text('${PaymentPlanStrings.payNowPrefix}$payAmount${PaymentPlanStrings.payNowSuffix}', style: AppTextStyles.button()),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.trip.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                        Text(widget.trip.caseReference, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text('ACTIVE', style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(PaymentPlanStrings.choosePlanPrompt, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 12),
            _PlanCard(
              title: PaymentPlanStrings.payFullAmount,
              badge: PaymentPlanStrings.recommended,
              amount: widget.trip.totalCost,
              body: PaymentPlanStrings.payFullBody,
              selected: _payFull,
              onTap: () => setState(() => _payFull = true),
            ),
            const SizedBox(height: 12),
            _PlanCard(
              title: PaymentPlanStrings.payAdvance,
              badge: PaymentPlanStrings.flexible,
              amount: advanceAmount,
              body: '${PaymentPlanStrings.payAdvanceBodyPrefix}₹$remaining${PaymentPlanStrings.payAdvanceBodySuffix}$_dueDateLabel',
              selected: !_payFull,
              onTap: () => setState(() => _payFull = false),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.title, required this.badge, required this.amount, required this.body, required this.selected, required this.onTap});

  final String title;
  final String badge;
  final int amount;
  final String body;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange.withValues(alpha: 0.06) : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded, size: 20, color: selected ? AppColors.accentOrange : AppColors.textGrey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(6)),
                        child: Text(badge, style: AppTextStyles.labelCaps().copyWith(fontSize: 8)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('₹$amount', style: AppTextStyles.h2(color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text(body, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
