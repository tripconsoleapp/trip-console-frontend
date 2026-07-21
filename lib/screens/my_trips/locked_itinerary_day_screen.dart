import 'package:flutter/material.dart';

import '../../models/itinerary_block.dart';
import '../../models/trip_summary.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';

/// Read-only timeline for one day of a locked, post-booking itinerary —
/// same visual language as the wizard's editable [ItineraryDayScreen], but
/// with no edit/add-block affordances since the trip is confirmed.
class LockedItineraryDayScreen extends StatelessWidget {
  const LockedItineraryDayScreen({super.key, required this.trip, required this.day, required this.dayTitle});

  final TripSummary trip;
  final int day;
  final String dayTitle;

  List<ItineraryBlock> get _blocks {
    final dayCountMatch = RegExp(r'(\d+)D').firstMatch(trip.subtitle);
    final dayCount = dayCountMatch != null ? int.parse(dayCountMatch.group(1)!) : 3;
    final dayShare = (trip.totalCost / dayCount).round();
    return [
      const ItineraryBlock(type: BlockType.travel, time: '08:00 AM', title: 'Transfer', subtitle: 'Coordinated by your assigned operator'),
      ItineraryBlock(type: BlockType.activity, time: '10:30 AM', title: dayTitle, subtitle: 'Guided experience', cost: (dayShare * 0.3).round()),
      ItineraryBlock(type: BlockType.meal, time: '01:00 PM', title: 'Included Meals', subtitle: 'As per confirmed dining plan', cost: (dayShare * 0.25).round()),
      ItineraryBlock(type: BlockType.rest, time: '07:00 PM', title: 'Overnight Stay', subtitle: 'As per confirmed accommodation', cost: (dayShare * 0.2).round()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final blocks = _blocks;
    final dailyExpense = blocks.fold<int>(0, (sum, b) => sum + (b.cost ?? 0));

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text('${LockedItineraryStrings.dayPrefix}$day: $dayTitle', style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LockedItineraryStrings.totalDailyExpense, style: AppTextStyles.labelCaps()),
                Text('₹$dailyExpense', style: AppTextStyles.h3(color: AppColors.textDark)),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_rounded, size: 12, color: AppColors.primaryGreen),
                  const SizedBox(width: 4),
                  Text(LockedItineraryStrings.itineraryLocked, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
                ],
              ),
            ),
            for (final block in blocks) _ReadOnlyBlockTile(block: block),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyBlockTile extends StatelessWidget {
  const _ReadOnlyBlockTile({required this.block});

  final ItineraryBlock block;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: AppColors.primaryGreen, width: 3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(block.type.icon, size: 18, color: AppColors.primaryGreen),
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
                Text(block.subtitle, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                if (block.cost != null) ...[
                  const SizedBox(height: 4),
                  Text('₹${block.cost}', style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
