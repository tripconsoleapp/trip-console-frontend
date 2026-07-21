import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/tour_guide.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Local guide marketplace, offered as an optional add-on from Trip
/// Detail's Transport & Logistics section.
class ChooseGuideScreen extends StatelessWidget {
  const ChooseGuideScreen({super.key});

  static const _guides = [
    TourGuide(
      name: 'Anandu Krishnan',
      rating: 4.9,
      tripsCount: 126,
      languages: ['English', 'Malayalam', 'Hindi'],
      yearsExperience: 6,
      specialty: 'Munnar specialist',
      pricePerDay: 1800,
      about: '6 years of experience guiding school and family groups across Munnar and the Western Ghats. Specializes in tea estate history, wildlife spotting, and safe trekking routes for large groups.',
      specialties: ['Tea Estates', 'Wildlife', 'School Groups', 'Trekking'],
      topRated: true,
    ),
    TourGuide(
      name: 'Meera Nair',
      rating: 4.7,
      tripsCount: 84,
      languages: ['English', 'Malayalam', 'Tamil'],
      yearsExperience: 4,
      specialty: 'History & Culture',
      pricePerDay: 1500,
      about: 'A history graduate with 4 years of experience narrating the cultural heritage of Kerala\'s hill stations to student groups.',
      specialties: ['Heritage', 'Museums', 'School Groups'],
    ),
    TourGuide(
      name: 'Rajesh Varma',
      rating: 4.8,
      tripsCount: 210,
      languages: ['English', 'Malayalam'],
      yearsExperience: 12,
      specialty: 'Wildlife Expert',
      pricePerDay: 2200,
      about: '12 years leading wildlife safaris and nature walks across Kerala\'s national parks and sanctuaries.',
      specialties: ['Wildlife', 'National Parks', 'Photography'],
    ),
    TourGuide(
      name: 'Sita Ram',
      rating: 4.5,
      tripsCount: 45,
      languages: ['English', 'Hindi'],
      yearsExperience: 2,
      specialty: 'Trekking leader',
      pricePerDay: 1200,
      about: 'A certified trekking leader specializing in beginner-friendly hill routes for school and college groups.',
      specialties: ['Trekking', 'School Groups'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(ChooseGuideStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(child: _FilterDropdown(label: ChooseGuideStrings.language)),
                const SizedBox(width: 8),
                Expanded(child: _FilterDropdown(label: ChooseGuideStrings.price)),
                const SizedBox(width: 8),
                Expanded(child: _FilterDropdown(label: ChooseGuideStrings.rating)),
              ],
            ),
            const SizedBox(height: 16),
            for (final guide in _guides)
              _GuideCard(
                guide: guide,
                onTap: () => context.push(AppRouter.guideProfile, extra: guide),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontSize: 12)),
          const Icon(Icons.expand_more_rounded, size: 16, color: AppColors.textGrey),
        ],
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.guide, required this.onTap});

  final TourGuide guide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E2E2))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 24, backgroundColor: AppColors.mintGreen.withValues(alpha: 0.5), child: Text(guide.name[0], style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w700, fontSize: 18))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(guide.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700))),
                      if (guide.topRated)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                          child: Text(ChooseGuideStrings.topRated, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 8)),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.accentOrange),
                      Text('${guide.rating} (${guide.tripsCount}${ChooseGuideStrings.tripsSuffix})', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(spacing: 6, children: [for (final lang in guide.languages) _LangTag(lang)]),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ChooseGuideStrings.experience, style: AppTextStyles.labelCaps().copyWith(fontSize: 8)),
                          Text('${guide.yearsExperience}${ChooseGuideStrings.yearsSuffix} · ${guide.specialty}', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(ChooseGuideStrings.perDay, style: AppTextStyles.labelCaps().copyWith(fontSize: 8)),
                          Text('₹${guide.pricePerDay}', style: AppTextStyles.bodyLg(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
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

class _LangTag extends StatelessWidget {
  const _LangTag(this.label);

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
