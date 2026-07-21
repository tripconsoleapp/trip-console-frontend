import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/pilgrimage_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Determines whether the organizer builds the trip's transport/stay/meal
/// plan themselves, or takes a pre-bundled fixed-rate KSRTC package.
class PilgrimageTripStructureScreen extends StatelessWidget {
  const PilgrimageTripStructureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pilgrimage = context.read<PilgrimageProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PilgrimageTripStructureStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(PilgrimageTripStructureStrings.heading, style: AppTextStyles.h2(color: AppColors.textDark)),
            const SizedBox(height: 6),
            Text(PilgrimageTripStructureStrings.body, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            _StructureCard(
              icon: Icons.tune_rounded,
              title: PilgrimageTripStructureStrings.customiseTitle,
              badge: PilgrimageTripStructureStrings.customiseBadge,
              body: PilgrimageTripStructureStrings.customiseBody,
              tags: const [PilgrimageTripStructureStrings.customiseTag1, PilgrimageTripStructureStrings.customiseTag2],
              buttonLabel: PilgrimageTripStructureStrings.customiseTrip,
              onTap: () {
                pilgrimage.setStructureType(PilgrimageProvider.customise);
                context.push(AppRouter.pilgrimageSeatCount);
              },
            ),
            const SizedBox(height: 16),
            Center(child: Text('or', style: AppTextStyles.bodySm())),
            const SizedBox(height: 16),
            _StructureCard(
              icon: Icons.inventory_2_rounded,
              title: PilgrimageTripStructureStrings.fixedPackageTitle,
              badge: PilgrimageTripStructureStrings.fixedPackageBadge,
              body: PilgrimageTripStructureStrings.fixedPackageBody,
              tags: const [PilgrimageTripStructureStrings.fixedPackageTag1, PilgrimageTripStructureStrings.fixedPackageTag2],
              buttonLabel: PilgrimageTripStructureStrings.chooseFixedPackage,
              onTap: () {
                pilgrimage.setStructureType(PilgrimageProvider.fixedPackage);
                context.push(AppRouter.pilgrimageSeatCount);
              },
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(height: 110, width: double.infinity, color: AppColors.mintGreen.withValues(alpha: 0.3), child: const Icon(Icons.map_rounded, size: 32, color: AppColors.primaryGreen)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(child: Text(PilgrimageTripStructureStrings.fixedPackageNote, style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontSize: 12))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StructureCard extends StatelessWidget {
  const _StructureCard({required this.icon, required this.title, required this.badge, required this.body, required this.tags, required this.buttonLabel, required this.onTap});

  final IconData icon;
  final String title;
  final String badge;
  final String body;
  final List<String> tags;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E2E2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: AppColors.accentOrange, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(6)),
                child: Text(badge, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.h3(color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(body, style: AppTextStyles.bodySm()),
          const SizedBox(height: 10),
          Wrap(spacing: 8, children: [for (final t in tags) _Tag(t)]),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onTap,
              child: Text('$buttonLabel →', style: AppTextStyles.button()),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
    );
  }
}
