import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/itinerary_stop.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';

/// Map-based destination picker, reached from the Add Destination sheet's
/// "Pick on map" link. Confirming here appends a new stop directly and
/// pops back to Destinations.
class PickOnMapScreen extends StatefulWidget {
  const PickOnMapScreen({super.key});

  @override
  State<PickOnMapScreen> createState() => _PickOnMapScreenState();
}

class _PickOnMapScreenState extends State<PickOnMapScreen> {
  final _searchController = TextEditingController(text: 'Munnar - Pothamedu Viewpoint');
  static const _pickedRegion = 'Idukki District, Kerala';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirm() {
    context.read<NewTripProvider>().addStop(
          ItineraryStop(
            name: _searchController.text.trim().isEmpty ? 'Pinned location' : _searchController.text.trim(),
            region: _pickedRegion,
            nights: 1,
            etaFromPrevious: '~3h 30m from previous stop',
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PickOnMapStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.bodyLg(color: AppColors.textDark),
              decoration: InputDecoration(
                hintText: PickOnMapStrings.searchHint,
                hintStyle: AppTextStyles.bodyLg(color: AppColors.textGrey),
                filled: true,
                fillColor: const Color(0xFFF5F3F3),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textGrey),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.mintGreen.withValues(alpha: 0.3),
              child: const Icon(Icons.location_on, size: 44, color: AppColors.accentOrange),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: AppColors.accentOrange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _searchController.text.isEmpty ? 'Pinned location' : _searchController.text,
                              style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(_pickedRegion, style: AppTextStyles.bodySm()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _confirm,
                      child: Text(PickOnMapStrings.confirmLocation, style: AppTextStyles.button()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
