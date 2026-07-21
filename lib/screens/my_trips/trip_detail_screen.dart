import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/payment_args.dart';
import '../../models/trip_status.dart';
import '../../models/trip_summary.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Central hub for one submitted trip — status banner, a verification
/// checklist, cost breakdown, assigned operator/coordinator, documents, and
/// a CTA that changes with [TripSummary.status] (choose a payment plan,
/// pay the remaining balance, or just view the itinerary once settled).
class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key, required this.trip});

  final TripSummary trip;

  @override
  Widget build(BuildContext context) {
    final isVerified = trip.status == TripStatus.verified;
    final hasBalance = trip.status == TripStatus.paid && trip.balanceDue > 0;
    final isFullyPaid = trip.amountPaid > 0 && trip.balanceDue <= 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(TripDetailStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildCta(context, isVerified: isVerified, hasBalance: hasBalance, isFullyPaid: isFullyPaid),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (trip.status == TripStatus.submitted) _StatusBanner.review(),
            if (isVerified) _StatusBanner.verified(),
            if (isFullyPaid) _StatusBanner.fullyPaid(),
            if (hasBalance) _StatusBanner.balanceDue(trip.balanceDue),
            const SizedBox(height: 16),
            Text(trip.name, style: AppTextStyles.h2(color: AppColors.textDark)),
            Text(trip.subtitle, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            if (trip.totalCost > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatColumn(label: 'TOTAL TRIP COST', value: '₹${trip.totalCost}'),
                  if (trip.amountPaid > 0) _StatColumn(label: 'PAID SO FAR', value: '₹${trip.amountPaid}', valueColor: AppColors.primaryGreen),
                ],
              ),
              const SizedBox(height: 20),
            ],
            Text(TripDetailStrings.verificationStatus, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 10),
            _VerificationStep(
              label: TripDetailStrings.stepSubmitted,
              state: _StepState.done,
              caption: trip.updatedLabel,
            ),
            _VerificationStep(
              label: TripDetailStrings.stepAdminVerification,
              state: trip.status == TripStatus.submitted
                  ? _StepState.inProgress
                  : _StepState.done,
            ),
            _VerificationStep(
              label: TripDetailStrings.stepOperatorAssignment,
              state: trip.status == TripStatus.submitted
                  ? _StepState.pending
                  : (isVerified ? _StepState.inProgress : _StepState.done),
            ),
            _VerificationStep(
              label: TripDetailStrings.stepPayment,
              state: isFullyPaid
                  ? _StepState.done
                  : (hasBalance ? _StepState.inProgress : _StepState.pending),
              caption: (trip.status == TripStatus.submitted || isVerified) ? TripDetailStrings.lockedNote : null,
            ),
            if (trip.status == TripStatus.paid || trip.status == TripStatus.completed) ...[
              const SizedBox(height: 20),
              _InfoRow(icon: Icons.local_shipping_rounded, label: TripDetailStrings.assignedOperator, value: 'Kerala Travels Pvt Ltd'),
              _InfoRow(icon: Icons.person_pin_rounded, label: TripDetailStrings.fieldCoordinator, value: 'Rajesh Kumar (+91 98765 43210)'),
            ],
            if (trip.totalCost > 0) ...[
              const SizedBox(height: 20),
              Text(TripDetailStrings.costBreakdown, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    _CostRow(label: TripDetailStrings.transport, amount: (trip.totalCost * 0.35).round()),
                    _CostRow(label: TripDetailStrings.accommodation, amount: (trip.totalCost * 0.4).round()),
                    _CostRow(label: TripDetailStrings.activities, amount: (trip.totalCost * 0.25).round()),
                    const Divider(color: Color(0xFFE2E2E2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(TripDetailStrings.total, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                        Text('₹${trip.totalCost}', style: AppTextStyles.h3(color: AppColors.accentOrange)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (trip.status == TripStatus.paid || trip.status == TripStatus.completed) ...[
              const SizedBox(height: 20),
              Text(TripDetailStrings.documents, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 10),
              const _DocumentRow(name: 'Itinerary PDF'),
              const _DocumentRow(name: 'Payment Receipt'),
              const _DocumentRow(name: 'Consent Form'),
              const _DocumentRow(name: 'Insurance Summary'),
            ],
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.headset_mic_rounded, color: AppColors.primaryGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TripDetailStrings.needHelp, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                        Text(TripDetailStrings.conciergeSupportBody, style: AppTextStyles.bodySm()),
                      ],
                    ),
                  ),
                  TextButton(onPressed: () {}, child: Text(TripDetailStrings.chatNow, style: AppTextStyles.bodySm(color: AppColors.primaryGreen))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCta(BuildContext context, {required bool isVerified, required bool hasBalance, required bool isFullyPaid}) {
    if (isVerified) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.push(AppRouter.paymentPlan, extra: trip),
              child: Text('${TripDetailStrings.choosePaymentPlan} →', style: AppTextStyles.button()),
            ),
          ),
          TextButton(onPressed: () => context.pop(), child: Text(TripDetailStrings.remindMeLater, style: AppTextStyles.bodySm(color: AppColors.textGrey))),
        ],
      );
    }
    if (hasBalance) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () => context.push(
            AppRouter.paymentMethod,
            extra: PaymentArgs(trip: trip, amount: trip.balanceDue, isAdvance: false, isBalance: true),
          ),
          child: Text('${TripDetailStrings.payBalanceNow} — ₹${trip.balanceDue}', style: AppTextStyles.button()),
        ),
      );
    }
    if (isFullyPaid) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.push(AppRouter.lockedItinerary, extra: trip),
              child: Text(TripDetailStrings.viewItinerary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.push(AppRouter.paymentReceipt, extra: trip),
              child: Text(TripDetailStrings.downloadReceipt, style: AppTextStyles.button()),
            ),
          ),
        ],
      );
    }
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => context.go(AppRouter.myTrips),
        child: Text(TripSubmittedStrings.backToDashboard),
      ),
    );
  }
}

