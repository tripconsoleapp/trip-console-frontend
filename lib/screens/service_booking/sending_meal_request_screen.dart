import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/restaurant_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Brief animated checklist shown while the meal request is "sent" to the
/// restaurant, before handing off to the success screen. Purely
/// presentational — each step "completes" on a timer, then auto-advances.
class SendingMealRequestScreen extends StatefulWidget {
  const SendingMealRequestScreen({super.key});

  @override
  State<SendingMealRequestScreen> createState() => _SendingMealRequestScreenState();
}

class _SendingMealRequestScreenState extends State<SendingMealRequestScreen> {
  static const _steps = [
    SendingMealRequestStrings.step1,
    SendingMealRequestStrings.step2,
    SendingMealRequestStrings.step3,
  ];

  int _completedCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 650), (timer) {
      setState(() => _completedCount++);
      if (_completedCount >= _steps.length) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) context.go(AppRouter.mealBookingSent);
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
    final restaurantName = context.read<RestaurantBookingProvider>().selectedRestaurant?.name ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.restaurant_rounded, size: 32, color: AppColors.accentOrange),
                ),
                const SizedBox(height: 24),
                Text(SendingMealRequestStrings.title, style: AppTextStyles.h3(color: AppColors.textDark), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  '${SendingMealRequestStrings.notifyingPrefix}$restaurantName${SendingMealRequestStrings.notifyingSuffix}',
                  style: AppTextStyles.bodySm(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                for (var i = 0; i < _steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        if (i == _completedCount)
                          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentOrange))
                        else
                          Icon(
                            i < _completedCount ? Icons.check_circle_rounded : Icons.circle_outlined,
                            size: 20,
                            color: i < _completedCount ? AppColors.primaryGreen : const Color(0xFFD0D0D0),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _steps[i],
                            style: AppTextStyles.bodyLg(color: i <= _completedCount ? AppColors.textDark : AppColors.textGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 6),
                    Text(SendingMealRequestStrings.secureTransaction, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
