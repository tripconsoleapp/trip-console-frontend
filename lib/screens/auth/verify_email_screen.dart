import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/user_role.dart';
import '../../providers/email_auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/icon_badge_circle.dart';
import '../../widgets/otp_input_row.dart';

/// Step 3 of 3 in onboarding — confirm the 6-digit code sent to the new
/// account's email, then land on the chosen role's home experience.
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String _code = '';

  void _handleVerify() {
    if (_code.length != 6) return;
    // TODO(backend): actually check the emailed code once a code-verification
    // backend exists (see AuthService.sendEmailVerificationLink).
    switch (widget.role) {
      case UserRole.organizer:
        context.go(AppRouter.home);
      case UserRole.operator:
      case UserRole.fieldCoordinator:
        context.push(AppRouter.comingSoon, extra: widget.role);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<EmailAuthProvider>();
    final canResend = auth.resendSecondsRemaining == 0;
    final canVerify = _code.length == 6;

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
                    const IconBadgeCircle(icon: Icons.mail_outline_rounded, diameter: 64, iconSize: 32),
                    const SizedBox(height: 16),
                    Text(VerifyEmailStrings.title, style: AppTextStyles.h2(color: AppColors.textDark).copyWith(fontSize: 26)),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.bodyLg(color: AppColors.textGrey),
                        children: [
                          const TextSpan(text: VerifyEmailStrings.sentToPrefix),
                          TextSpan(
                            text: auth.email ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
                          ),
                          const TextSpan(text: VerifyEmailStrings.sentToSuffix),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    OtpInputRow(length: 6, boxSize: 44, gap: 8, onChanged: (value) => setState(() => _code = value)),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: canResend ? auth.resendVerification : null,
                      child: Text(
                        canResend
                            ? VerifyEmailStrings.resendNow
                            : '${VerifyEmailStrings.resendPrefix}${auth.resendSecondsRemaining}${VerifyEmailStrings.resendSecondsSuffix}',
                        style: AppTextStyles.bodySm(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canVerify ? AppColors.accentOrange : const Color(0xFFE3E2E2),
                        ),
                        onPressed: canVerify ? _handleVerify : null,
                        child: Text(
                          VerifyEmailStrings.verifyAndContinue,
                          style: AppTextStyles.button(color: canVerify ? AppColors.backgroundWhite : AppColors.textGrey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(VerifyEmailStrings.securityNote, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
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
