import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/pilgrimage_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Read-only preview of the selected template's auto-filled route, before
/// the organizer customises anything.
class SabarimalaTemplatePreviewScreen extends StatelessWidget {
  const SabarimalaTemplatePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final template = context.watch<PilgrimageProvider>().selectedTemplate;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(SabarimalaTemplatePreviewStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => context.push(AppRouter.pilgrimageTripStructure),
                    child: Text('${SabarimalaTemplatePreviewStrings.customiseAndContinue} →', style: AppTextStyles.button()),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(SabarimalaTemplatePreviewStrings.browseOtherTemplates, style: AppTextStyles.bodySm(color: AppColors.accentOrange)),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(template?.name ?? '—', style: AppTextStyles.h2(color: AppColors.textDark)),
            const SizedBox(height: 8),
            Text(SabarimalaTemplatePreviewStrings.prefillNote, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            _AutoFilledRow(icon: Icons.route_rounded, label: SabarimalaTemplatePreviewStrings.route, value: template?.route ?? '—'),
            _AutoFilledRow(icon: Icons.schedule_rounded, label: SabarimalaTemplatePreviewStrings.duration, value: template?.duration ?? '—'),
            _AutoFilledRow(icon: Icons.hotel_rounded, label: SabarimalaTemplatePreviewStrings.stay, value: template?.stayNote ?? '—'),
            _AutoFilledRow(icon: Icons.restaurant_rounded, label: SabarimalaTemplatePreviewStrings.meals, value: template?.mealsNote ?? '—'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(SabarimalaTemplatePreviewStrings.basePrice, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
                  Text('From ₹${template?.priceFromPerHead ?? 0}/head', style: AppTextStyles.h3(color: AppColors.accentOrange)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoFilledRow extends StatelessWidget {
  const _AutoFilledRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                Text(value, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(SabarimalaTemplatePreviewStrings.autoFilled, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 8)),
          ),
        ],
      ),
    );
  }
}
