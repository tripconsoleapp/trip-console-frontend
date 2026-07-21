import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/payment_args.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Payment failure state — reachable directly for design completeness, but
/// not currently wired to any trigger since [PaymentProcessingScreen]
/// always resolves to success in this mock (no real payment gateway).
class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({super.key, required this.args});

  final PaymentArgs args;

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.close_rounded, size: 40, color: AppColors.error),
              ),
            ),
            const SizedBox(height: 16),
            Text(PaymentFailedStrings.title, style: AppTextStyles.h2(color: AppColors.textDark), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(PaymentFailedStrings.body, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(PaymentFailedStrings.transactionDetails, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                  const SizedBox(height: 6),
                  Text('${PaymentFailedStrings.reasonPrefix}${PaymentFailedStrings.defaultReason}', style: AppTextStyles.bodySm(color: AppColors.textDark)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(PaymentFailedStrings.whatToDoNext, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 10),
            const _Tip(text: PaymentFailedStrings.tip1),
            const _Tip(text: PaymentFailedStrings.tip2),
            const _Tip(text: PaymentFailedStrings.tip3),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.pushReplacement(AppRouter.paymentMethod, extra: args),
                child: Text('${PaymentFailedStrings.tryAgain} →', style: AppTextStyles.button()),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push(AppRouter.tripDetail, extra: args.trip),
                child: Text(PaymentFailedStrings.payLater),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right_rounded, size: 18, color: AppColors.textGrey),
          Expanded(child: Text(text, style: AppTextStyles.bodySm(color: AppColors.textDark))),
        ],
      ),
    );
  }
}
