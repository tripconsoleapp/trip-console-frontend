import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../widgets/stat_tile.dart';

/// Full-route map + a leg-by-leg breakdown of the itinerary, reached from
/// the "Map Preview" link on the Destinations step.
class RoutePreviewScreen extends StatelessWidget {
  const RoutePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final stops = draft.stops;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(RoutePreviewStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(RoutePreviewStrings.looksGoodContinue, style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 180,
              width: double.infinity,
              color: AppColors.mintGreen.withValues(alpha: 0.3),
              child: const Icon(Icons.map_outlined, size: 44, color: AppColors.primaryGreen),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(RoutePreviewStrings.itineraryOverview, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatTile(label: RoutePreviewStrings.distance, value: '~420 km'),
                    StatTile(label: RoutePreviewStrings.estTime, value: '~9h 45m'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(RoutePreviewStrings.routeLegs, style: AppTextStyles.labelCaps()),
          const SizedBox(height: 8),
          for (var i = 0; i < stops.length; i++)
            _RouteLegTile(
              from: i == 0 ? draft.startingLocationName : stops[i - 1].name,
              to: stops[i].name,
              distanceLabel: '~${65 + stops[i].nights * 40}km',
              timeLabel: stops[i].etaFromPrevious,
            ),
          _RouteLegTile(
            from: stops.isEmpty ? draft.startingLocationName : stops.last.name,
            to: draft.startingLocationName,
            distanceLabel: '~${65 + stops.length * 40}km',
            timeLabel: 'Return leg',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accentOrange),
                const SizedBox(width: 8),
                Expanded(child: Text(RoutePreviewStrings.disclaimer, style: AppTextStyles.bodySm())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteLegTile extends StatelessWidget {
  const _RouteLegTile({required this.from, required this.to, required this.distanceLabel, required this.timeLabel});

  final String from;
  final String to;
  final String distanceLabel;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(from, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textGrey)),
                Text(to, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(distanceLabel, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
              Text(timeLabel, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
