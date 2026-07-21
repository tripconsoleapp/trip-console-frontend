import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/restaurant_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../widgets/counter_field.dart';

/// Per-meal-type toggle + headcount editor for the Restaurant Only Booking
/// flow — reached from Book Restaurant's "Edit headcounts" link. Headcounts
/// default to the group total and can be trimmed per meal (e.g. some
/// students skip breakfast).
class SelectMealTypesScreen extends StatefulWidget {
  const SelectMealTypesScreen({super.key});

  @override
  State<SelectMealTypesScreen> createState() => _SelectMealTypesScreenState();
}

class _SelectMealTypesScreenState extends State<SelectMealTypesScreen> {
  @override
  Widget build(BuildContext context) {
    final booking = context.watch<RestaurantBookingProvider>();
    final selectedCount = booking.mealTypesCount;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(SelectMealTypesStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: selectedCount == 0 ? null : () => Navigator.of(context).pop(),
                child: Text(
                  '${SelectMealTypesStrings.confirmMealTypesPrefix}${[
                    if (booking.breakfastNeeded) SelectMealTypesStrings.breakfast,
                    if (booking.lunchNeeded) SelectMealTypesStrings.lunch,
                    if (booking.dinnerNeeded) SelectMealTypesStrings.dinner,
                  ].join(' + ')})',
                  style: AppTextStyles.button(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accentOrange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(SelectMealTypesStrings.countsPrefilledNote, style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontSize: 12))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _MealTypeCard(
              icon: Icons.free_breakfast_rounded,
              label: SelectMealTypesStrings.breakfast,
              selected: booking.breakfastNeeded,
              onChanged: (v) => booking.setMealTypeNeeded(SelectMealTypesStrings.breakfast, v),
            ),
            const SizedBox(height: 12),
            _MealTypeCard(
              icon: Icons.lunch_dining_rounded,
              label: SelectMealTypesStrings.lunch,
              selected: booking.lunchNeeded,
              onChanged: (v) => booking.setMealTypeNeeded(SelectMealTypesStrings.lunch, v),
            ),
            const SizedBox(height: 12),
            _MealTypeCard(
              icon: Icons.dinner_dining_rounded,
              label: SelectMealTypesStrings.dinner,
              selected: booking.dinnerNeeded,
              onChanged: (v) => booking.setMealTypeNeeded(SelectMealTypesStrings.dinner, v),
            ),
            const SizedBox(height: 24),
            Text(SelectMealTypesStrings.headcountPerMeal, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            if (booking.breakfastNeeded)
              CounterField(
                label: SelectMealTypesStrings.breakfast,
                sublabel: '',
                value: booking.headcountFor(SelectMealTypesStrings.breakfast),
                onChanged: (v) => booking.setMealHeadcount(SelectMealTypesStrings.breakfast, v),
              ),
            if (booking.lunchNeeded) ...[
              const SizedBox(height: 10),
              CounterField(
                label: SelectMealTypesStrings.lunch,
                sublabel: '',
                value: booking.headcountFor(SelectMealTypesStrings.lunch),
                onChanged: (v) => booking.setMealHeadcount(SelectMealTypesStrings.lunch, v),
              ),
            ],
            if (booking.dinnerNeeded) ...[
              const SizedBox(height: 10),
              CounterField(
                label: SelectMealTypesStrings.dinner,
                sublabel: '',
                value: booking.headcountFor(SelectMealTypesStrings.dinner),
                onChanged: (v) => booking.setMealHeadcount(SelectMealTypesStrings.dinner, v),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MealTypeCard extends StatelessWidget {
  const _MealTypeCard({required this.icon, required this.label, required this.selected, required this.onChanged});

  final IconData icon;
  final String label;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!selected),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange.withValues(alpha: 0.06) : const Color(0xFFF5F3F3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.accentOrange : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? AppColors.accentOrange : AppColors.textGrey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  Text(
                    selected ? SelectMealTypesStrings.selected : SelectMealTypesStrings.notSelected,
                    style: AppTextStyles.bodySm(color: selected ? AppColors.primaryGreen : AppColors.textGrey).copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            Switch(value: selected, activeThumbColor: AppColors.accentOrange, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
