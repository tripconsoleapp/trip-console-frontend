import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/menu_item.dart';
import '../../models/restaurant_option.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Restaurant/caterer listing — search, dietary + budget filter chips, and
/// cards summarizing rating, capacity, meal plan and average cost. "View
/// Menu" opens the day-by-day menu builder.
class ChooseRestaurantScreen extends StatefulWidget {
  const ChooseRestaurantScreen({super.key});

  static const _restaurants = [
    RestaurantOption(
      name: 'Clay Pot Restaurant',
      rating: 4.7,
      tripsCount: 210,
      capacity: 100,
      mealsPerDay: 3,
      avgCostPerHead: 140,
      menu: [
        MenuItem(name: 'Idli Sambar', price: 55, mealType: MealType.breakfast, isVeg: true),
        MenuItem(name: 'Poori Curry', price: 60, mealType: MealType.breakfast, isVeg: true),
        MenuItem(name: 'Appam + Vegetable Stew', price: 65, mealType: MealType.breakfast, isVeg: true),
        MenuItem(name: 'Upma', price: 45, mealType: MealType.breakfast, isVeg: true),
        MenuItem(name: 'Egg Curry & Appam', price: 70, mealType: MealType.breakfast, isVeg: false),
        MenuItem(name: 'Kerala Sadya (Full)', price: 150, mealType: MealType.lunch, isVeg: true, popular: true),
        MenuItem(name: 'Thali — Meals + 3 Curry', price: 120, mealType: MealType.lunch, isVeg: true),
        MenuItem(name: 'Chicken Curry Meals', price: 180, mealType: MealType.lunch, isVeg: false),
        MenuItem(name: 'Kerala Parotta + Curry', price: 100, mealType: MealType.dinner, isVeg: true),
        MenuItem(name: 'Chapati + Dal + Paneer', price: 110, mealType: MealType.dinner, isVeg: true),
        MenuItem(name: 'Rice + Sambar + Rasam', price: 90, mealType: MealType.dinner, isVeg: true),
        MenuItem(name: 'Fish Fry Thali', price: 200, mealType: MealType.dinner, isVeg: false),
        MenuItem(name: 'Veg Lunch Box', price: 80, mealType: MealType.packed, isVeg: true),
        MenuItem(name: 'Veg Snack Box', price: 50, mealType: MealType.packed, isVeg: true),
      ],
    ),
    RestaurantOption(
      name: 'Green Leaf Kitchen',
      rating: 4.5,
      tripsCount: 118,
      capacity: 60,
      mealsPerDay: 2,
      avgCostPerHead: 110,
      menu: [
        MenuItem(name: 'Idli Sambar', price: 50, mealType: MealType.breakfast, isVeg: true),
        MenuItem(name: 'Upma', price: 40, mealType: MealType.breakfast, isVeg: true),
        MenuItem(name: 'Vegetable Thali', price: 130, mealType: MealType.lunch, isVeg: true, popular: true),
        MenuItem(name: 'Curd Rice Meals', price: 100, mealType: MealType.lunch, isVeg: true),
        MenuItem(name: 'Veg Lunch Box', price: 75, mealType: MealType.packed, isVeg: true),
      ],
    ),
    RestaurantOption(
      name: 'Hillside Family Restaurant',
      rating: 4.3,
      tripsCount: 84,
      capacity: 120,
      mealsPerDay: 3,
      avgCostPerHead: 160,
      menu: [
        MenuItem(name: 'Puttu & Kadala Curry', price: 65, mealType: MealType.breakfast, isVeg: true),
        MenuItem(name: 'Omelette & Bread', price: 75, mealType: MealType.breakfast, isVeg: false),
        MenuItem(name: 'Kerala Sadya (Full)', price: 160, mealType: MealType.lunch, isVeg: true, popular: true),
        MenuItem(name: 'Chicken Biryani', price: 210, mealType: MealType.lunch, isVeg: false),
        MenuItem(name: 'Chapati + Chicken Curry', price: 190, mealType: MealType.dinner, isVeg: false),
        MenuItem(name: 'Rice + Sambar + Rasam', price: 95, mealType: MealType.dinner, isVeg: true),
        MenuItem(name: 'Non-Veg Lunch Box', price: 120, mealType: MealType.packed, isVeg: false),
      ],
    ),
  ];

