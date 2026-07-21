import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/trip_summary.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

class _DaySummary {
  const _DaySummary({required this.dayNumber, required this.title, required this.eventCount, required this.startTime});

  final int dayNumber;
  final String title;
  final int eventCount;
  final String startTime;
}

/// Read-only, post-booking itinerary for a fully paid trip — a schedule
/// overview of every day, each tappable into a locked day timeline.
/// [TripSummary] carries no real itinerary of its own (My Trips is mock
/// data, not built from [NewTripProvider]), so the schedule is synthesized
/// deterministically from the trip's day count — same "illustrative, not
/// authoritative" approach used elsewhere for mock trips.
class LockedItineraryScreen extends StatelessWidget {
  const LockedItineraryScreen({super.key, required this.trip});

  final TripSummary trip;

  static const _dayTitles = ['Arrival & Transfer', 'Sightseeing & Exploration', 'Local Excursion', 'Leisure Day', 'Departure'];
  static const _eventCounts = [4, 5, 6, 5, 6];
  static const _startTimes = ['08:00 AM', '08:00 AM', '07:00 AM', '09:00 AM', '08:00 AM'];

  int get _dayCount {
    final match = RegExp(r'(\d+)D').firstMatch(trip.subtitle);
    return match != null ? int.parse(match.group(1)!) : 3;
  }

  List<_DaySummary> get _days {
    final count = _dayCount;
    return List.generate(count, (i) {
      final isLast = i == count - 1;
      final titleIndex = isLast ? _dayTitles.length - 1 : i.clamp(0, _dayTitles.length - 2);
      return _DaySummary(
        dayNumber: i + 1,
        title: i == 0 ? 'Arrival & Transfer' : (isLast ? 'Departure' : _dayTitles[titleIndex]),
        eventCount: _eventCounts[i % _eventCounts.length],
        startTime: _startTimes[i % _startTimes.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(LockedItineraryStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: Text(LockedItineraryStrings.viewMap),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.ios_share_rounded, size: 18, color: AppColors.backgroundWhite),
                    label: Text(LockedItineraryStrings.shareTrip, style: AppTextStyles.button()),
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
            Row(
              children: [
                Expanded(child: Text(trip.name, style: AppTextStyles.h2(color: AppColors.textDark))),
                Icon(Icons.more_vert_rounded, color: AppColors.textGrey),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            const SizedBox(height: 24),
            Text(LockedItineraryStrings.scheduleOverview, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text(trip.subtitle, style: AppTextStyles.bodySm()),
            const SizedBox(height: 16),
            for (final day in _days)
              _DayRow(
                day: day,
                onTap: () => context.push(AppRouter.lockedItineraryDay, extra: (trip: trip, day: day.dayNumber, title: day.title)),
              ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(LockedItineraryStrings.lockedNotice, style: AppTextStyles.bodySm().copyWith(fontSize: 12))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({required this.day, required this.onTap});

  final _DaySummary day;
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
          border: Border.all(color: const Color(0xFFE2E2E2)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Text('${day.dayNumber}', style: AppTextStyles.bodyLg(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${LockedItineraryStrings.dayPrefix}${day.dayNumber}: ${day.title}', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  Text(
                    '${day.eventCount} ${LockedItineraryStrings.eventsSuffix} · ${day.startTime} ${LockedItineraryStrings.startSuffix}',
                    style: AppTextStyles.bodySm().copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
