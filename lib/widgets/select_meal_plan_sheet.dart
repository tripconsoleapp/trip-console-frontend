import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/hotel_booking_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';

class _MealPlanOption {
  const _MealPlanOption({required this.name, required this.body, required this.pricePerDay});
  final String name;
  final String body;
  final int pricePerDay;
}

/// Meal-plan picker for the Hotel Only Booking flow's hotel detail screen.
class SelectMealPlanSheet extends StatefulWidget {
  const SelectMealPlanSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const SelectMealPlanSheet(),
    );
  }

  @override
  State<SelectMealPlanSheet> createState() => _SelectMealPlanSheetState();
}

class _SelectMealPlanSheetState extends State<SelectMealPlanSheet> {
  static const _options = [
    _MealPlanOption(name: SelectMealPlanStrings.roomOnly, body: '', pricePerDay: 0),
    _MealPlanOption(name: SelectMealPlanStrings.continentalPlan, body: SelectMealPlanStrings.continentalBody, pricePerDay: 180),
    _MealPlanOption(name: SelectMealPlanStrings.modifiedAmerican, body: SelectMealPlanStrings.modifiedAmericanBody, pricePerDay: 350),
  ];

  late String _selected = context.read<HotelBookingProvider>().selectedMealPlan ?? SelectMealPlanStrings.roomOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(SelectMealPlanStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded)),
            ],
          ),
          for (final option in _options)
            InkWell(
              onTap: () => setState(() => _selected = option.name),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _selected == option.name ? AppColors.accentOrange.withValues(alpha: 0.06) : AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _selected == option.name ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(option.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                          if (option.body.isNotEmpty) Text(option.body, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      option.pricePerDay == 0 ? '₹0' : '₹${option.pricePerDay}${SelectMealPlanStrings.perDaySuffix}',
                      style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final option = _options.firstWhere((o) => o.name == _selected);
                context.read<HotelBookingProvider>().selectMealPlan(option.name, option.pricePerDay);
                Navigator.of(context).pop();
              },
              child: Text('${SelectMealPlanStrings.confirmMealPlan} →', style: AppTextStyles.button()),
            ),
          ),
        ],
      ),
    );
  }
}
