import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// End of Layer 1 — the admin has verified the bus selection. A step
/// tracker recaps how it got here before handing off to Layer 2 (Booking
/// Summary).
class BusApprovedScreen extends StatelessWidget {
  const BusApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();
    final busLabel = booking.selectedBus == null ? '—' : '${booking.selectedBus!.name} confirmed';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(BusApprovedStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, size: 40, color: AppColors.primaryGreen),
              ),
              const SizedBox(height: 16),
              Text(BusApprovedStrings.verifiedByAdmin, style: AppTextStyles.h2(color: AppColors.primaryGreen), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(BusApprovedStrings.body, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
              const SizedBox(height: 28),
              Row(
                children: [
                  _StepDot(done: true),
                  _StepLine(),
                  _StepDot(done: true),
                  _StepLine(),
                  _StepDot(done: true, current: true),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(BusApprovedStrings.busSelected, style: AppTextStyles.bodySm().copyWith(fontSize: 10), textAlign: TextAlign.center)),
                  Expanded(child: Text(BusApprovedStrings.adminVerification, style: AppTextStyles.bodySm().copyWith(fontSize: 10), textAlign: TextAlign.center)),
                  Expanded(child: Text(BusApprovedStrings.continueTripSetup, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                ],
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.directions_bus_filled_rounded, size: 18, color: AppColors.textDark),
                    const SizedBox(width: 10),
                    Expanded(child: Text(busLabel, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(BusApprovedStrings.verified, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push(AppRouter.ksrtcBookingSummary),
                  child: Text(BusApprovedStrings.continueTrip, style: AppTextStyles.button()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.done, this.current = false});

  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? (current ? AppColors.accentOrange : AppColors.primaryGreen) : const Color(0xFFE2E2E2),
      ),
      child: Icon(Icons.check_rounded, size: 14, color: AppColors.backgroundWhite),
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine();

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(height: 2, color: AppColors.primaryGreen.withValues(alpha: 0.4)));
  }
}
