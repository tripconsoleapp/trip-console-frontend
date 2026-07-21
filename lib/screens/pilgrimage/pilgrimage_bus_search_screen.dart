import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../providers/pilgrimage_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Bridges the Pilgrimage Console into the already-built KSRTC pipeline —
/// copies the pilgrimage group's destination/headcount into
/// [KsrtcBookingProvider] before handing off to the shared bus listing,
/// admin verification, and pooled-payment screens.
class PilgrimageBusSearchScreen extends StatelessWidget {
  const PilgrimageBusSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pilgrimage = context.watch<PilgrimageProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PilgrimageBusSearchStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                  final ksrtc = context.read<KsrtcBookingProvider>();
                  ksrtc.reset();
                  ksrtc.tripName = '${pilgrimage.destination} Pilgrimage';
                  ksrtc.fromLocation = 'Kochi International Airport';
                  ksrtc.toLocation = pilgrimage.destination;
                  ksrtc.totalPassengers = pilgrimage.totalPilgrims;
                  ksrtc.splitMemberCount = pilgrimage.totalPilgrims;
                  context.push(AppRouter.ksrtcBusList);
                },
                child: Text('${PilgrimageBusSearchStrings.searchBuses} →', style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(PilgrimageBusSearchStrings.captureNote, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            _AutoFilledField(label: PilgrimageBusSearchStrings.from, value: 'Kochi International Airport'),
            const SizedBox(height: 12),
            _AutoFilledField(label: PilgrimageBusSearchStrings.to, value: pilgrimage.destination),
            const SizedBox(height: 12),
            _AutoFilledField(label: PilgrimageBusSearchStrings.date, value: _formatDate(DateTime.now().add(const Duration(days: 21)))),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}, ${d.year}';
  }
}

class _AutoFilledField extends StatelessWidget {
  const _AutoFilledField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(PilgrimageBusSearchStrings.autoFilled, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 8)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
          child: Text(value, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
        ),
      ],
    );
  }
}
