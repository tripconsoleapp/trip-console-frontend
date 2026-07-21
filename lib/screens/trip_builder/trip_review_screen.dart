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

/// Step 5 of the trip-creation wizard — the master review: route,
/// participants, services & logistics, a cost snapshot, and an itinerary
/// preview, before moving on to Declarations. Calls
/// [NewTripProvider.generateItinerary] itself (idempotent) so the preview
/// has data even if the organizer skipped straight here from Services.
class TripReviewScreen extends StatelessWidget {
  const TripReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    if (draft.dailyItinerary.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => draft.generateItinerary());
    }

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
                onPressed: () => context.push(AppRouter.declarations),
                child: Text('${ReviewStrings.continueToDeclarations} →', style: AppTextStyles.button()),
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
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.fact_check_rounded, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ReviewStrings.finalReviewBanner, style: AppTextStyles.bodySm(color: AppColors.primaryGreen))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              draft.tripName.isEmpty ? '(untitled trip)' : draft.tripName,
              style: AppTextStyles.h2(color: AppColors.textDark),
            ),
            const SizedBox(height: 4),
            Text(draft.tripType.label, style: AppTextStyles.bodySm()),
            const SizedBox(height: 24),
            _SectionHeader(icon: Icons.route_rounded, title: ReviewStrings.routeDetails),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _LabeledValue(label: ReviewStrings.departure, value: draft.startingLocationName),
                      const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.textGrey),
                      _LabeledValue(
                        label: ReviewStrings.arrival,
                        value: draft.stops.isEmpty ? draft.startingLocationName : draft.stops.last.name,
                        alignEnd: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      color: AppColors.mintGreen.withValues(alpha: 0.35),
                      child: const Icon(Icons.map_outlined, color: AppColors.primaryGreen),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SectionHeader(icon: Icons.groups_rounded, title: ReviewStrings.participants),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${draft.totalParticipants} ${ReviewStrings.travelersTotal}', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  Text(draft.tripType.label, style: AppTextStyles.bodySm()),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SectionHeader(icon: Icons.miscellaneous_services_rounded, title: ReviewStrings.servicesAndLogistics),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (draft.vehicleEnabled && draft.vehicle != null) _ServiceChip(icon: Icons.directions_bus_filled_rounded, label: draft.vehicle!.name),
                if (draft.hotelEnabled && draft.hotel != null) _ServiceChip(icon: Icons.hotel_rounded, label: draft.hotel!.name),
                if (draft.restaurantEnabled && draft.restaurant != null) _ServiceChip(icon: Icons.restaurant_rounded, label: draft.restaurant!.name),
                if (draft.activitiesEnabled && draft.activities.isNotEmpty) _ServiceChip(icon: Icons.local_activity_rounded, label: '${draft.activities.length} Activities'),
                if (!draft.vehicleEnabled && !draft.hotelEnabled && !draft.restaurantEnabled && !draft.activitiesEnabled)
                  Text('No services added', style: AppTextStyles.bodySm()),
              ],
            ),
            const SizedBox(height: 20),
            _SectionHeader(icon: Icons.receipt_long_rounded, title: ReviewStrings.costSnapshot),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _CostRow(label: ReviewStrings.baseExpeditionCost, amount: draft.servicesSubtotal),
                  _CostRow(label: ReviewStrings.premiumAddOns, amount: draft.managementBuffer),
                  const Divider(color: Color(0xFFE2E2E2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ReviewStrings.totalEstimate, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                      Text('₹${draft.servicesGrandTotal}', style: AppTextStyles.h3(color: AppColors.accentOrange)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SectionHeader(icon: Icons.event_note_rounded, title: ReviewStrings.itineraryPreview),
            const SizedBox(height: 10),
            for (var i = 0; i < draft.dailyItinerary.length; i++)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E2E2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Text('${i + 1}', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Day ${i + 1}', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                          Text(
                            draft.dailyItinerary[i].map((b) => b.title).join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySm().copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textDark),
        const SizedBox(width: 6),
        Text(title, style: AppTextStyles.h3(color: AppColors.textDark).copyWith(fontSize: 16)),
      ],
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value, this.alignEnd = false});

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
        Text(value, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.accentOrange),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
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
