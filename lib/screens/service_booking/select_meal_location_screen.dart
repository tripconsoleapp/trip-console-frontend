import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';

class _Suggestion {
  const _Suggestion({required this.name, required this.region});
  final String name;
  final String region;
}

/// Map-based meal-service location picker for the Restaurant Only Booking
/// flow — pops back with the chosen name once confirmed.
class SelectMealLocationScreen extends StatefulWidget {
  const SelectMealLocationScreen({super.key});

  static const _suggestions = [
    _Suggestion(name: 'Munnar Town Centre', region: 'Searched 2 days ago'),
    _Suggestion(name: 'Chinnakanal', region: 'Searched 5 days ago'),
    _Suggestion(name: 'Kandy Tamil Restaurant Area', region: '1.2 km · Suggested near your trip'),
  ];

  @override
  State<SelectMealLocationScreen> createState() => _SelectMealLocationScreenState();
}

class _SelectMealLocationScreenState extends State<SelectMealLocationScreen> {
  String _selected = 'Munnar Town Centre';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(SelectMealLocationStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () => Navigator.of(context).pop(_selected),
                child: Text('${SelectMealLocationStrings.confirmMealLocation} ✓', style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              style: AppTextStyles.bodyLg(color: AppColors.textDark),
              decoration: InputDecoration(
                hintText: SelectMealLocationStrings.searchHint,
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
                        decoration: BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.circular(8)),
                        child: Text('${SelectMealLocationStrings.mapPreviewPrefix}${_selected.toUpperCase()}', style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(SelectMealLocationStrings.recentAndSuggested, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            for (final suggestion in SelectMealLocationScreen._suggestions)
              InkWell(
                onTap: () => setState(() => _selected = suggestion.name),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selected == suggestion.name ? AppColors.accentOrange.withValues(alpha: 0.08) : AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _selected == suggestion.name ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 18, color: _selected == suggestion.name ? AppColors.accentOrange : AppColors.textGrey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(suggestion.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                            Text(suggestion.region, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
