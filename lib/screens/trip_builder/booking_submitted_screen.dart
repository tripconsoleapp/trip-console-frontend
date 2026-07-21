import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Layer 1 of the KSRTC pipeline — a simulated admin-review wait. In the
/// real product this can take up to 30 minutes and the user leaves the
/// screen; for this prototype it auto-approves after a short delay so the
/// rest of the pipeline can be reached and exercised.
class BookingSubmittedScreen extends StatefulWidget {
  const BookingSubmittedScreen({super.key});

  @override
  State<BookingSubmittedScreen> createState() => _BookingSubmittedScreenState();
}

class _BookingSubmittedScreenState extends State<BookingSubmittedScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      context.read<KsrtcBookingProvider>().setAdminVerified(true);
      context.go(AppRouter.busApproved);
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
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(BookingSubmittedStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.hourglass_top_rounded, size: 32, color: AppColors.accentOrange),
                ),
                const SizedBox(height: 20),
                Text(BookingSubmittedStrings.heading, style: AppTextStyles.h3(color: AppColors.textDark), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(BookingSubmittedStrings.body, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primaryGreen),
                      const SizedBox(width: 8),
                      Expanded(child: Text(BookingSubmittedStrings.etaNote, style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontSize: 12))),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go(AppRouter.home),
                    child: Text(BookingSubmittedStrings.backToDashboard),
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
