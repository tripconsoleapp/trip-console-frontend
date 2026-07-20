import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Landing screen shown after onboarding — lets the user choose between
/// creating a new account or signing in to an existing one.
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Spacer(flex: 4),
              Column(
                children: [
                  Text(
                    GetStartedStrings.appName,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h1(color: AppColors.accentOrangeDark)
                        .copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    GetStartedStrings.tagline,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLg(color: AppColors.textGrey),
                  ),
                ],
              ),
              const Spacer(flex: 5),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRouter.signUp),
                  child: const Text(GetStartedStrings.createAccount),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.accentOrange),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => context.go(AppRouter.login),
                  child: Text(
                    GetStartedStrings.haveAccount,
                    style: AppTextStyles.button(color: AppColors.accentOrange),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.bodyLg(color: AppColors.textGrey),
                    children: const [
                      TextSpan(text: GetStartedStrings.legalPrefix),
                      TextSpan(
                        text: GetStartedStrings.terms,
                        style: TextStyle(
                          color: AppColors.accentOrange,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: GetStartedStrings.legalJoiner),
                      TextSpan(
                        text: GetStartedStrings.privacyPolicy,
                        style: TextStyle(
                          color: AppColors.accentOrange,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
