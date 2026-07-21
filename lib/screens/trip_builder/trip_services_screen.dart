import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/vendor_option.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/wizard_header.dart';
import '../../widgets/wizard_step_indicator.dart';
import '../../widgets/wizard_bottom_bar.dart';
import '../../widgets/info_note.dart';
import '../../widgets/service_toggle_card.dart';

/// Step 4 of the trip-creation wizard — the one PROGRESS.md flagged as
/// blocked. Toggle on whichever services this trip needs; each one opens a
/// vendor listing (Vehicle gets its own private-operator/KSRTC sub-flow,
/// the rest share [VendorListingScreen] with mock catalogs). A live cost
/// breakdown totals whatever's actually been selected.
class TripServicesScreen extends StatelessWidget {
  const TripServicesScreen({super.key});

  static const _activityOptions = [
    VendorOption(name: 'Tea Estate Guided Tour', subtitle: 'Munnar · 2 hours', price: 4200, rating: 4.7, tripsCount: 110),
    VendorOption(name: 'Spice Plantation Walk', subtitle: 'Thekkady · 1.5 hours', price: 3100, rating: 4.5, tripsCount: 76),
    VendorOption(name: 'Periyar Wildlife Safari', subtitle: 'Thekkady · 3 hours', price: 5600, rating: 4.8, tripsCount: 92),
  ];

  void _chooseVehicle(BuildContext context) => context.push(AppRouter.transportSelection);

  void _chooseHotel(BuildContext context) => context.push(AppRouter.selectHotel);

  void _chooseRestaurant(BuildContext context) => context.push(AppRouter.chooseRestaurant);

  void _chooseActivity(BuildContext context) {
    context.push(
      AppRouter.vendorListing,
      extra: (
        title: ServicesStrings.chooseActivities,
        options: _activityOptions,
        onSelect: (VendorOption option) {
          context.read<NewTripProvider>().addActivity(option);
          context.go(AppRouter.tripServices);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final anyEnabled = draft.vehicleEnabled || draft.hotelEnabled || draft.restaurantEnabled || draft.activitiesEnabled;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: const WizardHeader(),
      bottomNavigationBar: WizardBottomBar(
        stepNumber: 4,
        totalSteps: 5,
        stepTitle: 'Services',
        nextLabel: ServicesStrings.nextReview,
        onNext: () => context.push(AppRouter.itineraryGenerating),
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardStepIndicator(currentStep: 4, labels: WizardStrings.stepLabels),
            const SizedBox(height: 20),
            const InfoNote(text: ServicesStrings.infoNote),
            const SizedBox(height: 20),
            ServiceToggleCard(
              icon: Icons.directions_bus_filled_rounded,
              title: ServicesStrings.vehicle,
              subtitle: ServicesStrings.vehicleSubtitle,
              enabled: draft.vehicleEnabled,
              onToggle: draft.setVehicleEnabled,
              chooseLabel: ServicesStrings.chooseVehicle,
              onChoose: () => _chooseVehicle(context),
              selections: draft.vehicle == null ? const [] : [draft.vehicle!],
            ),
            ServiceToggleCard(
              icon: Icons.hotel_rounded,
              title: ServicesStrings.hotel,
              subtitle: ServicesStrings.hotelSubtitle,
              enabled: draft.hotelEnabled,
              onToggle: draft.setHotelEnabled,
              chooseLabel: ServicesStrings.chooseHotel,
              onChoose: () => _chooseHotel(context),
              selections: draft.hotel == null ? const [] : [draft.hotel!],
            ),
            ServiceToggleCard(
              icon: Icons.restaurant_rounded,
              title: ServicesStrings.restaurant,
              subtitle: ServicesStrings.restaurantSubtitle,
              enabled: draft.restaurantEnabled,
              onToggle: draft.setRestaurantEnabled,
              chooseLabel: ServicesStrings.chooseRestaurant,
              onChoose: () => _chooseRestaurant(context),
              selections: draft.restaurant == null ? const [] : [draft.restaurant!],
            ),
            ServiceToggleCard(
              icon: Icons.local_activity_rounded,
              title: ServicesStrings.activities,
              subtitle: ServicesStrings.activitiesSubtitle,
              enabled: draft.activitiesEnabled,
              onToggle: draft.setActivitiesEnabled,
              chooseLabel: ServicesStrings.chooseActivities,
              onChoose: () => _chooseActivity(context),
              selections: draft.activities,
              addAnotherLabel: draft.activities.isEmpty ? null : ServicesStrings.addAnotherActivity,
            ),
            if (anyEnabled) ...[
              const SizedBox(height: 12),
              Text(ServicesStrings.costBreakdown, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    if (draft.vehicleEnabled) _CostRow(label: ServicesStrings.vehicleTotal, amount: draft.vehicleTotal),
                    if (draft.hotelEnabled) _CostRow(label: ServicesStrings.hotelTotal, amount: draft.hotelTotal),
                    if (draft.restaurantEnabled) _CostRow(label: ServicesStrings.diningTotal, amount: draft.diningTotal),
                    if (draft.activitiesEnabled) _CostRow(label: ServicesStrings.activitiesTotal, amount: draft.activitiesTotal),
                    const Divider(color: Color(0xFFE2E2E2)),
                    _CostRow(label: ServicesStrings.subtotal, amount: draft.servicesSubtotal),
                    _CostRow(label: ServicesStrings.managementBuffer, amount: draft.managementBuffer),
                    const Divider(color: Color(0xFFE2E2E2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ServicesStrings.grandTotal, style: AppTextStyles.labelCaps()),
                            Text('₹${draft.servicesGrandTotal}', style: AppTextStyles.h2(color: AppColors.textDark)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(ServicesStrings.perStudent, style: AppTextStyles.labelCaps()),
                            Text('₹${draft.perParticipantCost}', style: AppTextStyles.h3(color: AppColors.accentOrange)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push(AppRouter.itineraryGenerating),
                  child: Text('${ServicesStrings.generateItinerary} →', style: AppTextStyles.button()),
                ),
              ),
            ],
          ],
        ),
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
