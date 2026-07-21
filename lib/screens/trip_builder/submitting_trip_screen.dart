import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Brief animated checklist shown right after "Yes, Submit Trip" — same
/// pattern as the wizard's other loaders, then hands off to
/// [TripSubmittedScreen].
class SubmittingTripScreen extends StatefulWidget {
  const SubmittingTripScreen({super.key});

  @override
  State<SubmittingTripScreen> createState() => _SubmittingTripScreenState();
}

class _SubmittingTripScreenState extends State<SubmittingTripScreen> {
  static const _steps = [
    SubmittingTripStrings.step1,
    SubmittingTripStrings.step2,
    SubmittingTripStrings.step3,
    SubmittingTripStrings.step4,
  ];

  int _completedCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() => _completedCount++);
      if (_completedCount >= _steps.length) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) context.go(AppRouter.tripSubmitted);
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
    context.watch<NewTripProvider>();
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.upload_rounded, size: 40, color: AppColors.accentOrange),
                const SizedBox(height: 20),
                Text(SubmittingTripStrings.title, style: AppTextStyles.h3(color: AppColors.textDark), textAlign: TextAlign.center),
                const SizedBox(height: 28),
                for (var i = 0; i < _steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          i < _completedCount
                              ? Icons.check_circle_rounded
                              : i == _completedCount
                                  ? Icons.pending_rounded
                                  : Icons.circle_outlined,
                          size: 20,
                          color: i < _completedCount
                              ? AppColors.primaryGreen
                              : i == _completedCount
                                  ? AppColors.accentOrange
                                  : const Color(0xFFD0D0D0),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _steps[i],
                            style: AppTextStyles.bodyLg(color: i <= _completedCount ? AppColors.textDark : AppColors.textGrey),
                          ),
                        ),
                        Text(
                          i < _completedCount ? 'Done' : (i == _completedCount ? 'In Progress' : 'Pending'),
                          style: AppTextStyles.bodySm(
                            color: i < _completedCount ? AppColors.primaryGreen : (i == _completedCount ? AppColors.accentOrange : AppColors.textGrey),
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
