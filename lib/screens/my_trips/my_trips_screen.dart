import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/trip_status.dart';
import '../../models/trip_summary.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/trip_summary_card.dart';

/// My Trips — organizer's full trip list with status filters, or the
/// empty state when no trips have been created yet.
class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  TripStatus? _filter;

  // TODO(api): replace with the organizer's real trips from the backend.
  static const _trips = [
    TripSummary(
      id: '1',
      name: 'Western Ghats Expedition',
      subtitle: '3 Destinations · 5D/4N · School Trip',
      status: TripStatus.draft,
      updatedLabel: 'Edited 2 days ago',
      progressPercent: 0.6,
    ),
    TripSummary(
      id: '2',
      name: 'Heritage South Trail',
      subtitle: '4 Destinations · 6D/5N · College Trip',
      status: TripStatus.submitted,
      updatedLabel: 'Submitted 1 day ago',
      totalCost: 89400,
    ),
    TripSummary(
      id: '3',
      name: 'Industrial Expo Visit',
      subtitle: '1 Destination · 2D/1N · Group Trip',
      status: TripStatus.verified,
      updatedLabel: 'Verified today',
      totalCost: 42000,
    ),
    TripSummary(
      id: '5',
      name: 'Western Ghats School Expedition',
      subtitle: '3 Destinations · 12D · School Trip',
      status: TripStatus.paid,
      updatedLabel: 'Advance paid 2 days ago',
      totalCost: 119595,
      amountPaid: 23919,
    ),
    TripSummary(
      id: '4',
      name: 'Kerala Pilgrimage Tour',
      subtitle: '2 Destinations · 3D/2N · Pilgrimage',
      status: TripStatus.completed,
      updatedLabel: 'Completed 3 weeks ago',
      receiptAvailable: true,
      totalCost: 54200,
      amountPaid: 54200,
    ),
  ];

  List<TripSummary> get _filteredTrips =>
      _filter == null ? _trips : _trips.where((t) => t.status == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final trips = _filteredTrips;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go(AppRouter.home);
          if (index == 2) context.go(AppRouter.profile);
        },
      ),
      floatingActionButton: _trips.isEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.accentOrange,
              onPressed: () => context.push(AppRouter.addNewListing),
              child: const Icon(Icons.add_rounded, color: AppColors.backgroundWhite),
            ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(MyTripsStrings.title, style: AppTextStyles.h2(color: AppColors.textDark)),
                  const Icon(Icons.search_rounded, color: AppColors.textDark),
                ],
              ),
            ),
            if (_trips.isNotEmpty) ...[
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    _FilterChip(label: MyTripsStrings.filterAll, selected: _filter == null, onTap: () => setState(() => _filter = null)),
                    for (final status in TripStatus.values) ...[
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: status.label,
                        selected: _filter == status,
                        onTap: () => setState(() => _filter = status),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('${trips.length} ${MyTripsStrings.tripsFoundSuffix}', style: AppTextStyles.labelCaps()),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Expanded(
              child: _trips.isEmpty
                  ? const _EmptyTripsView()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: trips.length,
                      itemBuilder: (context, index) => TripSummaryCard(
                        trip: trips[index],
                        onTap: () {
                          if (trips[index].status != TripStatus.draft) context.push(AppRouter.tripDetail, extra: trips[index]);
                        },
                        onAction: () {
                          final trip = trips[index];
                          switch (trip.status) {
                            case TripStatus.draft:
                              context.push(AppRouter.tripBasics);
                            case TripStatus.submitted:
                              context.push(AppRouter.tripDetail, extra: trip);
                            case TripStatus.verified:
                              context.push(AppRouter.paymentPlan, extra: trip);
                            case TripStatus.paid:
                              context.push(AppRouter.tripDetail, extra: trip);
                            case TripStatus.completed:
                              context.push(AppRouter.paymentReceipt, extra: trip);
                          }
                        },
                      ),
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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange : const Color(0xFFF5F3F3),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.textDark)
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _EmptyTripsView extends StatelessWidget {
  const _EmptyTripsView();

  static const _features = [
    MyTripsStrings.emptyFeature1,
    MyTripsStrings.emptyFeature2,
    MyTripsStrings.emptyFeature3,
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(color: AppColors.mintGreen.withValues(alpha: 0.3), shape: BoxShape.circle),
              child: const Icon(Icons.map_outlined, size: 40, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 20),
            Text(MyTripsStrings.emptyTitle, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 8),
            Text(MyTripsStrings.emptyBody, textAlign: TextAlign.center, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            for (final feature in _features)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    Expanded(child: Text(feature, style: AppTextStyles.bodySm(color: AppColors.textDark))),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.push(AppRouter.addNewListing),
                child: Text(MyTripsStrings.createFirstTrip, style: AppTextStyles.button()),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.push(AppRouter.templates),
              child: Text(
                MyTripsStrings.browseTemplates,
                style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
