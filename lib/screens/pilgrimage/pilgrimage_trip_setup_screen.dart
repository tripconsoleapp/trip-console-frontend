import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/pilgrimage_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Pilgrimage-scoped variant of the "scratch vs template" choice — separate
/// from the generic `AddNewListingScreen` chooser since it carries
/// pilgrimage-specific copy and destinations.
class PilgrimageTripSetupScreen extends StatelessWidget {
  const PilgrimageTripSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pilgrimage = context.read<PilgrimageProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PilgrimageTripSetupStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(PilgrimageTripSetupStrings.heading, style: AppTextStyles.h2(color: AppColors.textDark)),
            const SizedBox(height: 20),
            _SetupCard(
              icon: Icons.edit_road_rounded,
              title: PilgrimageTripSetupStrings.scratchTitle,
              badge: PilgrimageTripSetupStrings.scratchBadge,
              body: PilgrimageTripSetupStrings.scratchBody,
              tags: const [PilgrimageTripSetupStrings.scratchTag1, PilgrimageTripSetupStrings.scratchTag2],
              buttonLabel: PilgrimageTripSetupStrings.startFromScratch,
              onTap: () {
                pilgrimage.setSetupChoice(PilgrimageProvider.startFromScratch);
                context.push(AppRouter.pilgrimageTripStructure);
              },
            ),
            const SizedBox(height: 16),
            Center(child: Text('OR', style: AppTextStyles.labelCaps())),
            const SizedBox(height: 16),
            _SetupCard(
              icon: Icons.grid_view_rounded,
              title: PilgrimageTripSetupStrings.templateTitle,
              badge: PilgrimageTripSetupStrings.templateBadge,
              body: PilgrimageTripSetupStrings.templateBody,
              tags: const [PilgrimageTripSetupStrings.templateTag1, PilgrimageTripSetupStrings.templateTag2],
              buttonLabel: PilgrimageTripSetupStrings.browseTemplates,
              onTap: () {
                pilgrimage.setSetupChoice(PilgrimageProvider.useTemplate);
                context.push(AppRouter.pilgrimageTemplates);
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(child: Text(PilgrimageTripSetupStrings.note, style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontSize: 12))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetupCard extends StatelessWidget {
  const _SetupCard({required this.icon, required this.title, required this.badge, required this.body, required this.tags, required this.buttonLabel, required this.onTap});

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
