import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/itinerary_stop.dart';
import '../providers/new_trip_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../utils/app_router.dart';
import 'counter_field.dart';

class _RecentDestination {
  const _RecentDestination({required this.name, required this.region, required this.etaFromPrevious});
  final String name;
  final String region;
  final String etaFromPrevious;
}

/// Bottom sheet for appending a new stop to the trip route — search or pick
/// a recent destination, set nights/overnight, add notes. On confirm, the
/// new [ItineraryStop] is written straight into [NewTripProvider].
class AddDestinationSheet extends StatefulWidget {
  const AddDestinationSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddDestinationSheet(),
    );
  }

  @override
  State<AddDestinationSheet> createState() => _AddDestinationSheetState();
}

class _AddDestinationSheetState extends State<AddDestinationSheet> {
  final _searchController = TextEditingController();
  final _notesController = TextEditingController();
  _RecentDestination? _selected;
  int _nights = 1;
  bool _overnightStay = true;

  static const _recentOptions = [
    _RecentDestination(name: 'Munnar', region: 'Idukki District, Kerala', etaFromPrevious: '4h 30m'),
    _RecentDestination(name: 'Thekkady', region: 'Periyar, Kerala', etaFromPrevious: '3h 15m'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addToRoute() {
    final destination = _selected ?? _recentOptions.first;
    context.read<NewTripProvider>().addStop(
          ItineraryStop(
            name: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : destination.name,
            region: destination.region,
            nights: _overnightStay ? _nights : 0,
            etaFromPrevious: '${destination.etaFromPrevious} from previous stop',
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE2E2E2), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Text(AddDestinationStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                style: AppTextStyles.bodyLg(color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: AddDestinationStrings.searchHint,
                  hintStyle: AppTextStyles.bodyLg(color: AppColors.textGrey),
                  filled: true,
                  fillColor: const Color(0xFFF5F3F3),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textGrey),
                ),
              ),
              const SizedBox(height: 12),
              Text(AddDestinationStrings.recent, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final option in _recentOptions)
                    ChoiceChip(
                      label: Text(option.name),
                      selected: _selected?.name == option.name,
                      onSelected: (_) => setState(() => _selected = option),
                      selectedColor: AppColors.accentOrange.withValues(alpha: 0.15),
                      labelStyle: AppTextStyles.bodySm(
                        color: _selected?.name == option.name ? AppColors.accentOrange : AppColors.textDark,
                      ).copyWith(fontWeight: FontWeight.w600),
                      backgroundColor: const Color(0xFFF5F3F3),
                      side: BorderSide(color: _selected?.name == option.name ? AppColors.accentOrange : Colors.transparent),
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.map_outlined, size: 16, color: AppColors.accentOrange),
                    label: Text(AddDestinationStrings.pickOnMap),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push(AppRouter.pickOnMap);
                    },
                    labelStyle: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                    backgroundColor: const Color(0xFFF5F3F3),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CounterField(
                label: AddDestinationStrings.stayDuration,
                sublabel: AddDestinationStrings.stayDurationSublabel,
                value: _nights,
                minValue: 0,
                onChanged: (v) => setState(() => _nights = v),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AddDestinationStrings.overnightStay, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
                  Switch(
                    value: _overnightStay,
                    activeThumbColor: AppColors.accentOrange,
                    onChanged: (v) => setState(() => _overnightStay = v),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.directions_car_rounded, size: 16, color: AppColors.accentOrange),
                  const SizedBox(width: 6),
                  Text(
                    '${AddDestinationStrings.estimatedTravelTime}: ${(_selected ?? _recentOptions.first).etaFromPrevious}',
                    style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(AddDestinationStrings.notes, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 2,
                style: AppTextStyles.bodySm(color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: AddDestinationStrings.notesHint,
                  hintStyle: AppTextStyles.bodySm(),
                  filled: true,
                  fillColor: const Color(0xFFF5F3F3),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _addToRoute,
                  child: Text(AddDestinationStrings.addToRoute, style: AppTextStyles.button()),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AddDestinationStrings.cancel, style: AppTextStyles.bodySm(color: AppColors.textGrey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
