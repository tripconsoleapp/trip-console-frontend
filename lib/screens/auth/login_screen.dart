import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/email_auth_provider.dart';
import '../../providers/phone_auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/labeled_text_field.dart';
import '../../widgets/social_login_buttons.dart';

/// Sign-in with two methods on one screen, switchable via tabs: Email +
/// Password, or Phone + OTP.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  String? _phoneValidationError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin(EmailAuthProvider auth) async {
    final success = await auth.logIn(email: _emailController.text.trim(), password: _passwordController.text);
    if (!mounted) return;
    if (success) context.go(AppRouter.home);
  }

  Future<void> _handleSendOtp(PhoneAuthProvider auth) async {
    final digits = _mobileController.text.trim();
    if (digits.length != 10) {
      setState(() => _phoneValidationError = EnterPhoneStrings.invalidNumber);
      return;
    }
    setState(() => _phoneValidationError = null);
    await auth.sendOtp('${EnterPhoneStrings.countryCode}$digits');
    if (!mounted) return;
    if (auth.status == PhoneAuthStatus.codeSent) context.push(AppRouter.verifyOtp);
  }

  @override
  Widget build(BuildContext context) {
    final emailAuth = context.watch<EmailAuthProvider>();
    final phoneAuth = context.watch<PhoneAuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(LoginStrings.appName, style: AppTextStyles.h1(color: AppColors.textDark).copyWith(fontSize: 28)),
              const SizedBox(height: 2),
              Text(LoginStrings.welcomeBack, style: AppTextStyles.bodyLg(color: AppColors.textGrey)),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(color: AppColors.accentOrange, borderRadius: BorderRadius.circular(9)),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.backgroundWhite,
                  unselectedLabelColor: AppColors.textDark,
                  labelStyle: AppTextStyles.bodySm().copyWith(fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(height: 40, text: LoginStrings.emailTab),
                    Tab(height: 40, text: LoginStrings.phoneTab),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _tabController,
                builder: (_, __) => IndexedStack(
                  index: _tabController.index,
                  children: [
                    _EmailLoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      isLoading: emailAuth.status == EmailAuthStatus.loading,
                      errorMessage: emailAuth.errorMessage,
                      onSubmit: () => _handleEmailLogin(emailAuth),
                    ),
                    _PhoneLoginForm(
                      mobileController: _mobileController,
                      isLoading: phoneAuth.status == PhoneAuthStatus.loading,
                      errorMessage: _phoneValidationError ?? phoneAuth.errorMessage,
                      onSubmit: () => _handleSendOtp(phoneAuth),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE2E2E2))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(LoginStrings.or, style: AppTextStyles.labelCaps()),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE2E2E2))),
                ],
              ),
              const SizedBox(height: 20),
              const SocialLoginButtons(),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodySm(color: AppColors.textGrey),
                  children: [
                    const TextSpan(text: LoginStrings.noAccountPrefix),
                    TextSpan(
                      text: LoginStrings.signUp,
                      style: const TextStyle(color: AppColors.accentOrange, fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()..onTap = () => context.pushReplacement(AppRouter.signUp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailLoginForm extends StatelessWidget {
  const _EmailLoginForm({
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.errorMessage,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledTextField(label: LoginStrings.email, controller: emailController, hintText: LoginStrings.emailHint, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        LabeledTextField(label: LoginStrings.password, controller: passwordController, hintText: '••••••••'),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(LoginStrings.forgotPassword, style: AppTextStyles.bodySm(color: AppColors.accentOrange)),
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 4),
          Text(errorMessage!, style: AppTextStyles.bodySm(color: AppColors.error)),
        ],
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.backgroundWhite))
                : const Text(LoginStrings.logIn),
          ),
        ),
      ],
    );
  }
}

class _PhoneLoginForm extends StatelessWidget {
  const _PhoneLoginForm({
    required this.mobileController,
    required this.isLoading,
    required this.errorMessage,
    required this.onSubmit,
  });

  final TextEditingController mobileController;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(EnterPhoneStrings.label, style: AppTextStyles.labelCaps()),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(EnterPhoneStrings.countryCode, style: TextStyle(fontSize: 16, color: AppColors.textDark, fontWeight: FontWeight.w600)),
              ),
              Container(width: 1, height: 24, color: const Color(0xFFE2BFB3)),
              Expanded(
                child: TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontSize: 16, color: AppColors.textDark),
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: EnterPhoneStrings.placeholder,
                    hintStyle: TextStyle(color: Color(0xFFC6C6C6)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(errorMessage!, style: AppTextStyles.bodySm(color: AppColors.error)),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.backgroundWhite))
                : const Text(EnterPhoneStrings.sendOtp),
          ),
        ),
      ],
    );
  }
}
