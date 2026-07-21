import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/vendor_option.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Shown when a confirmed vehicle's seat count falls short of the group —
/// offers three ways out: pick a bigger class, add a second vehicle, or go
/// back and trim the headcount.
class VehicleCapacityMismatchScreen extends StatelessWidget {
  const VehicleCapacityMismatchScreen({super.key, required this.option});

  final VendorOption option;

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final shortfall = draft.totalParticipants - (option.seatCapacity ?? 0);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(VehicleCapacityMismatchStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.error),
                  const SizedBox(width: 10),
                  Expanded(child: Text(VehicleCapacityMismatchStrings.heading, style: AppTextStyles.bodyLg(color: AppColors.error))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatColumn(label: VehicleCapacityMismatchStrings.selectedVehicle, value: '${option.seatCapacity} seats'),
                _StatColumn(label: VehicleCapacityMismatchStrings.yourParticipants, value: '${draft.totalParticipants} Total'),
                _StatColumn(label: VehicleCapacityMismatchStrings.shortfall, value: '$shortfall seats', valueColor: AppColors.error),
              ],
            ),
            const SizedBox(height: 28),
            Text(VehicleCapacityMismatchStrings.chooseResolution, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 12),
            _ResolutionCard(
              icon: Icons.directions_bus_filled_rounded,
              title: VehicleCapacityMismatchStrings.selectLargerTitle,
              badge: VehicleCapacityMismatchStrings.selectLargerRecommended,
              body: VehicleCapacityMismatchStrings.selectLargerBody,
              actionLabel: VehicleCapacityMismatchStrings.browseVehicles,
              highlighted: true,
              onTap: () => context.go(AppRouter.selectVehicleType),
            ),
            const SizedBox(height: 12),
            _ResolutionCard(
              icon: Icons.add_circle_outline_rounded,
              title: VehicleCapacityMismatchStrings.addSecondTitle,
              body: VehicleCapacityMismatchStrings.addSecondBody,
              actionLabel: VehicleCapacityMismatchStrings.browseSecondVehicle,
              onTap: () => context.go(AppRouter.selectVehicleType),
            ),
            const SizedBox(height: 12),
            _ResolutionCard(
              icon: Icons.groups_rounded,
              title: VehicleCapacityMismatchStrings.reduceTitle,
              body: VehicleCapacityMismatchStrings.reduceBody,
              actionLabel: VehicleCapacityMismatchStrings.editParticipants,
              onTap: () => context.go(AppRouter.tripParticipants),
            ),
          ],
        ),
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
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyLg(color: valueColor ?? AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _ResolutionCard extends StatelessWidget {
  const _ResolutionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onTap,
    this.badge,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onTap;
  final String? badge;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.accentOrange.withValues(alpha: 0.06) : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: highlighted ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: AppColors.accentOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600))),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(badge!, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 8)),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(body, style: AppTextStyles.bodySm()),
                const SizedBox(height: 8),
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                  onPressed: onTap,
                  child: Text('$actionLabel →', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
