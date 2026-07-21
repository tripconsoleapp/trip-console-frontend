import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';

/// Custom month-grid range picker for the Hotel Only Booking flow — tap a
/// start date, then an end date; pops back with `(checkIn, checkOut)`.
class SelectStayDatesScreen extends StatefulWidget {
  const SelectStayDatesScreen({super.key});

  @override
  State<SelectStayDatesScreen> createState() => _SelectStayDatesScreenState();
}

class _SelectStayDatesScreenState extends State<SelectStayDatesScreen> {
  late DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const _weekdaysFull = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  void _selectDay(DateTime day) {
    setState(() {
      if (_rangeStart == null || (_rangeEnd != null)) {
        _rangeStart = day;
        _rangeEnd = null;
      } else if (day.isAfter(_rangeStart!)) {
        _rangeEnd = day;
      } else {
        _rangeStart = day;
      }
    });
  }

  bool _isInRange(DateTime day) {
    if (_rangeStart == null || _rangeEnd == null) return false;
    return day.isAfter(_rangeStart!) && day.isBefore(_rangeEnd!);
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday % 7;
    final nights = (_rangeStart != null && _rangeEnd != null) ? _rangeEnd!.difference(_rangeStart!).inDays : 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(SelectStayDatesStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_rangeStart != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${SelectStayDatesStrings.checkInPrefix}${_weekdaysFull[_rangeStart!.weekday % 7]}, ${_months[_rangeStart!.month - 1].substring(0, 3)} ${_rangeStart!.day}',
                          style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (_rangeEnd != null) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.accentOrange, borderRadius: BorderRadius.circular(6)),
                            child: Text('$nights NIGHTS', style: AppTextStyles.labelCaps(color: AppColors.backgroundWhite).copyWith(fontSize: 9)),
                          ),
                        ],
                      ],
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _rangeStart != null && _rangeEnd != null
                        ? () => Navigator.of(context).pop((_rangeStart!, _rangeEnd!))
                        : null,
                    child: Text('${SelectStayDatesStrings.confirmStayDates} 📅', style: AppTextStyles.button()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                itemCount: leadingBlanks + daysInMonth,
                itemBuilder: (context, index) {
                  if (index < leadingBlanks) return const SizedBox.shrink();
                  final day = DateTime(_visibleMonth.year, _visibleMonth.month, index - leadingBlanks + 1);
                  final isStart = _rangeStart != null && _isSameDay(day, _rangeStart!);
                  final isEnd = _rangeEnd != null && _isSameDay(day, _rangeEnd!);
                  final inRange = _isInRange(day);
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: InkWell(
                      onTap: () => _selectDay(day),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isStart || isEnd ? AppColors.accentOrange : (inRange ? AppColors.accentOrange.withValues(alpha: 0.15) : null),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${day.day}',
                          style: AppTextStyles.bodySm(color: isStart || isEnd ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: isStart || isEnd ? FontWeight.w700 : FontWeight.w400),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
