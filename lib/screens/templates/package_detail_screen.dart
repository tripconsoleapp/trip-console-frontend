import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/trip_package.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Full detail view for a reference package or template — photo header,
/// route, included services, sample itinerary and a cost breakdown.
/// [isTemplate] only changes the bottom CTA's label and destination.
class PackageDetailScreen extends StatelessWidget {
  const PackageDetailScreen({super.key, required this.package, required this.isTemplate});

  final TripPackage package;
  final bool isTemplate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  context.read<NewTripProvider>().setSourceTemplate(package.title);
                  context.push(AppRouter.tripSetupLoading);
                },
                child: Text(
                  isTemplate ? PackageDetailStrings.useThisTemplate : PackageDetailStrings.addToTrip,
                  style: AppTextStyles.button(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.backgroundWhite,
            pinned: true,
            expandedHeight: 220,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.backgroundWhite, size: 20),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(package.imageAsset, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(package.title, style: AppTextStyles.h2(color: AppColors.textDark))),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 18, color: AppColors.accentOrange),
                          const SizedBox(width: 2),
                          Text('${package.rating}', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(package.badgeLabel, style: AppTextStyles.bodySm()),
                  const SizedBox(height: 4),
                  Text(
                    '${package.priceRange} ${package.priceUnit}',
                    style: AppTextStyles.bodyLg(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Text(PackageDetailStrings.about, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 6),
                  Text(package.about, style: AppTextStyles.bodySm()),
                  const SizedBox(height: 20),
                  Text(PackageDetailStrings.tripRoute, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (var i = 0; i < package.route.length; i++) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(8)),
                          child: Text(package.route[i], style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                        ),
                        if (i != package.route.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textGrey),
                          ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(PackageDetailStrings.includedServices, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final service in package.includedServices)
                        Chip(
                          label: Text(service),
                          avatar: const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.primaryGreen),
                          labelStyle: AppTextStyles.bodySm(color: AppColors.textDark),
                          backgroundColor: const Color(0xFFF5F3F3),
                          side: BorderSide.none,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(PackageDetailStrings.sampleItinerary, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  for (final day in package.itinerary)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: const Border(left: BorderSide(color: AppColors.accentOrange, width: 3)),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Day ${day.dayNumber} · ${day.title}', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(day.description, style: AppTextStyles.bodySm()),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(PackageDetailStrings.whatsIncluded, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  for (final item in package.whatsIncluded)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.check_rounded, size: 16, color: AppColors.primaryGreen),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item, style: AppTextStyles.bodySm(color: AppColors.textDark))),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(PackageDetailStrings.pricingBreakdown, style: AppTextStyles.h3(color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        for (final line in package.pricingBreakdown)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(line.label, style: AppTextStyles.bodySm(color: AppColors.textDark)),
                                Text(line.amount, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        const Divider(color: Color(0xFFE2E2E2)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(PackageDetailStrings.total, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                            Text(package.totalPrice, style: AppTextStyles.bodyLg(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
