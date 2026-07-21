import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/menu_item.dart';
import '../../models/restaurant_option.dart';
import '../../providers/restaurant_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Filtered listing of restaurants matching the Meal Requirements criteria
/// — tapping "View Menu" opens the full [RestaurantMenuPlanningScreen].
class RestaurantSearchResultsScreen extends StatefulWidget {
  const RestaurantSearchResultsScreen({super.key});

  static const _restaurants = [
    RestaurantOption(
      name: 'Kandy Tamil Restaurant',
      rating: 4.6,
      tripsCount: 340,
      capacity: 80,
      mealsPerDay: 3,
      avgCostPerHead: 180,
      verified: true,
      badge: 'HERITAGE',
      sinceYear: 2014,
      dietaryVegPercent: 100,
      about: 'A Munnar landmark serving authentic Kerala Sadya and South Indian breakfast, built for large institutional groups since 2014.',
      menu: [
        MenuItem(name: 'Idli Sambar', price: 55, mealType: MealType.breakfast, isVeg: true),
        MenuItem(name: 'Dosa Set', price: 60, mealType: MealType.breakfast, isVeg: true, popular: true),
        MenuItem(name: 'Kerala Sadya', price: 180, mealType: MealType.lunch, isVeg: true, popular: true),
        MenuItem(name: 'Parotta Curry', price: 120, mealType: MealType.dinner, isVeg: true),
        MenuItem(name: 'Chapati Combo', price: 110, mealType: MealType.dinner, isVeg: true),
        MenuItem(name: 'Noodles', price: 90, mealType: MealType.dinner, isVeg: true),
      ],
    ),
    RestaurantOption(
      name: 'Spice Route Catering',
      rating: 4.2,
      tripsCount: 140,
      capacity: 150,
      mealsPerDay: 3,
      avgCostPerHead: 220,
      badge: 'GROUP FRIENDLY',
      sinceYear: 2018,
      dietaryVegPercent: 60,
      about: 'On-site delivery and setup catering, multi-cuisine, popular for premium outdoor group events.',
      menu: [
        MenuItem(name: 'Continental Breakfast', price: 90, mealType: MealType.breakfast, isVeg: true),
        MenuItem(name: 'Chicken Biryani', price: 220, mealType: MealType.lunch, isVeg: false, popular: true),
        MenuItem(name: 'Veg Thali', price: 150, mealType: MealType.lunch, isVeg: true),
        MenuItem(name: 'Grilled Fish', price: 250, mealType: MealType.dinner, isVeg: false),
      ],
    ),
    RestaurantOption(
      name: 'Munnar Food Court',
      rating: 4.2,
      tripsCount: 95,
      capacity: 60,
      mealsPerDay: 2,
      avgCostPerHead: 150,
      badge: 'BUDGET',
      sinceYear: 2016,
      dietaryVegPercent: 80,
      about: 'Fast-service multi-cuisine court near Old KSRTC Station, reliable for quick group lunches.',
      menu: [
        MenuItem(name: 'Veg Meals', price: 100, mealType: MealType.lunch, isVeg: true),
        MenuItem(name: 'Fried Rice', price: 130, mealType: MealType.lunch, isVeg: true),
        MenuItem(name: 'Chapati + Curry', price: 90, mealType: MealType.dinner, isVeg: true),
      ],
    ),
  ];

  @override
  State<RestaurantSearchResultsScreen> createState() => _RestaurantSearchResultsScreenState();
}

class _RestaurantSearchResultsScreenState extends State<RestaurantSearchResultsScreen> {
  String _filter = RestaurantSearchResultsStrings.filterAll;

  static const _filters = [
    RestaurantSearchResultsStrings.filterAll,
    RestaurantSearchResultsStrings.filterPureVeg,
    RestaurantSearchResultsStrings.filterBuffet,
    RestaurantSearchResultsStrings.filterCater,
  ];

  List<RestaurantOption> get _filtered {
    switch (_filter) {
      case RestaurantSearchResultsStrings.filterPureVeg:
        return RestaurantSearchResultsScreen._restaurants.where((r) => (r.dietaryVegPercent ?? 0) == 100).toList();
      case RestaurantSearchResultsStrings.filterBuffet:
        return RestaurantSearchResultsScreen._restaurants.where((r) => r.badge == 'HERITAGE' || r.badge == 'BUDGET').toList();
      case RestaurantSearchResultsStrings.filterCater:
        return RestaurantSearchResultsScreen._restaurants.where((r) => r.badge == 'GROUP FRIENDLY').toList();
      default:
        return RestaurantSearchResultsScreen._restaurants;
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<RestaurantBookingProvider>();
    final restaurants = _filtered;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(RestaurantSearchResultsStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                  for (final filter in _filters) ...[
                    _FilterChip(label: filter, selected: _filter == filter, onTap: () => setState(() => _filter = filter)),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${restaurants.length} ${RestaurantSearchResultsStrings.restaurantsFoundSuffix} · ${booking.location.toUpperCase()} · ${booking.totalGuests} ${RestaurantSearchResultsStrings.paxSuffix}',
                style: AppTextStyles.labelCaps().copyWith(fontSize: 10),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: restaurants.length,
                itemBuilder: (context, index) => _RestaurantCard(
                  restaurant: restaurants[index],
                  onTap: () => context.push(AppRouter.restaurantMenuPlanning, extra: restaurants[index]),
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

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.restaurant, required this.onTap});

  final RestaurantOption restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(height: 120, width: double.infinity, color: AppColors.mintGreen.withValues(alpha: 0.3), child: const Icon(Icons.storefront_rounded, size: 36, color: AppColors.primaryGreen)),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(restaurant.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700))),
                    const Icon(Icons.star_rounded, size: 14, color: AppColors.accentOrange),
                    Text('${restaurant.rating}', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(restaurant.about ?? '', style: AppTextStyles.bodySm().copyWith(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('₹${restaurant.avgCostPerHead}', style: AppTextStyles.h3(color: AppColors.textDark)),
                    Text(RestaurantSearchResultsStrings.perHead, style: AppTextStyles.bodySm()),
                    const Spacer(),
                    if (restaurant.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(restaurant.badge!, style: AppTextStyles.labelCaps(color: AppColors.accentOrange).copyWith(fontSize: 9)),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accentOrange)),
                    onPressed: onTap,
                    child: Text('${RestaurantSearchResultsStrings.viewMenu} →', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
