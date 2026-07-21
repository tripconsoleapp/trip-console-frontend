import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/pilgrimage_template.dart';
import '../../providers/pilgrimage_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Browsable pilgrimage-route templates — only Sabarimala Standard Darshan
/// is a real, KSRTC-verified template today; the others are shown as
/// "Coming Soon" placeholders, matching the Figma source exactly rather
/// than inventing content for routes that weren't designed yet.
class PilgrimageTemplatesScreen extends StatefulWidget {
  const PilgrimageTemplatesScreen({super.key});

  static const _templates = [
    PilgrimageTemplate(
      name: 'Sabarimala — Standard Darshan',
      destination: 'Sabarimala',
      subtitle: 'Pamba pickup · Stay + Meals included',
      duration: '2D/1N',
      pilgrimRange: '10-40 pilgrims',
      priceFromPerHead: 1450,
      verified: true,
      route: 'Kochi → Erumely → Pamba',
      stayNote: 'Included — Lodge near Pamba',
      mealsNote: 'Included — Breakfast + Dinner',
    ),
    PilgrimageTemplate(
      name: 'Guruvayur — Temple Darshan Trip',
      destination: 'Guruvayur',
      subtitle: 'Flexible pickup · Meals optional',
      duration: '1D',
      pilgrimRange: '5-50 pilgrims',
      priceFromPerHead: 650,
      comingSoon: true,
    ),
    PilgrimageTemplate(
      name: 'Velankanni Trip',
      destination: 'Velankanni',
      subtitle: 'Combined pilgrimage route · Stay optional',
      duration: '1D',
      pilgrimRange: '10-30 pilgrims',
      priceFromPerHead: 800,
      comingSoon: true,
    ),
  ];

  @override
  State<PilgrimageTemplatesScreen> createState() => _PilgrimageTemplatesScreenState();
}

class _PilgrimageTemplatesScreenState extends State<PilgrimageTemplatesScreen> {
  String _filter = PilgrimageTemplatesStrings.filterAll;

  static const _filters = [
    PilgrimageTemplatesStrings.filterAll,
    PilgrimageTemplatesStrings.filterSabarimala,
    PilgrimageTemplatesStrings.filterGuruvayur,
    PilgrimageTemplatesStrings.filterVelankanni,
  ];

  @override
  Widget build(BuildContext context) {
    final templates = _filter == PilgrimageTemplatesStrings.filterAll
        ? PilgrimageTemplatesScreen._templates
        : PilgrimageTemplatesScreen._templates.where((t) => t.destination == _filter).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PilgrimageTemplatesStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  for (final f in _filters) ...[
                    _FilterChip(label: f, selected: _filter == f, onTap: () => setState(() => _filter = f)),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  for (final t in templates) _TemplateCard(template: t),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<PilgrimageProvider>().setSetupChoice(PilgrimageProvider.startFromScratch);
                        context.push(AppRouter.pilgrimageTripStructure);
                      },
                      child: Text(PilgrimageTemplatesStrings.browseOtherRoutes, style: AppTextStyles.bodySm(color: AppColors.accentOrange)),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(color: selected ? AppColors.accentOrange : const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(18)),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});

  final PilgrimageTemplate template;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: template.comingSoon ? const Color(0xFFF5F3F3) : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (template.verified) ...[
            Text(PilgrimageTemplatesStrings.ksrtcVerified, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
            const SizedBox(height: 6),
          ],
          Text(template.name, style: AppTextStyles.h3(color: template.comingSoon ? AppColors.textGrey : AppColors.textDark)),
          const SizedBox(height: 2),
          Text(template.subtitle, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textGrey),
              const SizedBox(width: 4),
              Text(template.duration, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
              const SizedBox(width: 14),
              const Icon(Icons.groups_rounded, size: 14, color: AppColors.textGrey),
              const SizedBox(width: 4),
              Text(template.pilgrimRange, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
              const SizedBox(width: 14),
              const Icon(Icons.payments_rounded, size: 14, color: AppColors.textGrey),
              const SizedBox(width: 4),
              Text('${PilgrimageTemplatesStrings.fromPrefix}${template.priceFromPerHead}${PilgrimageTemplatesStrings.perHead}', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: template.comingSoon
                  ? null
                  : () {
                      context.read<PilgrimageProvider>().selectTemplate(template);
                      context.push(AppRouter.sabarimalaTemplatePreview);
                    },
              child: Text(
                template.comingSoon ? '${PilgrimageTemplatesStrings.comingSoon} →' : '${PilgrimageTemplatesStrings.useTemplate} →',
                style: AppTextStyles.button(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
