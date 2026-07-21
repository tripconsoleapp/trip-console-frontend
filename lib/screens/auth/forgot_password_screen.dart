import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/icon_badge_circle.dart';
import '../../widgets/labeled_text_field.dart';

/// Password recovery — send a reset link to the registered email, or an
/// OTP to the registered phone, chosen via underline tabs.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _error;
  bool _linkSent = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_tabController.index == 0) {
      final email = _emailController.text.trim();
      if (!email.contains('@') || !email.contains('.')) {
        setState(() => _error = ForgotPasswordStrings.invalidEmail);
        return;
      }
      // TODO(backend): call FirebaseAuth.sendPasswordResetEmail(email).
      setState(() {
        _error = null;
        _linkSent = true;
      });
    } else {
      final digits = _phoneController.text.trim();
      if (digits.length != 10) {
        setState(() => _error = ForgotPasswordStrings.invalidPhone);
        return;
      }
      // TODO(backend): trigger phone-OTP recovery, then route to OTP entry.
      setState(() => _error = null);
      context.push(AppRouter.resetPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmailTab = _tabController.index == 0;

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
        title: Text(ForgotPasswordStrings.appBarTitle, style: AppTextStyles.h3(color: AppColors.textDark)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const IconBadgeCircle(icon: Icons.lock_reset_rounded, diameter: 64, iconSize: 32),
              const SizedBox(height: 20),
              Text(ForgotPasswordStrings.title, style: AppTextStyles.h2(color: AppColors.textDark)),
              const SizedBox(height: 8),
              Text(
                isEmailTab ? ForgotPasswordStrings.subtitleEmail : ForgotPasswordStrings.subtitlePhone,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm(),
              ),
              const SizedBox(height: 20),
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.accentOrange,
                indicatorWeight: 2,
                labelColor: AppColors.accentOrange,
                unselectedLabelColor: AppColors.textGrey,
                labelStyle: AppTextStyles.bodySm().copyWith(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(height: 40, text: ForgotPasswordStrings.emailTab),
                  Tab(height: 40, text: ForgotPasswordStrings.phoneTab),
                ],
              ),
              const SizedBox(height: 20),
              if (isEmailTab)
                LabeledTextField(
                  label: ForgotPasswordStrings.registeredEmail,
                  controller: _emailController,
                  hintText: ForgotPasswordStrings.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                )
              else
                LabeledTextField(
                  label: ForgotPasswordStrings.registeredPhone,
                  controller: _phoneController,
                  hintText: ForgotPasswordStrings.phoneHint,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.smartphone_rounded,
                ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_error!, style: AppTextStyles.bodySm(color: AppColors.error)),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text(isEmailTab ? ForgotPasswordStrings.sendResetLink : ForgotPasswordStrings.sendOtp),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  if (context.canPop()) context.pop();
                },
                child: Text(
                  ForgotPasswordStrings.backToLogin,
                  style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (_linkSent) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.mintGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.mark_email_read_outlined, color: AppColors.primaryGreen, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ForgotPasswordStrings.checkInboxTitle,
                              style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${ForgotPasswordStrings.checkInboxPrefix}${_emailController.text.trim()}.',
                              style: AppTextStyles.bodySm(),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: _handleSubmit,
                              child: Text(
                                ForgotPasswordStrings.resendEmail,
                                style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
