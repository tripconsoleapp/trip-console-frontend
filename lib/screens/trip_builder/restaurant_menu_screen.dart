import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/menu_item.dart';
import '../../models/restaurant_option.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import 'restaurant_review_screen.dart';

/// Day-by-day menu builder — one tab per trip day, a Veg/Non-Veg filter,
/// and the menu grouped into Breakfast/Lunch/Dinner/Packed Meals. Selecting
/// a dish is per-day; the same dish can be picked again on a later day
/// (flagged "ADDED TO DAY N" if it's already used elsewhere).
class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({super.key, required this.restaurant});

  final RestaurantOption restaurant;

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  int _currentDay = 1;
  bool _showNonVeg = false;
  final Map<int, Set<MenuItem>> _selections = {};

  Set<MenuItem> _daySelections(int day) => _selections.putIfAbsent(day, () => {});

  int? _dayAlreadyContaining(MenuItem item, int excludingDay) {
    for (final entry in _selections.entries) {
      if (entry.key != excludingDay && entry.value.contains(item)) return entry.key;
    }
    return null;
  }

  void _toggleItem(MenuItem item) {
    setState(() {
      final selections = _daySelections(_currentDay);
      selections.contains(item) ? selections.remove(item) : selections.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final totalDays = draft.stops.isEmpty ? 1 : draft.stops.length;
    final daySelections = _daySelections(_currentDay);
    final dayCostPerHead = daySelections.fold(0, (sum, item) => sum + item.price);
    final isLastDay = _currentDay == totalDays;
    final visibleItems = widget.restaurant.menu.where((item) => _showNonVeg || item.isVeg).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(
          '${RestaurantMenuStrings.titlePrefix}${widget.restaurant.name}',
          style: AppTextStyles.h3(color: AppColors.textDark),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
                    Text(
                      isLastDay
                          ? '${RestaurantMenuStrings.reviewAll} · ${daySelections.length} ${RestaurantMenuStrings.dishesSelected}'
                          : 'Day $_currentDay: ${daySelections.length} ${RestaurantMenuStrings.dishesSelected}',
                      style: AppTextStyles.bodySm(),
                    ),
                    Text('₹$dayCostPerHead${ChooseRestaurantStrings.perHead}', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLastDay) {
                        context.push(
                          AppRouter.planQuantities,
                          extra: RestaurantReviewArgs(restaurant: widget.restaurant, selectionsByDay: _selections, totalDays: totalDays),
                        );
                      } else {
                        setState(() => _currentDay++);
                      }
                    },
                    child: Text(
                      isLastDay ? RestaurantMenuStrings.planQuantities : '${RestaurantMenuStrings.continueToDay}${_currentDay + 1} →',
                      style: AppTextStyles.button(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text('${RestaurantMenuStrings.selectingDishesFor}$_currentDay', style: AppTextStyles.bodySm()),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  for (var day = 1; day <= totalDays; day++) ...[
                    _DayTab(day: day, selected: day == _currentDay, onTap: () => setState(() => _currentDay = day)),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(child: _DietToggleButton(label: RestaurantMenuStrings.veg, selected: !_showNonVeg, onTap: () => setState(() => _showNonVeg = false))),
                    Expanded(child: _DietToggleButton(label: RestaurantMenuStrings.nonVeg, selected: _showNonVeg, onTap: () => setState(() => _showNonVeg = true))),
                  ],
                ),
              ),
            ),
            if (daySelections.isEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(RestaurantMenuStrings.noDishesSelected, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                      Text(RestaurantMenuStrings.browseMenuHint, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  for (final mealType in MealType.values)
                    if (visibleItems.any((item) => item.mealType == mealType)) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(mealType.label, style: AppTextStyles.labelCaps()),
                      ),
                      for (final item in visibleItems.where((item) => item.mealType == mealType))
                        _MenuItemTile(
                          item: item,
                          selected: daySelections.contains(item),
                          addedToDay: _dayAlreadyContaining(item, _currentDay),
                          onToggle: () => _toggleItem(item),
                        ),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayTab extends StatelessWidget {
  const _DayTab({required this.day, required this.selected, required this.onTap});

  final int day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange : const Color(0xFFF5F3F3),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Text(
          'Day $day',
          style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _DietToggleButton extends StatelessWidget {
  const _DietToggleButton({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: selected ? AppColors.accentOrange : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  const _MenuItemTile({required this.item, required this.selected, required this.addedToDay, required this.onToggle});

  final MenuItem item;
  final bool selected;
  final int? addedToDay;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? AppColors.accentOrange.withValues(alpha: 0.06) : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selected ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
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
                Text('₹${item.price}${ChooseRestaurantStrings.perHead}', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                if (addedToDay != null)
                  Text('ADDED TO DAY $addedToDay', style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
              ],
            ),
          ),
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.accentOrange : Colors.transparent,
                border: Border.all(color: AppColors.accentOrange),
              ),
              child: Icon(selected ? Icons.check_rounded : Icons.add_rounded, size: 18, color: selected ? AppColors.backgroundWhite : AppColors.accentOrange),
            ),
          ),
        ],
      ),
    );
  }
}
