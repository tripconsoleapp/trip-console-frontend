import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/ksrtc_member_entry.dart';
import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Layer 3 — live per-member payment status with quick actions (remind /
/// mark as cash / send link), and a running collected-vs-needed total.
class MemberPaymentCollectionScreen extends StatelessWidget {
  const MemberPaymentCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();
    final progressPercent = (booking.collectionProgress * 100).round();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(MemberPaymentCollectionStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () {
                  booking.sendAllReminders();
                  context.push(AppRouter.paymentProgressTracker);
                },
                child: Text(MemberPaymentCollectionStrings.sendRemindersToAllPending, style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${booking.amountCollected} ${MemberPaymentCollectionStrings.collectedOfPrefix}₹${booking.totalToCollect}${MemberPaymentCollectionStrings.collectedSuffix}',
                  style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                ),
                Text('$progressPercent% Complete', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(value: booking.collectionProgress, minHeight: 8, backgroundColor: const Color(0xFFF5F3F3), color: AppColors.accentOrange),
            ),
            const SizedBox(height: 20),
            Text('${MemberPaymentCollectionStrings.membersPrefix}${booking.members.length})', style: AppTextStyles.labelCaps()),
            const SizedBox(height: 10),
            for (var i = 0; i < booking.members.length; i++) _MemberTile(member: booking.members[i], index: i, booking: booking),
          ],
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member, required this.index, required this.booking});

  final KsrtcMemberEntry member;
  final int index;
  final KsrtcBookingProvider booking;

  @override
  Widget build(BuildContext context) {
    final (badgeText, badgeColor) = switch (member.status) {
      MemberPaymentStatus.paid => (MemberPaymentCollectionStrings.paid, AppColors.primaryGreen),
      MemberPaymentStatus.pending => (MemberPaymentCollectionStrings.pending, AppColors.accentOrange),
      MemberPaymentStatus.notSent => (MemberPaymentCollectionStrings.notSent, AppColors.textGrey),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: AppColors.mintGreen.withValues(alpha: 0.5), child: Text(member.name[0], style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w700))),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  '₹${member.share} · ${member.paidVia ?? member.lastActionLabel ?? 'Link not sent'}',
                  style: AppTextStyles.bodySm().copyWith(fontSize: 11),
                ),
                if (member.status != MemberPaymentStatus.paid)
                  Row(
                    children: [
                      InkWell(
                        onTap: () => booking.sendReminder(index),
                        child: Text(
                          member.status == MemberPaymentStatus.notSent ? MemberPaymentCollectionStrings.sendLink : MemberPaymentCollectionStrings.remind,
                          style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 14),
                      InkWell(
                        onTap: () => booking.markPaid(index),
                        child: Text(MemberPaymentCollectionStrings.markAsCash, style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(badgeText, style: AppTextStyles.labelCaps(color: badgeColor).copyWith(fontSize: 9)),
          ),
        ],
      ),
    );
  }
}
