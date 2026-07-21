import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/pilgrimage_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Determines how much customisation the group needs — a large group can
/// fully customise buses/packages, a small group takes a fixed rate for a
/// faster setup.
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
              icon: Icons.groups_2_rounded,
              title: PilgrimageTripStructureStrings.largeGroupTitle,
              subtitle: PilgrimageTripStructureStrings.largeGroupSubtitle,
              badge: PilgrimageTripStructureStrings.largeGroupBadge,
              body: PilgrimageTripStructureStrings.largeGroupBody,
              buttonLabel: PilgrimageTripStructureStrings.customiseTrip,
              onTap: () {
                pilgrimage.setStructureChoice(PilgrimageProvider.largeGroup);
                context.push(AppRouter.pilgrimageSeatCount);
              },
            ),
            const SizedBox(height: 16),
            _StructureCard(
              icon: Icons.group_rounded,
              title: PilgrimageTripStructureStrings.smallGroupTitle,
              subtitle: PilgrimageTripStructureStrings.smallGroupSubtitle,
              badge: PilgrimageTripStructureStrings.smallGroupBadge,
              body: PilgrimageTripStructureStrings.smallGroupBody,
              buttonLabel: PilgrimageTripStructureStrings.useFixedRate,
              onTap: () {
                pilgrimage.setStructureChoice(PilgrimageProvider.smallGroup);
                context.push(AppRouter.pilgrimageSeatCount);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StructureCard extends StatelessWidget {
  const _StructureCard({required this.icon, required this.title, required this.subtitle, required this.badge, required this.body, required this.buttonLabel, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final String body;
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
              Icon(icon, color: AppColors.accentOrange, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h3(color: AppColors.textDark)),
                    Text(subtitle, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(6)),
                child: Text(badge, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(body, style: AppTextStyles.bodySm()),
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
