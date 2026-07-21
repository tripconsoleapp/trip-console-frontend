import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/vendor_option.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// First step of the vehicle-selection sub-flow — choose between the
/// private-operator marketplace (goes on to pick a vehicle type and browse
/// operators) or KSRTC (state transport, resolves directly to a standard
/// fleet option since it isn't a browsable marketplace).
class TransportSelectionScreen extends StatelessWidget {
  const TransportSelectionScreen({super.key});

  static const _ksrtcOption = VendorOption(
    name: 'KSRTC AC Sleeper Bus',
    subtitle: '52 seats · State transport corporation',
    price: 45000,
    badge: 'OFFICIAL FLEET',
    seatCapacity: 52,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(TransportSelectionStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TransportOptionCard(
                icon: Icons.local_shipping_rounded,
                title: TransportSelectionStrings.privateOperators,
                subtitle: TransportSelectionStrings.privateOperatorsSubtitle,
                badge: TransportSelectionStrings.recommended,
                highlighted: true,
                onTap: () => context.push(AppRouter.selectVehicleType),
              ),
              const SizedBox(height: 12),
              _TransportOptionCard(
                icon: Icons.directions_bus_filled_rounded,
                title: TransportSelectionStrings.ksrtc,
                subtitle: TransportSelectionStrings.ksrtcSubtitle,
                badge: TransportSelectionStrings.mostTrusted,
                highlighted: false,
                onTap: () => context.push(AppRouter.vehicleDetail, extra: _ksrtcOption),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(TransportSelectionStrings.tapToContinue, style: AppTextStyles.bodySm()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransportOptionCard extends StatelessWidget {
  const _TransportOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.highlighted,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: highlighted ? AppColors.accentOrange : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: highlighted ? null : Border.all(color: const Color(0xFFE2E2E2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 28, color: highlighted ? AppColors.backgroundWhite : AppColors.accentOrange),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: highlighted ? AppColors.backgroundWhite.withValues(alpha: 0.2) : AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: AppTextStyles.labelCaps(color: highlighted ? AppColors.backgroundWhite : AppColors.primaryGreen).copyWith(fontSize: 9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.h3(color: highlighted ? AppColors.backgroundWhite : AppColors.textDark)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySm(color: highlighted ? AppColors.backgroundWhite.withValues(alpha: 0.9) : AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
