import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_booking_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';

/// Day-by-day portion breakdown for the Restaurant Only Booking flow — the
/// same selected dishes/quantities repeat on every selected meal date
/// (illustrative, not per-day distinct menus), so each row is identical by
/// design.
class DietarySummarySheet extends StatelessWidget {
  const DietarySummarySheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const DietarySummarySheet(),
    );
  }

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<RestaurantBookingProvider>();
    final dates = booking.sortedMealDates;
    final portionsPerDay = booking.quantities.values.fold<int>(0, (sum, v) => sum + v);

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DietarySummaryStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded)),
            ],
          ),
          Text(DietarySummaryStrings.readyToShare, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
          const SizedBox(height: 16),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var i = 0; i < dates.length; i++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${DietarySummaryStrings.day} ${i + 1} · ${_weekdays[dates[i].weekday % 7]}, ${_months[dates[i].month - 1]} ${dates[i].day}',
                          style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text('$portionsPerDay ${DietarySummaryStrings.portions}', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(DietarySummaryStrings.close, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
            ),
          ),
        ],
      ),
    );
  }
}
