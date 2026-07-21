import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Loading screen shown while the day-by-day itinerary is synthesized from
/// whatever's been chosen on Destinations/Services — same animated
/// checklist pattern as [TripSetupLoadingScreen].
class ItineraryGeneratingScreen extends StatefulWidget {
  const ItineraryGeneratingScreen({super.key});

  @override
  State<ItineraryGeneratingScreen> createState() => _ItineraryGeneratingScreenState();
}

class _ItineraryGeneratingScreenState extends State<ItineraryGeneratingScreen> {
  static const _steps = [
    ItineraryGeneratingStrings.step1,
    ItineraryGeneratingStrings.step2,
    ItineraryGeneratingStrings.step3,
    ItineraryGeneratingStrings.step4,
  ];

  int _completedCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    context.read<NewTripProvider>().generateItinerary();
    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      setState(() => _completedCount++);
      if (_completedCount >= _steps.length) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) context.go(AppRouter.itineraryDay, extra: 0);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.accentOrange),
                ),
                const SizedBox(height: 24),
                Text(ItineraryGeneratingStrings.title, style: AppTextStyles.h3(color: AppColors.textDark), textAlign: TextAlign.center),
                const SizedBox(height: 28),
                for (var i = 0; i < _steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          i < _completedCount ? Icons.check_circle_rounded : Icons.circle_outlined,
                          size: 20,
                          color: i < _completedCount ? AppColors.primaryGreen : const Color(0xFFD0D0D0),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _steps[i],
                            style: AppTextStyles.bodyLg(color: i < _completedCount ? AppColors.textDark : AppColors.textGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