  @override
  State<ChooseRestaurantScreen> createState() => _ChooseRestaurantScreenState();
}

class _ChooseRestaurantScreenState extends State<ChooseRestaurantScreen> {
  bool _vegOnly = false;
  bool _nonVegAvailable = false;
  bool _underBudget = false;

  @override
  Widget build(BuildContext context) {
    final filtered = ChooseRestaurantScreen._restaurants.where((r) {
      if (_vegOnly && r.hasNonVeg) return false;
      if (_nonVegAvailable && !r.hasNonVeg) return false;
      if (_underBudget && r.avgCostPerHead >= 150) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(ChooseRestaurantStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                style: AppTextStyles.bodyLg(color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: ChooseRestaurantStrings.searchHint,
                  hintStyle: AppTextStyles.bodyLg(color: AppColors.textGrey),
                  filled: true,
                  fillColor: const Color(0xFFF5F3F3),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textGrey),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  FilterChip(
                    label: Text(ChooseRestaurantStrings.vegOnly),
                    selected: _vegOnly,
                    onSelected: (v) => setState(() => _vegOnly = v),
                    selectedColor: AppColors.primaryGreen.withValues(alpha: 0.15),
                    labelStyle: AppTextStyles.bodySm(color: _vegOnly ? AppColors.primaryGreen : AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                    backgroundColor: const Color(0xFFF5F3F3),
                    side: BorderSide(color: _vegOnly ? AppColors.primaryGreen : Colors.transparent),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(ChooseRestaurantStrings.nonVegAvailable),
                    selected: _nonVegAvailable,
                    onSelected: (v) => setState(() => _nonVegAvailable = v),
                    selectedColor: AppColors.accentOrange.withValues(alpha: 0.15),
                    labelStyle: AppTextStyles.bodySm(color: _nonVegAvailable ? AppColors.accentOrange : AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                    backgroundColor: const Color(0xFFF5F3F3),
                    side: BorderSide(color: _nonVegAvailable ? AppColors.accentOrange : Colors.transparent),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(ChooseRestaurantStrings.underBudget),
                    selected: _underBudget,
                    onSelected: (v) => setState(() => _underBudget = v),
                    selectedColor: AppColors.accentOrange.withValues(alpha: 0.15),
                    labelStyle: AppTextStyles.bodySm(color: _underBudget ? AppColors.accentOrange : AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                    backgroundColor: const Color(0xFFF5F3F3),
                    side: BorderSide(color: _underBudget ? AppColors.accentOrange : Colors.transparent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: filtered.length,
                itemBuilder: (context, index) => _RestaurantCard(
                  restaurant: filtered[index],
                  onViewMenu: () => context.push(AppRouter.restaurantMenu, extra: filtered[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.restaurant, required this.onViewMenu});

  final RestaurantOption restaurant;
  final VoidCallback onViewMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(restaurant.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600))),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: AppColors.accentOrange),
                  Text('${restaurant.rating}', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatBlock(label: ChooseRestaurantStrings.capacity, value: '${restaurant.capacity}'),
              const SizedBox(width: 20),
              _StatBlock(label: ChooseRestaurantStrings.plan, value: '${restaurant.mealsPerDay} ${ChooseRestaurantStrings.mealsPerDaySuffix}'),
              const SizedBox(width: 20),
              _StatBlock(label: ChooseRestaurantStrings.avgCost, value: '₹${restaurant.avgCostPerHead}${ChooseRestaurantStrings.perHead}'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accentOrange)),
              onPressed: onViewMenu,
              child: Text('${ChooseRestaurantStrings.viewMenu} →', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
        Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
