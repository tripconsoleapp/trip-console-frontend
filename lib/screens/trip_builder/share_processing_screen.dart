import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Brief animated hand-off screen while the e-ticket is "sent" to the
/// whole group — auto-advances to Share Success.
class ShareProcessingScreen extends StatefulWidget {
  const ShareProcessingScreen({super.key});

  @override
  State<ShareProcessingScreen> createState() => _ShareProcessingScreenState();
}

class _ShareProcessingScreenState extends State<ShareProcessingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) context.go(AppRouter.shareSuccess);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPassengers = context.watch<KsrtcBookingProvider>().totalPassengers;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.of(context).maybePop()),
        title: Text(ShareProcessingStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.accentOrange, width: 3)),
                  child: const Icon(Icons.send_rounded, size: 36, color: AppColors.accentOrange),
                ),
                const SizedBox(height: 24),
                Text(ShareProcessingStrings.sharing, style: AppTextStyles.h3(color: AppColors.textDark), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  '${ShareProcessingStrings.bodyPrefix}$totalPassengers${ShareProcessingStrings.bodySuffix}',
                  style: AppTextStyles.bodySm(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentOrange),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