enum _StepState { done, inProgress, pending }

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.icon, required this.title, required this.body, required this.color});

  factory _StatusBanner.review() => const _StatusBanner(
        icon: Icons.hourglass_top_rounded,
        title: TripDetailStrings.underAdminReview,
        body: TripDetailStrings.underAdminReviewBody,
        color: AppColors.accentOrange,
      );

  factory _StatusBanner.verified() => const _StatusBanner(
        icon: Icons.celebration_rounded,
        title: TripDetailStrings.verifiedTitle,
        body: TripDetailStrings.verifiedBody,
        color: AppColors.primaryGreen,
      );

  factory _StatusBanner.fullyPaid() => const _StatusBanner(
        icon: Icons.check_circle_rounded,
        title: TripDetailStrings.fullyPaid,
        body: 'All payments complete for this trip.',
        color: AppColors.primaryGreen,
      );

  factory _StatusBanner.balanceDue(int amount) => _StatusBanner(
        icon: Icons.warning_amber_rounded,
        title: '${TripDetailStrings.balanceDue}: ₹$amount',
        body: 'Complete payment to fully confirm your booking.',
        color: AppColors.accentOrange,
      );

  final IconData icon;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLg(color: color).copyWith(fontWeight: FontWeight.w700)),
                Text(body, style: AppTextStyles.bodySm(color: AppColors.textDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
        Text(value, style: AppTextStyles.h3(color: valueColor ?? AppColors.textDark)),
      ],
    );
  }
}

class _VerificationStep extends StatelessWidget {
  const _VerificationStep({required this.label, required this.state, this.caption});

  final String label;
  final _StepState state;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      _StepState.done => AppColors.primaryGreen,
      _StepState.inProgress => AppColors.accentOrange,
      _StepState.pending => AppColors.textGrey,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            state == _StepState.done
                ? Icons.check_circle_rounded
                : state == _StepState.inProgress
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                if (caption != null) Text(caption!, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
              ],
            ),
          ),
          if (state != _StepState.done)
            Text(
              state == _StepState.inProgress ? TripDetailStrings.inProgress : TripDetailStrings.pending,
              style: AppTextStyles.labelCaps(color: color).copyWith(fontSize: 9),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, size: 18, color: AppColors.textGrey),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600))),
          const Icon(Icons.file_download_outlined, size: 18, color: AppColors.accentOrange),
        ],
      ),
    );
  }
}
