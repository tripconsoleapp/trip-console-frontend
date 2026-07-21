import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Success screen shown right after submission — reference/total, and a
/// "What Happens Next" preview of the admin-review → operator-assignment →
/// payment pipeline the trip now enters.
class TripSubmittedScreen extends StatelessWidget {
  const TripSubmittedScreen({super.key});

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}, ${date.year}';

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final now = DateTime.now();
    final reference = 'TC-${now.year}-${(1000 + draft.tripName.length * 37) % 9999}';

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
                decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, size: 40, color: AppColors.accentOrange),
              ),
            ),
            const SizedBox(height: 16),
            Text(TripSubmittedStrings.title, style: AppTextStyles.h2(color: AppColors.accentOrange), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(TripSubmittedStrings.body, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TripSubmittedStrings.tripReference, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                          Text(reference, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(TripSubmittedStrings.totalInvestment, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                          Text('₹${draft.servicesGrandTotal}', style: AppTextStyles.bodyLg(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFE2E2E2), height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(TripSubmittedStrings.submissionDate, style: AppTextStyles.bodySm()),
                      Text(_formatDate(now), style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(TripSubmittedStrings.whatHappensNext, style: AppTextStyles.h3(color: AppColors.textDark), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            const _NextStepTile(icon: Icons.fact_check_rounded, title: TripSubmittedStrings.adminReviewTitle, body: TripSubmittedStrings.adminReviewBody),
            const _NextStepTile(icon: Icons.groups_rounded, title: TripSubmittedStrings.operatorTitle, body: TripSubmittedStrings.operatorBody),
            const _NextStepTile(icon: Icons.payments_rounded, title: TripSubmittedStrings.paymentTitle, body: TripSubmittedStrings.paymentBody),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.go(AppRouter.myTrips),
                child: Text(TripSubmittedStrings.payment, style: AppTextStyles.button()),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go(AppRouter.myTrips),
                child: Text(TripSubmittedStrings.backToDashboard),
              ),
            ),
            const SizedBox(height: 20),
            Text(TripSubmittedStrings.emailNote, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.headset_mic_rounded, size: 14, color: AppColors.primaryGreen),
                const SizedBox(width: 6),
                Text(TripSubmittedStrings.conciergeActive, style: AppTextStyles.bodySm(color: AppColors.primaryGreen)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NextStepTile extends StatelessWidget {
  const _NextStepTile({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(body, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
