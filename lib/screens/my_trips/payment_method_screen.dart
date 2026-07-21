import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/payment_args.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

enum _Method { card, upi, netBanking }

/// Payment method picker — Card / UPI / Net Banking — shared by the full,
/// advance, and balance payment paths via [PaymentArgs].
class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key, required this.args});

  final PaymentArgs args;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  _Method _method = _Method.card;

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  String get _dueDateLabel {
    final due = DateTime.now().add(const Duration(days: 21));
    return '${_months[due.month - 1]} ${due.day}, ${due.year}';
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final remaining = args.trip.totalCost - args.amount;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PaymentMethodStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () => context.push(AppRouter.paymentProcessing, extra: args),
                child: Text('Pay ₹${args.amount}', style: AppTextStyles.button()),
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
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            args.isAdvance ? PaymentMethodStrings.advanceAmount : PaymentMethodStrings.totalTripCost,
                            style: AppTextStyles.labelCaps().copyWith(fontSize: 9),
                          ),
                          Text('₹${args.amount}', style: AppTextStyles.h2(color: AppColors.textDark)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          args.isAdvance ? PaymentMethodStrings.payingAdvance : PaymentMethodStrings.payingInFull,
                          style: AppTextStyles.labelCaps(color: AppColors.accentOrange).copyWith(fontSize: 9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(args.trip.name, style: AppTextStyles.bodySm()),
                  Text(args.trip.caseReference, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                  if (args.isAdvance) ...[
                    const SizedBox(height: 8),
                    Text('${PaymentMethodStrings.remainingDuePrefix}$remaining${PaymentMethodStrings.remainingDueSuffix}$_dueDateLabel', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(PaymentMethodStrings.choosePaymentMethod, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 10),
            _MethodTile(
              icon: Icons.credit_card_rounded,
              title: PaymentMethodStrings.creditDebitCard,
              subtitle: PaymentMethodStrings.cardNetworks,
              selected: _method == _Method.card,
              onTap: () => setState(() => _method = _Method.card),
            ),
            _MethodTile(
              icon: Icons.qr_code_rounded,
              title: PaymentMethodStrings.upi,
              subtitle: PaymentMethodStrings.upiApps,
              selected: _method == _Method.upi,
              onTap: () => setState(() => _method = _Method.upi),
            ),
            _MethodTile(
              icon: Icons.account_balance_rounded,
              title: PaymentMethodStrings.netBanking,
              subtitle: PaymentMethodStrings.netBankingBody,
              selected: _method == _Method.netBanking,
              onTap: () => setState(() => _method = _Method.netBanking),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.textGrey),
                const SizedBox(width: 6),
                Text(PaymentMethodStrings.securityNote, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({required this.icon, required this.title, required this.subtitle, required this.selected, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
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
                  Text(subtitle, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                ],
              ),
            ),
            Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded, size: 20, color: selected ? AppColors.accentOrange : AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
