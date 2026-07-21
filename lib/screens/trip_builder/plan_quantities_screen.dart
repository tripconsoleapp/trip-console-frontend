import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/menu_item.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/counter_field.dart';
import 'restaurant_review_screen.dart';

/// Sits between the day-by-day menu builder and the final review — turns
/// "which dishes" into "how many portions", split by veg/non-veg headcount,
/// with a running per-day pricing summary (subtotal + 5% service tax).
class PlanQuantitiesScreen extends StatefulWidget {
  const PlanQuantitiesScreen({super.key, required this.args});

  final RestaurantReviewArgs args;

  @override
  State<PlanQuantitiesScreen> createState() => _PlanQuantitiesScreenState();
}

class _PlanQuantitiesScreenState extends State<PlanQuantitiesScreen> {
  int _currentDay = 1;
  late int _vegCount;
  late int _nonVegCount;
  final Map<int, Map<MenuItem, int>> _quantities = {};

  @override
  void initState() {
    super.initState();
    final total = context.read<NewTripProvider>().totalParticipants;
    _vegCount = (total * 0.76).round();
    _nonVegCount = total - _vegCount;
  }

  void _ensureDayDefaults(int day, int totalHeads) {
    if (_quantities.containsKey(day)) return;
    final items = (widget.args.selectionsByDay[day] ?? {}).toList();
    final vegItems = items.where((i) => i.isVeg).toList();
    final nonVegItems = items.where((i) => !i.isVeg).toList();
    final dayMap = <MenuItem, int>{};
    if (vegItems.isNotEmpty) {
      final perItem = (_vegCount / vegItems.length).round();
      for (final item in vegItems) {
        dayMap[item] = perItem;
      }
    }
    if (nonVegItems.isNotEmpty) {
      final perItem = (_nonVegCount / nonVegItems.length).round();
      for (final item in nonVegItems) {
        dayMap[item] = perItem;
      }
    }
    _quantities[day] = dayMap;
  }

  void _continue(int totalHeads) {
    if (_currentDay >= widget.args.totalDays) {
      context.push(
        AppRouter.restaurantReview,
        extra: RestaurantReviewArgs(
          restaurant: widget.args.restaurant,
          selectionsByDay: widget.args.selectionsByDay,
          totalDays: widget.args.totalDays,
          quantitiesByDay: _quantities,
        ),
      );
    } else {
      setState(() => _currentDay++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final totalHeads = draft.totalParticipants;
    _ensureDayDefaults(_currentDay, totalHeads);
    final dayQuantities = _quantities[_currentDay]!;
    final items = (widget.args.selectionsByDay[_currentDay] ?? {}).toList();
    final unassigned = totalHeads - _vegCount - _nonVegCount;
    final isLastDay = _currentDay >= widget.args.totalDays;

    final subtotal = dayQuantities.entries.fold<int>(0, (sum, e) => sum + e.key.price * e.value);
    final tax = (subtotal * 0.05).round();
    final dayTotal = subtotal + tax;
    final portionsPlanned = dayQuantities.values.fold<int>(0, (sum, v) => sum + v);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PlanQuantitiesStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Day $_currentDay · $portionsPlanned ${PlanQuantitiesStrings.portionsPlannedSuffix}',
                  style: AppTextStyles.bodySm(),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _continue(totalHeads),
                    child: Text(
                      isLastDay ? '${PlanQuantitiesStrings.continueToReview} →' : '${PlanQuantitiesStrings.continueToDay}${_currentDay + 1} →',
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('${PlanQuantitiesStrings.settingQuantitiesFor}$_currentDay', style: AppTextStyles.bodySm()),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(PlanQuantitiesStrings.totalAttendees, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                  Text('$totalHeads Students', style: AppTextStyles.h2(color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  CounterField(
                    label: PlanQuantitiesStrings.vegMeals,
                    sublabel: '',
                    value: _vegCount,
                    onChanged: (v) => setState(() => _vegCount = v),
                  ),
                  const SizedBox(height: 8),
                  CounterField(
                    label: PlanQuantitiesStrings.nonVegMeals,
                    sublabel: '',
                    value: _nonVegCount,
                    onChanged: (v) => setState(() => _nonVegCount = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(child: Text(PlanQuantitiesStrings.scopeNote, style: AppTextStyles.bodySm(color: AppColors.primaryGreen))),
                ],
              ),
            ),
            if (unassigned != 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.accentOrange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$unassigned ${PlanQuantitiesStrings.unassignedPrefix}$_currentDay${PlanQuantitiesStrings.unassignedSuffix}',
                        style: AppTextStyles.bodySm(color: AppColors.accentOrange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            for (final mealType in MealType.values)
              if (items.any((i) => i.mealType == mealType)) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '${mealType.label} — Day $_currentDay',
                    style: AppTextStyles.labelCaps(),
                  ),
                ),
                for (final item in items.where((i) => i.mealType == mealType))
                  _QuantityTile(
                    item: item,
                    quantity: dayQuantities[item] ?? 0,
                    onChanged: (v) => setState(() => dayQuantities[item] = v),
                  ),
              ],
            const SizedBox(height: 12),
            Text(PlanQuantitiesStrings.pricingSummary, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
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
                      Text('₹$tax', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Divider(color: Color(0xFFE2E2E2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Day $_currentDay ${PlanQuantitiesStrings.dayTotal}', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                      Text('₹$dayTotal', style: AppTextStyles.h3(color: AppColors.accentOrange)),
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
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                Text('₹${item.price}${ChooseRestaurantStrings.perHead}', style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
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
