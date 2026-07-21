import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/icon_badge_circle.dart';
import '../../widgets/labeled_text_field.dart';
import '../../widgets/password_strength_meter.dart';

enum _ResetPasswordViewState { form, success, linkExpired }

/// Set new credentials after a successful recovery — new password +
/// confirmation with a strength meter. Also covers the "link expired"
/// state Figma specs for stale reset links (24h expiry).
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.linkExpired = false});

  /// TODO(backend): drive this from the reset link's token validity once a
  /// backend issues/validates reset tokens, instead of a constructor flag.
  final bool linkExpired;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;
  late _ResetPasswordViewState _viewState =
      widget.linkExpired ? _ResetPasswordViewState.linkExpired : _ResetPasswordViewState.form;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    final password = _passwordController.text;
    if (password.length < 8) {
      setState(() => _error = ResetPasswordStrings.passwordTooShort);
      return;
    }
    if (password != _confirmController.text) {
      setState(() => _error = ResetPasswordStrings.passwordsDontMatch);
      return;
    }
    // TODO(backend): confirm the reset with FirebaseAuth (confirmPasswordReset
    // with the oobCode from the email link, or updatePassword after OTP re-auth).
    setState(() {
      _error = null;
      _viewState = _ResetPasswordViewState.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        automaticallyImplyLeading: _viewState == _ResetPasswordViewState.form,
        title: Text(ResetPasswordStrings.appBarTitle, style: AppTextStyles.h3(color: AppColors.textDark)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: switch (_viewState) {
            _ResetPasswordViewState.form => _buildForm(context),
            _ResetPasswordViewState.success => _buildSuccess(context),
            _ResetPasswordViewState.linkExpired => _buildLinkExpired(context),
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Center(child: IconBadgeCircle(icon: Icons.lock_outline_rounded, diameter: 64, iconSize: 32)),
        const SizedBox(height: 20),
        Center(child: Text(ResetPasswordStrings.title, style: AppTextStyles.h2(color: AppColors.textDark))),
        const SizedBox(height: 4),
        Center(child: Text(ResetPasswordStrings.subtitle, textAlign: TextAlign.center, style: AppTextStyles.bodySm())),
        const SizedBox(height: 24),
        LabeledTextField(
          label: ResetPasswordStrings.newPassword,
          controller: _passwordController,
          hintText: '••••••••',
          obscurable: true,
          prefixIcon: Icons.lock_outline_rounded,
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _passwordController,
          builder: (_, __) => PasswordStrengthMeter(password: _passwordController.text),
        ),
        const SizedBox(height: 16),
        LabeledTextField(
          label: ResetPasswordStrings.confirmPassword,
          controller: _confirmController,
          hintText: '••••••••',
          obscurable: true,
          prefixIcon: Icons.lock_outline_rounded,
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: AppTextStyles.bodySm(color: AppColors.error)),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _handleUpdate,
            child: const Text(ResetPasswordStrings.updatePassword),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(color: Color(0xFFE8F5EE), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 40),
        ),
        const SizedBox(height: 20),
        Text(ResetPasswordStrings.successTitle, style: AppTextStyles.h2(color: AppColors.textDark)),
        const SizedBox(height: 8),
        Text(ResetPasswordStrings.successBody, textAlign: TextAlign.center, style: AppTextStyles.bodySm()),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.accentOrange),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => context.go(AppRouter.login),
            child: Text(ResetPasswordStrings.goToLogin, style: AppTextStyles.button(color: AppColors.accentOrange)),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkExpired(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), shape: BoxShape.circle),
          child: const Icon(Icons.link_off_rounded, color: AppColors.error, size: 36),
        ),
        const SizedBox(height: 20),
        Text(ResetPasswordStrings.linkExpiredTitle, style: AppTextStyles.h2(color: AppColors.textDark)),
        const SizedBox(height: 8),
        Text(ResetPasswordStrings.linkExpiredBody, textAlign: TextAlign.center, style: AppTextStyles.bodySm()),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE2E2E2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => context.go(AppRouter.forgotPassword),
            child: Text(ResetPasswordStrings.requestNewLink, style: AppTextStyles.button(color: AppColors.textDark)),
          ),
        ),
      ],
    );
  }
}
