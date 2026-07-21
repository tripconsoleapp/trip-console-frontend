import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Terminal screen of the KSRTC pipeline — e-ticket shared with the group,
/// with a preview of the trip's next stop to keep momentum going.
class ShareSuccessScreen extends StatelessWidget {
  const ShareSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go(AppRouter.ksrtcETicket)),
        title: Text(ShareSuccessStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(ShareSuccessStrings.postPayment, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.accentOrange, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, size: 40, color: AppColors.backgroundWhite),
              ),
            ),
            const SizedBox(height: 16),
            Text(ShareSuccessStrings.sharedWithGroup, style: AppTextStyles.h2(color: AppColors.textDark), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              '${ShareSuccessStrings.bodyPrefix}${booking.totalPassengers}${ShareSuccessStrings.bodySuffix}',
              style: AppTextStyles.bodySm(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(ShareSuccessStrings.sharedVia, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_rounded, size: 18, color: AppColors.primaryGreen),
                      const SizedBox(width: 10),
                      Expanded(child: Text(ShareSuccessStrings.groupChat, style: AppTextStyles.bodyLg(color: AppColors.textDark))),
                      const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.primaryGreen),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.groups_rounded, size: 18, color: AppColors.primaryGreen),
                      const SizedBox(width: 10),
                      Expanded(child: Text('${booking.totalPassengers}${ShareSuccessStrings.recipientsSuffix}', style: AppTextStyles.bodyLg(color: AppColors.textDark))),
                      const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.primaryGreen),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 16, color: AppColors.textGrey),
                      const SizedBox(width: 10),
                      Text(ShareSuccessStrings.sentJustNow, style: AppTextStyles.bodySm()),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(ShareSuccessStrings.nextDestination, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Container(height: 130, width: double.infinity, color: AppColors.mintGreen.withValues(alpha: 0.3), child: const Icon(Icons.landscape_rounded, size: 40, color: AppColors.primaryGreen)),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Text('Fort Kochi · Coastal Express', style: AppTextStyles.bodyLg(color: AppColors.backgroundWhite).copyWith(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.go(AppRouter.myTrips),
                child: Text('${ShareSuccessStrings.review} →', style: AppTextStyles.button()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
