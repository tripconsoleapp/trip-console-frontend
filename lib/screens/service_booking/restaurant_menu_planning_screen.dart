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
import '../../widgets/dietary_summary_sheet.dart';

/// Restaurant detail + menu builder for the Restaurant Only Booking flow —
/// merges the Figma "Restaurant Menu & Planning" and "Quantity Planning"
/// steps into one screen: each dish gets a quantity stepper directly
/// (selecting a dish *is* setting its quantity), rather than a separate
/// select-then-quantity pass, since the flow's data model is already flat
/// (one set of dishes/quantities applied across every selected meal date).
class RestaurantMenuPlanningScreen extends StatefulWidget {
  const RestaurantMenuPlanningScreen({super.key, required this.restaurant});

  final RestaurantOption restaurant;

  @override
  State<RestaurantMenuPlanningScreen> createState() => _RestaurantMenuPlanningScreenState();
}

class _RestaurantMenuPlanningScreenState extends State<RestaurantMenuPlanningScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantBookingProvider>().selectRestaurant(widget.restaurant);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _mealTypeNeeded(RestaurantBookingProvider booking, MealType type) => switch (type) {
        MealType.breakfast => booking.breakfastNeeded,
        MealType.lunch => booking.lunchNeeded,
        MealType.dinner => booking.dinnerNeeded,
        MealType.packed => true,
      };

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<RestaurantBookingProvider>();
    final visibleItems = widget.restaurant.menu.where((item) => _mealTypeNeeded(booking, item.mealType)).toList();
    final selectedCount = booking.selectedItems.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(widget.restaurant.name, style: AppTextStyles.h3(color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.accentOrange,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.accentOrange,
          labelStyle: AppTextStyles.bodySm().copyWith(fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: RestaurantMenuPlanningStrings.vegMenu),
            Tab(text: RestaurantMenuPlanningStrings.overview),
            Tab(text: RestaurantMenuPlanningStrings.groupDeals),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${RestaurantMenuPlanningStrings.selectedForPrefix}${booking.totalGuests}${RestaurantMenuPlanningStrings.selectedForSuffix}', style: AppTextStyles.bodySm()),
                    Text('₹${booking.subtotalPerDay}/day', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: selectedCount == 0 ? null : () => DietarySummarySheet.show(context),
                        child: Text(RestaurantMenuPlanningStrings.reviewDietarySummary, style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: selectedCount == 0 ? null : () => context.push(AppRouter.mealBookingSummary),
                          child: Text('${RestaurantMenuPlanningStrings.proceed} →', style: AppTextStyles.button()),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _VegMenuTab(restaurant: widget.restaurant, visibleItems: visibleItems, booking: booking),
            _OverviewTab(restaurant: widget.restaurant),
            const _GroupDealsTab(),
          ],
        ),
      ),
    );
  }
}

class _VegMenuTab extends StatelessWidget {
  const _VegMenuTab({required this.restaurant, required this.visibleItems, required this.booking});

  final RestaurantOption restaurant;
  final List<MenuItem> visibleItems;
  final RestaurantBookingProvider booking;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Row(
          children: [
            _StatBlock(label: RestaurantMenuPlanningStrings.rating, value: '${restaurant.rating}★'),
            _StatBlock(label: RestaurantMenuPlanningStrings.capacity, value: '${restaurant.capacity} pax'),
            _StatBlock(label: RestaurantMenuPlanningStrings.dietary, value: '${restaurant.dietaryVegPercent ?? 0}% Veg'),
            _StatBlock(label: RestaurantMenuPlanningStrings.since, value: 'Since ${restaurant.sinceYear ?? '—'}'),
          ],
        ),
        const SizedBox(height: 20),
        for (final mealType in MealType.values)
          if (visibleItems.any((item) => item.mealType == mealType)) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(mealType.label, style: AppTextStyles.labelCaps()),
            ),
            for (final item in visibleItems.where((item) => item.mealType == mealType))
              _QuantityTile(
                item: item,
                quantity: booking.quantities[item] ?? 0,
                onChanged: (v) => booking.setItemQuantity(item, v),
              ),
          ],
      ],
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 8)),
          Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _QuantityTile extends StatelessWidget {
  const _QuantityTile({required this.item, required this.quantity, required this.onChanged});

  final MenuItem item;
  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: quantity > 0 ? AppColors.accentOrange.withValues(alpha: 0.06) : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: quantity > 0 ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                    if (item.popular) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text('POPULAR', style: AppTextStyles.labelCaps(color: AppColors.accentOrange).copyWith(fontSize: 8)),
                      ),
                    ],
                  ],
                ),
                Text('₹${item.price}${RestaurantSearchResultsStrings.perHead}', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
              ],
            ),
          ),
          InkWell(
            onTap: quantity > 0 ? () => onChanged(quantity - 1) : null,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: quantity > 0 ? AppColors.accentOrange : const Color(0xFFE2E2E2))),
              child: Icon(Icons.remove, size: 14, color: quantity > 0 ? AppColors.accentOrange : AppColors.textGrey),
            ),
          ),
          SizedBox(width: 36, child: Text('$quantity', textAlign: TextAlign.center, style: AppTextStyles.bodyLg(color: AppColors.textDark))),
          InkWell(
            onTap: () => onChanged(quantity + 1),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: AppColors.accentOrange))),
              child: const Icon(Icons.add, size: 14, color: AppColors.accentOrange),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.restaurant});

  final RestaurantOption restaurant;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(RestaurantMenuPlanningStrings.about, style: AppTextStyles.h3(color: AppColors.textDark)),
        const SizedBox(height: 8),
        Text(restaurant.about ?? '', style: AppTextStyles.bodySm()),
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(Icons.groups_rounded, size: 16, color: AppColors.textGrey),
            const SizedBox(width: 8),
            Text('${restaurant.tripsCount} trips catered', style: AppTextStyles.bodySm()),
          ],
        ),
      ],
    );
  }
}

class _GroupDealsTab extends StatelessWidget {
  const _GroupDealsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Icon(Icons.local_offer_rounded, color: AppColors.primaryGreen),
              const SizedBox(width: 12),
              Expanded(child: Text('Groups of 40+ get a 10% discount on lunch and dinner combos.', style: AppTextStyles.bodySm(color: AppColors.primaryGreen))),
            ],
          ),
        ),
      ],
    );
  }
}
