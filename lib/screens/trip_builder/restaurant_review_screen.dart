import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/menu_item.dart';
import '../../models/restaurant_option.dart';
import '../../models/vendor_option.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Bundles what [RestaurantMenuScreen] built up so [RestaurantReviewScreen]
/// doesn't need its own copy of the day-by-day selection state.
class RestaurantReviewArgs {
  const RestaurantReviewArgs({
    required this.restaurant,
    required this.selectionsByDay,
    required this.totalDays,
    this.quantitiesByDay = const {},
  });

  final RestaurantOption restaurant;
  final Map<int, Set<MenuItem>> selectionsByDay;
  final int totalDays;

  /// Portion counts set on Plan Quantities — falls back to 1 portion per
  /// selected dish if a day/dish isn't present (e.g. reached without going
  /// through quantity planning).
  final Map<int, Map<MenuItem, int>> quantitiesByDay;

  int quantityFor(int day, MenuItem item) => quantitiesByDay[day]?[item] ?? 1;
}

/// Final summary across every day's menu selections — confirming here
/// collapses everything into one [VendorOption] on [NewTripProvider].
class RestaurantReviewScreen extends StatelessWidget {
  const RestaurantReviewScreen({super.key, required this.args});

  final RestaurantReviewArgs args;

  @override
  Widget build(BuildContext context) {
    int totalItems = 0;
    int totalPortions = 0;
    int subtotal = 0;
    for (var day = 1; day <= args.totalDays; day++) {
      final items = args.selectionsByDay[day] ?? {};
      totalItems += items.length;
      for (final item in items) {
        final qty = args.quantityFor(day, item);
        totalPortions += qty;
        subtotal += qty * item.price;
      }
    }
    final serviceTax = (subtotal * 0.05).round();
    final grandTotal = subtotal + serviceTax;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(RestaurantReviewStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
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
                  context.read<NewTripProvider>().setRestaurant(
                        VendorOption(
                          name: args.restaurant.name,
                          subtitle: '${args.totalDays} days · $totalItems dishes · $totalPortions portions',
                          price: grandTotal,
                        ),
                      );
                  context.go(AppRouter.tripServices);
                },
                child: Text('${RestaurantReviewStrings.addToTrip} — ₹$grandTotal', style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(args.restaurant.name, style: AppTextStyles.h2(color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text(RestaurantReviewStrings.subtitle, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            for (var day = 1; day <= args.totalDays; day++)
              _DaySummaryCard(day: day, items: (args.selectionsByDay[day] ?? {}).toList(), args: args),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(PlanQuantitiesStrings.subtotal, style: AppTextStyles.bodySm(color: AppColors.textDark)),
                      Text('₹$subtotal', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(PlanQuantitiesStrings.serviceTax, style: AppTextStyles.bodySm(color: AppColors.textDark)),
                      Text('₹$serviceTax', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Divider(color: Color(0xFFE2E2E2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(RestaurantReviewStrings.grandTotal, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                      Text('₹$grandTotal', style: AppTextStyles.h3(color: AppColors.accentOrange)),
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

class _DaySummaryCard extends StatelessWidget {
  const _DaySummaryCard({required this.day, required this.items, required this.args});

  final int day;
  final List<MenuItem> items;
  final RestaurantReviewArgs args;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Day $day', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          if (items.isEmpty)
            Text('No dishes selected', style: AppTextStyles.bodySm())
          else
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('${item.name} × ${args.quantityFor(day, item)}', style: AppTextStyles.bodySm(color: AppColors.textDark))),
                    Text('₹${item.price * args.quantityFor(day, item)}', style: AppTextStyles.bodySm()),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
