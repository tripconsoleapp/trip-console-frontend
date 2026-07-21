import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/pilgrimage_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Group-size category step — determines how much KSRTC customisation is
/// available downstream. Feeds into either the KSRTC Bus Search (KSRTC
/// Collaboration mode) or the generic Select Vehicle Type screen
/// (Self-Managed mode), both of which already exist.
class PilgrimageSeatCountScreen extends StatelessWidget {
  const PilgrimageSeatCountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pilgrimage = context.read<PilgrimageProvider>();

    void proceed(String category) {
      pilgrimage.setGroupSizeCategory(category);
      context.push(pilgrimage.isKsrtcCollaboration ? AppRouter.pilgrimageBusSearch : AppRouter.selectVehicleType);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PilgrimageSeatCountStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(PilgrimageSeatCountStrings.heading, style: AppTextStyles.h2(color: AppColors.textDark)),
            const SizedBox(height: 6),
            Text(PilgrimageSeatCountStrings.body, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            _GroupCard(
              icon: Icons.groups_2_rounded,
              title: PilgrimageSeatCountStrings.largeGroupTitle,
              subtitle: PilgrimageSeatCountStrings.largeGroupSubtitle,
              badge: PilgrimageSeatCountStrings.largeGroupBadge,
              body: PilgrimageSeatCountStrings.largeGroupBody,
              tags: const [PilgrimageSeatCountStrings.largeGroupTag1, PilgrimageSeatCountStrings.largeGroupTag2],
              buttonLabel: PilgrimageSeatCountStrings.continueLargeGroup,
              onTap: () => proceed(PilgrimageProvider.largeGroup),
            ),
            const SizedBox(height: 16),
            Center(child: Text('or', style: AppTextStyles.bodySm())),
            const SizedBox(height: 16),
            _GroupCard(
              icon: Icons.group_rounded,
              title: PilgrimageSeatCountStrings.smallGroupTitle,
              subtitle: PilgrimageSeatCountStrings.smallGroupSubtitle,
              badge: PilgrimageSeatCountStrings.smallGroupBadge,
              body: PilgrimageSeatCountStrings.smallGroupBody,
              tags: const [PilgrimageSeatCountStrings.smallGroupTag1, PilgrimageSeatCountStrings.smallGroupTag2],
              buttonLabel: PilgrimageSeatCountStrings.continueSmallGroup,
              onTap: () => proceed(PilgrimageProvider.smallGroup),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.icon, required this.title, required this.subtitle, required this.badge, required this.body, required this.tags, required this.buttonLabel, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
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
