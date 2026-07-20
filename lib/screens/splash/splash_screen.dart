import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/glow_blob.dart';
import '../../widgets/pulsing_loading_bar.dart';

/// First screen shown on app launch. Displays the brand mark while the app
/// bootstraps, then hands off to the sign-in flow.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Figma splash is a fixed 2.5s bootstrap beat before handing off to auth.
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) context.go(AppRouter.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentOrange,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -88,
            left: -39,
            child: GlowBlob(
              width: 156,
              height: 354,
              color: AppColors.accentOrangeDark.withValues(alpha: 0.2),
              blurSigma: 30,
            ),
          ),
          Positioned(
            bottom: -88,
            right: -39,
            child: GlowBlob(
              width: 195,
              height: 442,
              color: AppColors.accentOrangeDarker.withValues(alpha: 0.15),
              blurSigma: 38,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        spreadRadius: -3,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        spreadRadius: -4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.explore_rounded,
                    color: AppColors.accentOrange,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  SplashStrings.appName,
                  style: AppTextStyles.h1(color: AppColors.backgroundWhite),
                ),
                const SizedBox(height: 4),
                Text(
                  SplashStrings.tagline,
                  style: AppTextStyles.labelCaps(
                    color: AppColors.backgroundWhite.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: PulsingLoadingBar(
                message: SplashStrings.loadingMessage,
                textStyle: AppTextStyles.bodySm(
                  color: AppColors.backgroundWhite.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
