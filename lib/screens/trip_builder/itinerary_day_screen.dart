import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/itinerary_block.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/edit_itinerary_block_sheet.dart';

/// Editable day-by-day view of the generated itinerary — one timeline of
/// travel/activity/meal/rest blocks per day, each tappable to edit. The
/// last day's footer action moves on to Review Trip instead of the next day.
class ItineraryDayScreen extends StatelessWidget {
  const ItineraryDayScreen({super.key, required this.day});

  final int day;

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final totalDays = draft.dailyItinerary.length;
    final blocks = day < totalDays ? draft.dailyItinerary[day] : <ItineraryBlock>[];
    final isLastDay = day == totalDays - 1;
    final dailyExpense = day < totalDays ? draft.dailyExpense(day) : 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(ItineraryDayStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                    Text(ItineraryDayStrings.totalDailyExpense, style: AppTextStyles.labelCaps()),
                    Text('₹$dailyExpense', style: AppTextStyles.h3(color: AppColors.textDark)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLastDay) {
                        context.push(AppRouter.tripReview);
                      } else {
                        context.go(AppRouter.itineraryDay, extra: day + 1);
                      }
                    },
                    child: Text(
                      isLastDay ? '${ItineraryDayStrings.reviewTrip} →' : '${ItineraryDayStrings.nextDayPrefix}${day + 2} →',
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
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  for (var i = 0; i < totalDays; i++) ...[
                    _DayTab(day: i, selected: i == day, onTap: () => context.go(AppRouter.itineraryDay, extra: i)),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Day ${day + 1} of $totalDays', style: AppTextStyles.h3(color: AppColors.textDark)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  for (var i = 0; i < blocks.length; i++)
                    _BlockTile(
                      block: blocks[i],
                      onTap: () => EditItineraryBlockSheet.show(context, day: day, blockIndex: i, existing: blocks[i]),
                    ),
                  InkWell(
                    onTap: () => EditItineraryBlockSheet.show(context, day: day),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E2E2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add_circle_outline_rounded, size: 18, color: AppColors.textGrey),
                          const SizedBox(width: 8),
                          Text('+ ${ItineraryDayStrings.addBlock}', style: AppTextStyles.bodyLg(color: AppColors.textGrey)),
                        ],
                      ),
                    ),
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
          'Day ${day + 1}',
          style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _BlockTile extends StatelessWidget {
  const _BlockTile({required this.block, required this.onTap});

  final ItineraryBlock block;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: const Border(left: BorderSide(color: AppColors.accentOrange, width: 3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(block.type.icon, size: 18, color: AppColors.accentOrange),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(block.time, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
                      const SizedBox(width: 6),
                      Text('· ${block.type.label.toUpperCase()}', style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(block.title, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  if (block.subtitle.isNotEmpty) Text(block.subtitle, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                  if (block.cost != null) ...[
                    const SizedBox(height: 4),
                    Text('₹${block.cost}', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600)),
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
