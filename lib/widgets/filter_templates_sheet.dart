import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';

/// Bottom sheet for narrowing the Templates grid by trip type, duration,
/// category and budget. Purely presentational — selections are local to
/// the sheet and just dismiss on "Show Results".
class FilterTemplatesSheet extends StatefulWidget {
  const FilterTemplatesSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterTemplatesSheet(),
    );
  }

  @override
  State<FilterTemplatesSheet> createState() => _FilterTemplatesSheetState();
}

class _FilterTemplatesSheetState extends State<FilterTemplatesSheet> {
  static const _tripTypes = ['Individual', 'Group', 'College', 'School'];
  static const _durations = ['1–3 Days', '4–7 Days', '1–2 Weeks', '2+ Weeks'];
  static const _categories = ['Nature', 'Adventure', 'Heritage', 'Pilgrimage'];

  final _selectedTripTypes = <String>{};
  final _selectedDurations = <String>{};
  final _selectedCategories = <String>{};
  RangeValues _budgetRange = const RangeValues(1000, 20000);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E2E2), borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(FilterTemplatesStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
                TextButton(
                  onPressed: () => setState(() {
                    _selectedTripTypes.clear();
                    _selectedDurations.clear();
                    _selectedCategories.clear();
                    _budgetRange = const RangeValues(1000, 20000);
                  }),
                  child: Text(FilterTemplatesStrings.reset, style: AppTextStyles.bodySm(color: AppColors.accentOrange)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _FilterSection(label: FilterTemplatesStrings.tripType, options: _tripTypes, selected: _selectedTripTypes, onChanged: () => setState(() {})),
            const SizedBox(height: 16),
            _FilterSection(label: FilterTemplatesStrings.duration, options: _durations, selected: _selectedDurations, onChanged: () => setState(() {})),
            const SizedBox(height: 16),
            _FilterSection(label: FilterTemplatesStrings.category, options: _categories, selected: _selectedCategories, onChanged: () => setState(() {})),
            const SizedBox(height: 16),
            Text(FilterTemplatesStrings.budgetRange, style: AppTextStyles.labelCaps()),
            RangeSlider(
              values: _budgetRange,
              min: 500,
              max: 50000,
              divisions: 50,
              activeColor: AppColors.accentOrange,
              labels: RangeLabels('₹${_budgetRange.start.round()}', '₹${_budgetRange.end.round()}'),
              onChanged: (values) => setState(() => _budgetRange = values),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('${FilterTemplatesStrings.showResultsPrefix} (12)', style: AppTextStyles.button()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.label, required this.options, required this.selected, required this.onChanged});

  final String label;
  final List<String> options;
  final Set<String> selected;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelCaps()),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              FilterChip(
                label: Text(option),
                selected: selected.contains(option),
                onSelected: (isSelected) {
                  isSelected ? selected.add(option) : selected.remove(option);
                  onChanged();
                },
                selectedColor: AppColors.accentOrange.withValues(alpha: 0.15),
                checkmarkColor: AppColors.accentOrange,
                labelStyle: AppTextStyles.bodySm(
                  color: selected.contains(option) ? AppColors.accentOrange : AppColors.textDark,
                ).copyWith(fontWeight: FontWeight.w600),
                backgroundColor: const Color(0xFFF5F3F3),
                side: BorderSide(color: selected.contains(option) ? AppColors.accentOrange : Colors.transparent),
              ),
          ],
        ),
      ],
    );
  }
}
