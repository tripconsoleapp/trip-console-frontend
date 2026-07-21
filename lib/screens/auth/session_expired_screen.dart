import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/icon_badge_circle.dart';

/// Shown when the user's auth session lapses — a dead end with a single
/// path back to Login.
class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: Text(SessionExpiredStrings.appBarTitle, style: AppTextStyles.h3(color: AppColors.accentOrangeDark)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const IconBadgeCircle(icon: Icons.history_toggle_off_rounded, diameter: 72, iconSize: 40),
              const SizedBox(height: 24),
              Text(SessionExpiredStrings.title, style: AppTextStyles.h2(color: AppColors.textDark)),
              const SizedBox(height: 8),
              Text(
                SessionExpiredStrings.body,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRouter.login),
                  child: const Text(SessionExpiredStrings.logInAgain),
                ),
              ),
              const Spacer(flex: 4),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.bodySm(),
                  children: [
                    const TextSpan(text: SessionExpiredStrings.needHelpPrefix),
                    TextSpan(
                      text: SessionExpiredStrings.contactSupport,
                      style: const TextStyle(color: AppColors.accentOrange, fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(SessionExpiredStrings.footerCopyright, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
