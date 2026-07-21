import 'package:flutter/material.dart';

import '../../models/tour_guide.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';

/// Single guide's detail — about, specialties, reviews, and the booking
/// CTA that closes the add-on flow back to Trip Detail.
class GuideProfileScreen extends StatelessWidget {
  const GuideProfileScreen({super.key, required this.guide});

  final TourGuide guide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(guide.name, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                CircleAvatar(radius: 32, backgroundColor: AppColors.mintGreen.withValues(alpha: 0.5), child: Text(guide.name[0], style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w700, fontSize: 24))),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(guide.name, style: AppTextStyles.h3(color: AppColors.textDark)),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.accentOrange),
                          Text('${guide.rating} (${guide.tripsCount}${ChooseGuideStrings.tripsSuffix})', style: AppTextStyles.bodySm()),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Wrap(spacing: 6, children: [for (final lang in guide.languages) _Tag(lang)]),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(GuideProfileStrings.about, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 8),
            Text(guide.about, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            Text(GuideProfileStrings.specialties, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [for (final s in guide.specialties) _SpecialtyChip(s)]),
            const SizedBox(height: 20),
            Text(GuideProfileStrings.reviews, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 8),
            const _ReviewTile(name: 'Rahul M.', body: 'Very knowledgeable and patient with our students. Highly recommend.'),
            const _ReviewTile(name: 'Saritha K.', body: 'Excellent guide for trekking. Our group felt very safe.'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(GuideProfileStrings.bookingConfirmed), backgroundColor: AppColors.primaryGreen),
                  );
                },
                child: Text(GuideProfileStrings.bookThisGuide, style: AppTextStyles.button()),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 8)),
    );
  }
}

class _SpecialtyChip extends StatelessWidget {
  const _SpecialtyChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18)),
      child: Text(label, style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontWeight: FontWeight.w600)),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.name, required this.body});

  final String name;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(width: 6),
              Row(children: List.generate(5, (i) => const Icon(Icons.star_rounded, size: 12, color: AppColors.accentOrange))),
            ],
          ),
          const SizedBox(height: 2),
          Text(body, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
