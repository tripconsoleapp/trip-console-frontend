import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/phone_auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/icon_badge_circle.dart';
import '../../widgets/otp_input_row.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String _code = '';

  Future<void> _handleVerify(PhoneAuthProvider auth) async {
    if (_code.length != 4) return;
    final success = await auth.verifyOtp(_code);
    if (!mounted) return;
    if (success) {
      context.go(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<PhoneAuthProvider>();
    final isLoading = auth.status == PhoneAuthStatus.loading;
    final canVerify = _code.length == 4 && !isLoading;
    final canResend = auth.resendSecondsRemaining == 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                if (context.canPop()) context.pop();
              },
              icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const IconBadgeCircle(icon: Icons.verified_rounded, diameter: 64, iconSize: 32),
                    const SizedBox(height: 16),
                    Text(
                      VerifyOtpStrings.heading,
                      style: AppTextStyles.h2(color: AppColors.textDark).copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodyLg(color: AppColors.textGrey),
                        children: [
                          const TextSpan(text: VerifyOtpStrings.otpSentTo),
                          TextSpan(
                            text: auth.phoneNumber ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (context.canPop()) context.pop();
                      },
                      child: Text(
                        VerifyOtpStrings.changeNumber,
                        style: AppTextStyles.bodySm(color: AppColors.accentOrange),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OtpInputRow(
                      length: 4,
                      onChanged: (value) => setState(() => _code = value),
                    ),
                    const SizedBox(height: 16),
                    if (auth.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          auth.errorMessage!,
                          style: AppTextStyles.bodySm(color: AppColors.error),
                        ),
                      ),
                    TextButton(
                      onPressed: canResend ? auth.resendOtp : null,
                      child: Text(
                        canResend
                            ? VerifyOtpStrings.resendNow
                            : '${VerifyOtpStrings.resendPrefix}${auth.resendSecondsRemaining}${VerifyOtpStrings.resendSecondsSuffix}',
                        style: AppTextStyles.bodySm(),
                      ),
                    ),
                    const SizedBox(height: 240),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canVerify ? AppColors.accentOrange : const Color(0xFFE3E2E2),
                          disabledBackgroundColor: const Color(0xFFE3E2E2),
                        ),
                        onPressed: canVerify ? () => _handleVerify(auth) : null,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.backgroundWhite),
                              )
                            : Text(
                                VerifyOtpStrings.verifyAndContinue,
                                style: AppTextStyles.button(
                                  color: canVerify ? AppColors.backgroundWhite : AppColors.textGrey,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock, size: 12, color: AppColors.textGrey),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            VerifyOtpStrings.securityNote,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySm(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
