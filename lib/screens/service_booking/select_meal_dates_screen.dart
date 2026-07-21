import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';

/// Multi-select month-grid picker for the Restaurant Only Booking flow —
/// unlike Hotel's check-in/check-out range, individual meal dates are
/// toggled independently (a school might need meals on non-contiguous
/// days). Pops back with the chosen `Set<DateTime>`.
class SelectMealDatesScreen extends StatefulWidget {
  const SelectMealDatesScreen({super.key});

  @override
  State<SelectMealDatesScreen> createState() => _SelectMealDatesScreenState();
}

class _SelectMealDatesScreenState extends State<SelectMealDatesScreen> {
  late DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  final Set<DateTime> _selected = {};

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  void _toggleDay(DateTime day) {
    final normalized = _dateOnly(day);
    setState(() {
      if (_selected.contains(normalized)) {
        _selected.remove(normalized);
      } else {
        _selected.add(normalized);
      }
    });
  }

  void _selectNext7Days() {
    setState(() {
      _selected
        ..clear()
        ..addAll(List.generate(7, (i) => _dateOnly(DateTime.now().add(Duration(days: i)))));
    });
  }

  void _selectWeekdaysOnly() {
    setState(() {
      _selected
        ..clear()
        ..addAll(
          List.generate(14, (i) => _dateOnly(DateTime.now().add(Duration(days: i))))
              .where((d) => d.weekday != DateTime.saturday && d.weekday != DateTime.sunday)
              .take(7),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _selected.toList()..sort();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(SelectMealDatesStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: _selected.isEmpty ? null : () => Navigator.of(context).pop(_selected),
                child: Text('${SelectMealDatesStrings.confirmDatesPrefix}${_selected.length}${SelectMealDatesStrings.confirmDatesSuffix}', style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => setState(() => _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1)),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Text('${_months[_visibleMonth.month - 1]} ${_visibleMonth.year}', style: AppTextStyles.h3(color: AppColors.textDark)),
                IconButton(
                  onPressed: () => setState(() => _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1)),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [for (final w in _weekdays) Expanded(child: Center(child: Text(w, style: AppTextStyles.labelCaps().copyWith(fontSize: 10))))],
            ),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
                final daysInMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
                final leadingBlanks = firstOfMonth.weekday % 7;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                  itemCount: leadingBlanks + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < leadingBlanks) return const SizedBox.shrink();
                    final day = DateTime(_visibleMonth.year, _visibleMonth.month, index - leadingBlanks + 1);
                    final isSelected = _selected.contains(_dateOnly(day));
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: InkWell(
                        onTap: () => _toggleDay(day),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: isSelected ? AppColors.accentOrange : null, shape: BoxShape.circle),
                          child: Text(
                            '${day.day}',
                            style: AppTextStyles.bodySm(color: isSelected ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: _selectNext7Days, child: Text(SelectMealDatesStrings.select7Days, style: AppTextStyles.bodySm(color: AppColors.textDark)))),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton(onPressed: _selectWeekdaysOnly, child: Text(SelectMealDatesStrings.weekdaysOnly, style: AppTextStyles.bodySm(color: AppColors.textDark)))),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton(onPressed: () => setState(_selected.clear), child: Text(SelectMealDatesStrings.clearAll, style: AppTextStyles.bodySm(color: AppColors.textDark)))),
              ],
            ),
            if (sorted.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(SelectMealDatesStrings.selectedDates, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final d in sorted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(14)),
                      child: Text('${_months[d.month - 1].substring(0, 3)} ${d.day}', style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontSize: 12)),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
