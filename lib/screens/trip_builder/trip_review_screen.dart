import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/trip_type.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/wizard_header.dart';
import '../../widgets/wizard_step_indicator.dart';

/// Step 5 of the trip-creation wizard. No Figma source has been provided
/// for this step's full design yet (see PROGRESS.md), so rather than
/// fabricate one, this shows a real summary built from the draft so the
/// wizard doesn't dead-end — swap for the real screen once a screenshot
/// lands.
class TripReviewScreen extends StatelessWidget {
  const TripReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: const WizardHeader(),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.go(AppRouter.myTrips),
                child: Text(ReviewStrings.submitForVerification, style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardStepIndicator(currentStep: 5, labels: WizardStrings.stepLabels),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accentOrange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ReviewStrings.pendingNotice, style: AppTextStyles.bodySm())),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(ReviewStrings.tripSummary, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 12),
            Text(
              draft.tripName.isEmpty ? '(untitled trip)' : draft.tripName,
              style: AppTextStyles.h2(color: AppColors.textDark),
            ),
            Text(draft.tripType.label, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            _SummarySection(
              title: ReviewStrings.destinations,
              rows: [
                'Starting from ${draft.startingLocationName}',
                for (final stop in draft.stops) '${stop.name} · ${stop.nights} night${stop.nights == 1 ? '' : 's'}',
              ],
            ),
            const SizedBox(height: 16),
            _SummarySection(
              title: ReviewStrings.participants,
              rows: ['${draft.totalParticipants} total participants'],
            ),
            const SizedBox(height: 16),
            _SummarySection(
              title: ReviewStrings.services,
              rows: [
                if (draft.vehicleEnabled && draft.vehicle != null) 'Vehicle: ${draft.vehicle!.name}',
                if (draft.hotelEnabled && draft.hotel != null) 'Hotel: ${draft.hotel!.name}',
                if (draft.restaurantEnabled && draft.restaurant != null) 'Restaurant: ${draft.restaurant!.name}',
                if (draft.activitiesEnabled) for (final activity in draft.activities) 'Activity: ${activity.name}',
                if (!draft.vehicleEnabled && !draft.hotelEnabled && !draft.restaurantEnabled && !draft.activitiesEnabled) 'No services added',
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ReviewStrings.estimatedCost, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
                  Text('₹${draft.servicesGrandTotal}', style: AppTextStyles.h3(color: AppColors.accentOrange)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.title, required this.rows});

  final String title;
  final List<String> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelCaps()),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E2E2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final row in rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(row, style: AppTextStyles.bodySm(color: AppColors.textDark)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
