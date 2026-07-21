import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/hotel_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';

/// Detailed room-type picker with descriptions — reachable from Stay
/// Details for a fuller view than the inline chips offer.
class RoomTypePreferenceScreen extends StatefulWidget {
  const RoomTypePreferenceScreen({super.key});

  @override
  State<RoomTypePreferenceScreen> createState() => _RoomTypePreferenceScreenState();
}

class _RoomTypePreferenceScreenState extends State<RoomTypePreferenceScreen> {
  late String _selected = context.read<HotelBookingProvider>().roomPreference;

  static const _options = [
    (title: RoomTypePreferenceStrings.tripleSharing, body: RoomTypePreferenceStrings.tripleSharingBody, icon: Icons.groups_rounded),
    (title: RoomTypePreferenceStrings.dormitory, body: RoomTypePreferenceStrings.dormitoryBody, icon: Icons.bed_rounded),
    (title: RoomTypePreferenceStrings.doubleRoom, body: RoomTypePreferenceStrings.doubleRoomBody, icon: Icons.hotel_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(RoomTypePreferenceStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                  context.read<HotelBookingProvider>().setRoomPreference(_selected);
                  Navigator.of(context).pop();
                },
                child: Text(RoomTypePreferenceStrings.applyRoomType, style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final option in _options)
              InkWell(
                onTap: () => setState(() => _selected = option.title),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selected == option.title ? AppColors.accentOrange.withValues(alpha: 0.06) : AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _selected == option.title ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
                  ),
                  child: Row(
                    children: [
                      Icon(option.icon, size: 22, color: _selected == option.title ? AppColors.accentOrange : AppColors.textGrey),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(option.title, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
                            Text(option.body, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(
                        _selected == option.title ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                        color: _selected == option.title ? AppColors.accentOrange : AppColors.textGrey,
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
