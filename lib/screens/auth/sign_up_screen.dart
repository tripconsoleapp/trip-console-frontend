import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/email_auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/labeled_text_field.dart';
import '../../widgets/password_strength_meter.dart';
import '../../widgets/social_login_buttons.dart';

/// Email/password account creation — Full Name, Email, Mobile, Password,
/// Confirm Password, Terms agreement, then on to Role Selection.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;
  String? _formError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount(EmailAuthProvider auth) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _formError = SignUpStrings.invalidEmail);
      return;
    }
    if (password.length < 8) {
      setState(() => _formError = SignUpStrings.passwordTooShort);
      return;
    }
    if (password != _confirmPasswordController.text) {
      setState(() => _formError = SignUpStrings.passwordsDontMatch);
      return;
    }
    if (!_agreedToTerms) {
      setState(() => _formError = SignUpStrings.mustAgreeToTerms);
      return;
    }
    setState(() => _formError = null);

    final success = await auth.signUp(name: _nameController.text.trim(), email: email, password: password);
    if (!mounted) return;
    if (success) context.push(AppRouter.roleSelection);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<EmailAuthProvider>();
    final isLoading = auth.status == EmailAuthStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text('Create Account', style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(SignUpStrings.title, style: AppTextStyles.h2(color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text(SignUpStrings.subtitle, style: AppTextStyles.bodyLg(color: AppColors.textGrey)),
              const SizedBox(height: 24),
              LabeledTextField(label: SignUpStrings.fullName, controller: _nameController, hintText: SignUpStrings.fullNameHint),
              const SizedBox(height: 16),
              LabeledTextField(
                label: SignUpStrings.emailAddress,
                controller: _emailController,
                hintText: SignUpStrings.emailHint,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: SignUpStrings.mobileNumber,
                controller: _mobileController,
                hintText: SignUpStrings.mobileHint,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 4),
              Text(SignUpStrings.mobileNote, style: AppTextStyles.bodySm()),
              const SizedBox(height: 16),
              LabeledTextField(label: SignUpStrings.password, controller: _passwordController, hintText: '••••••••'),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _passwordController,
                builder: (_, __) => PasswordStrengthMeter(password: _passwordController.text),
              ),
              const SizedBox(height: 16),
              LabeledTextField(label: SignUpStrings.confirmPassword, controller: _confirmPasswordController, hintText: '••••••••'),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    activeColor: AppColors.accentOrange,
                    onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodySm(color: AppColors.textGrey),
                          children: const [
                            TextSpan(text: SignUpStrings.termsPrefix),
                            TextSpan(text: SignUpStrings.termsOfService, style: TextStyle(color: AppColors.accentOrange, decoration: TextDecoration.underline)),
                            TextSpan(text: SignUpStrings.termsJoiner),
                            TextSpan(text: SignUpStrings.privacyPolicy, style: TextStyle(color: AppColors.accentOrange, decoration: TextDecoration.underline)),
                            TextSpan(text: SignUpStrings.termsSuffix),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_formError != null || auth.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(_formError ?? auth.errorMessage!, style: AppTextStyles.bodySm(color: AppColors.error)),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _handleCreateAccount(auth),
                  child: isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.backgroundWhite))
                      : const Text(SignUpStrings.createAccount),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE2E2E2))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(SignUpStrings.or, style: AppTextStyles.labelCaps()),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE2E2E2))),
                ],
              ),
              const SizedBox(height: 20),
              const SocialLoginButtons(),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodySm(color: AppColors.textGrey),
                    children: [
                      const TextSpan(text: SignUpStrings.haveAccountPrefix),
                      TextSpan(
                        text: SignUpStrings.logIn,
                        style: const TextStyle(color: AppColors.accentOrange, fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()..onTap = () => context.pushReplacement(AppRouter.login),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
