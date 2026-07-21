import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';

class _LocationResult {
  const _LocationResult({required this.name, required this.region});
  final String name;
  final String region;
}

/// Map-based picker for a trip's starting point — search, pick from
/// results, reuse a recent location, or paste a Google Maps link.
/// Pushed from the map card on the Destinations step; confirming here
/// writes straight into [NewTripProvider] and pops back.
class ChooseStartingLocationScreen extends StatefulWidget {
  const ChooseStartingLocationScreen({super.key});

  @override
  State<ChooseStartingLocationScreen> createState() => _ChooseStartingLocationScreenState();
}

class _ChooseStartingLocationScreenState extends State<ChooseStartingLocationScreen> {
  final _searchController = TextEditingController();
  final _urlController = TextEditingController();
  int _selectedIndex = 0;

  static const _results = [
    _LocationResult(name: 'Loyola School, Trivandrum', region: 'Sreekaryam, Thiruvananthapuram, Kerala'),
    _LocationResult(name: 'Technopark Phase III', region: 'Kazhakkoottam, Thiruvananthapuram, Kerala'),
  ];

  static const _recent = [
    _LocationResult(name: 'Kochi', region: 'Ernakulam District, Kerala, India'),
    _LocationResult(name: 'Munnar', region: 'Idukki District, Kerala, India'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _confirm() {
    final selected = _results[_selectedIndex];
    context.read<NewTripProvider>().setStartingLocation(selected.name, selected.region);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(StartingLocationStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: _confirm,
                child: Text(StartingLocationStrings.confirmLocation, style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _searchController,
            style: AppTextStyles.bodyLg(color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: StartingLocationStrings.searchHint,
              hintStyle: AppTextStyles.bodyLg(color: AppColors.textGrey),
              filled: true,
              fillColor: const Color(0xFFF5F3F3),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textGrey),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 160,
              width: double.infinity,
              color: AppColors.mintGreen.withValues(alpha: 0.3),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.location_on, size: 40, color: AppColors.accentOrange),
                  Positioned(
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6)],
                      ),
                      child: Text('8.5241° N, 76.9366° E', style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(StartingLocationStrings.searchingInKerala, style: AppTextStyles.labelCaps()),
          const SizedBox(height: 8),
          for (var i = 0; i < _results.length; i++)
            _LocationTile(
              result: _results[i],
              selected: i == _selectedIndex,
              onTap: () => setState(() => _selectedIndex = i),
            ),
          const SizedBox(height: 20),
          Text(StartingLocationStrings.recentLocations, style: AppTextStyles.labelCaps()),
          const SizedBox(height: 8),
          for (final recent in _recent)
            _LocationTile(
              result: recent,
              selected: false,
              icon: Icons.history_rounded,
              onTap: () {
                context.read<NewTripProvider>().setStartingLocation(recent.name, recent.region);
                Navigator.of(context).pop();
              },
            ),
          const SizedBox(height: 20),
          Text(StartingLocationStrings.quickImport, style: AppTextStyles.labelCaps()),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _urlController,
                  style: AppTextStyles.bodySm(color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: StartingLocationStrings.pasteUrlHint,
                    hintStyle: AppTextStyles.bodySm(),
                    filled: true,
                    fillColor: const Color(0xFFF5F3F3),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    prefixIcon: const Icon(Icons.link_rounded, size: 18, color: AppColors.textGrey),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(backgroundColor: AppColors.accentOrange, foregroundColor: AppColors.backgroundWhite),
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({required this.result, required this.selected, required this.onTap, this.icon});

  final _LocationResult result;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange.withValues(alpha: 0.08) : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
        ),
        child: Row(
          children: [
            Icon(icon ?? Icons.location_on_outlined, size: 18, color: selected ? AppColors.accentOrange : AppColors.textGrey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  Text(result.region, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.accentOrange),
          ],
        ),
      ),
    );
  }
}
