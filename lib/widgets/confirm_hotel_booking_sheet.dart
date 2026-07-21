import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/hotel_booking_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../utils/app_router.dart';

/// Final confirmation step of the Hotel Only Booking flow — mirrors the
/// trip wizard's confirm-booking pattern (checkbox + total + confirm/edit).
class ConfirmHotelBookingSheet extends StatefulWidget {
  const ConfirmHotelBookingSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const ConfirmHotelBookingSheet(),
    );
  }

  @override
  State<ConfirmHotelBookingSheet> createState() => _ConfirmHotelBookingSheetState();
}

class _ConfirmHotelBookingSheetState extends State<ConfirmHotelBookingSheet> {
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<HotelBookingProvider>();

    return Container(
      decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ConfirmHotelBookingStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded)),
            ],
          ),
          const SizedBox(height: 4),
          Text(booking.selectedHotel?.name ?? '', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ConfirmHotelBookingStrings.totalPrice, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
                Text('₹${booking.grandTotal}', style: AppTextStyles.h2(color: AppColors.accentOrange)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => setState(() => _confirmed = !_confirmed),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(value: _confirmed, activeColor: AppColors.primaryGreen, onChanged: (v) => setState(() => _confirmed = v ?? false)),
                Expanded(child: Padding(padding: const EdgeInsets.only(top: 12), child: Text(ConfirmHotelBookingStrings.confirmCheckbox, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontSize: 12)))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _confirmed
                  ? () {
                      context.read<HotelBookingProvider>().reset();
                      Navigator.of(context).pop();
                      context.go(AppRouter.home);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hotel booking confirmed. Our team will reach out shortly.'), backgroundColor: AppColors.primaryGreen),
                      );
                    }
                  : null,
              child: Text(ConfirmHotelBookingStrings.confirmHotelBooking, style: AppTextStyles.button()),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(ConfirmHotelBookingStrings.goBackAndEdit, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
            ),
          ),
        ],
      ),
    );
  }
}
