import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/wizard_header.dart';
import '../../widgets/wizard_step_indicator.dart';
import '../../widgets/wizard_bottom_bar.dart';
import '../../widgets/itinerary_stop_card.dart';
import '../../widgets/stat_tile.dart';

/// Step 2 of the trip-creation wizard — route map, summary stats, and the
/// ordered list of destination stops.
class TripDestinationsScreen extends StatelessWidget {
  const TripDestinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: const WizardHeader(),
      bottomNavigationBar: WizardBottomBar(
        stepNumber: 2,
        totalSteps: 5,
        stepTitle: 'Destinations',
        nextLabel: DestinationsStrings.nextServices,
        onNext: () => context.push(AppRouter.tripServices),
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardStepIndicator(currentStep: 2, labels: WizardStrings.stepLabels),
            const SizedBox(height: 20),
            // TODO(maps): swap for an interactive GoogleMap once API keys are configured.
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 140,
                width: double.infinity,
                color: AppColors.mintGreen.withValues(alpha: 0.3),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.map_outlined, size: 40, color: AppColors.primaryGreen),
                    Positioned(
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppColors.accentOrange),
                            const SizedBox(width: 4),
                            Text(draft.stops.isEmpty ? 'KOCHI' : 'KOCHI', style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatTile(label: DestinationsStrings.totalStops, value: '${draft.stops.length}'),
                      StatTile(label: DestinationsStrings.totalNights, value: '${draft.totalNights}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatTile(label: DestinationsStrings.estDistance, value: '~420 km'),
                      StatTile(label: DestinationsStrings.driveTime, value: '~9h 45m'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DestinationsStrings.itineraryStops, style: AppTextStyles.labelCaps()),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.reorder_rounded, size: 16, color: AppColors.textGrey),
                  label: Text(DestinationsStrings.reorder, style: AppTextStyles.bodySm()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < draft.stops.length; i++)
              ItineraryStopCard(index: i + 1, stop: draft.stops[i]),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E2E2), style: BorderStyle.solid),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_circle_outline_rounded, size: 18, color: AppColors.textGrey),
                    const SizedBox(width: 8),
                    Text(DestinationsStrings.addDestination, style: AppTextStyles.bodyLg(color: AppColors.textGrey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
