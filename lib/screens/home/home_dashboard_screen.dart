import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/activity_item.dart';
import '../../models/trip_recommendation.dart';
import '../../screens/templates/templates_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/activity_item_tile.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/quick_action_chip.dart';
import '../../widgets/trip_recommendation_card.dart';

/// Organizer's home dashboard — greeting, quick service-only actions, the
/// two primary trip-planning entry points, and recommended packages.
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  // TODO(api): replace with the organizer's real name from the auth/profile service.
  static const _organizerName = "Rahul Menon";

  static const _recommendations = [
    TripRecommendation(
      imageAsset: 'assets/images/onboarding_mountain.png',
      badgeLabel: '3D/2N · SCHOOL TRIP',
      title: 'Western Ghats Explorer',
      priceRange: '₹2,500–3,500',
      priceUnit: '/student',
      templateId: 'western-ghats-explorer',
    ),
    TripRecommendation(
      imageAsset: 'assets/images/onboarding_adventure.png',
      badgeLabel: '10D · SCHOOL TRIP',
      title: 'Munnar Hill Station',
      priceRange: '₹800–1,200',
      priceUnit: '/student',
      templateId: 'munnar-hill-station',
    ),
  ];

  static const _recentActivity = [
    ActivityItem(
      tripName: 'Heritage South Trail',
      description: 'Submitted for verification',
      icon: Icons.upload_file_rounded,
      iconColor: Color(0xFF0095FF),
      timeLabel: '1d ago',
    ),
    ActivityItem(
      tripName: 'Industrial Expo Visit',
      description: 'Payment pending',
      icon: Icons.payments_outlined,
      iconColor: AppColors.accentOrange,
      timeLabel: '2d ago',
    ),
    ActivityItem(
      tripName: 'Western Ghats Expedition',
      description: 'Draft updated',
      icon: Icons.edit_note_rounded,
      iconColor: AppColors.textGrey,
      timeLabel: '2d ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.go(AppRouter.myTrips);
          if (index == 2) context.go(AppRouter.profile);
        },
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: AppColors.textDark),
                  Text(HomeDashboardStrings.appName,
                      style: AppTextStyles.h3(color: AppColors.textDark)),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications_none_rounded,
                          color: AppColors.textDark),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: AppColors.accentOrange,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            '${HomeDashboardStrings.greetingPrefix}$_organizerName',
                            style: AppTextStyles.h2(color: AppColors.textDark),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accentOrange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              HomeDashboardStrings.organizerBadge,
                              style: AppTextStyles.labelCaps(color: AppColors.backgroundWhite).copyWith(fontSize: 10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(HomeDashboardStrings.subtitle, style: AppTextStyles.bodyLg(color: AppColors.textGrey)),
                          const SizedBox(height: 20),
                          Text(HomeDashboardStrings.serviceOnlyLabel, style: AppTextStyles.labelCaps()),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              QuickActionChip(icon: Icons.hotel_rounded, label: HomeDashboardStrings.hotel, onTap: () => context.push(AppRouter.bookHotel)),
                              const SizedBox(width: 8),
                              QuickActionChip(icon: Icons.directions_car_rounded, label: HomeDashboardStrings.vehicle),
                              SizedBox(width: 8),
                              QuickActionChip(icon: Icons.restaurant_rounded, label: HomeDashboardStrings.restaurant),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _PlanFullTripCard(onTap: () => context.push(AppRouter.tripBasics)),
                          const SizedBox(height: 12),
                          _PlanPilgrimageCard(onTap: () {}),
                          const SizedBox(height: 12),
                          Center(
                            child: TextButton.icon(
                              onPressed: () => context.push(AppRouter.templates),
                              icon: const Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.accentOrange),
                              label: Text(
                                HomeDashboardStrings.browseTemplates,
                                style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              HomeDashboardStrings.serviceOnlyNotice,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySm(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                HomeDashboardStrings.recommendedForYou,
                                style: AppTextStyles.h3(color: AppColors.textDark),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  '${HomeDashboardStrings.viewAll} →',
                                  style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 190,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _recommendations.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) => TripRecommendationCard(
                            recommendation: _recommendations[index],
                            onTap: () {
                              final package = TemplatesScreen.mockTemplates
                                  .firstWhere((t) => t.id == _recommendations[index].templateId);
                              context.push(AppRouter.packageDetail, extra: (package: package, isTemplate: true));
                            }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(HomeDashboardStrings.recentActivity, style: AppTextStyles.h3(color: AppColors.textDark)),
                          const SizedBox(height: 12),
                          for (final activity in _recentActivity) ActivityItemTile(item: activity),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanFullTripCard extends StatelessWidget {
  const _PlanFullTripCard({required this.onTap});

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
          color: AppColors.accentOrange,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.map_rounded,
                    color: AppColors.backgroundWhite, size: 28),
                Icon(Icons.arrow_forward_rounded,
                    color: AppColors.backgroundWhite),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              HomeDashboardStrings.planFullTripTitle,
              style: AppTextStyles.h3(color: AppColors.backgroundWhite),
            ),
            const SizedBox(height: 4),
            Text(
              HomeDashboardStrings.planFullTripBody,
              style: AppTextStyles.bodySm(
                  color: AppColors.backgroundWhite.withValues(alpha: 0.9)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanPilgrimageCard extends StatelessWidget {
  const _PlanPilgrimageCard({required this.onTap});

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
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color.fromARGB(255, 0, 149, 255)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.groups_rounded,
                color: AppColors.accentOrange, size: 28),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  HomeDashboardStrings.planPilgrimageTitle,
                  style: AppTextStyles.h3(color: AppColors.accentOrange),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded,
                    color: AppColors.accentOrange, size: 18),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              HomeDashboardStrings.planPilgrimageBody,
              style: AppTextStyles.bodySm(),
            ),
          ],
        ),
      ),
    );
  }
}
