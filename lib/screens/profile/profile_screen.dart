import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/app_bottom_nav_bar.dart';

/// Profile — account details, security, notification preferences, support
/// links, and account-level danger-zone actions.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _twoFactorEnabled = false;
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _smsEnabled = false;

  // TODO(api): replace with the organizer's real profile from the auth/profile service.
  static const _name = 'Rahul Menon';
  static const _email = 'rahul.menon@stmarysschool.edu';
  static const _mobile = '+91 98765 43210';
  static const _city = 'Kochi, Kerala';
  static const _institution = "St. Mary's Higher Secondary School";

  Future<void> _confirmAndRun({
    required String title,
    required String body,
    required String confirmLabel,
    required VoidCallback onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: AppTextStyles.h3(color: AppColors.textDark)),
        content: Text(body, style: AppTextStyles.bodySm(color: AppColors.textGrey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ProfileStrings.cancel, style: AppTextStyles.bodySm())),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel, style: AppTextStyles.bodySm(color: AppColors.error).copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed == true) onConfirm();
  }

  void _handleLogout() {
    context.go(AppRouter.login);
  }

  void _handleDeleteAccount() {
    context.go(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) context.go(AppRouter.home);
          if (index == 1) context.go(AppRouter.myTrips);
        },
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(ProfileStrings.title, style: AppTextStyles.h2(color: AppColors.textDark)),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.accentOrange,
                  child: Text(
                    _name.split(' ').map((w) => w[0]).take(2).join(),
                    style: AppTextStyles.h2(color: AppColors.backgroundWhite),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_name, style: AppTextStyles.h3(color: AppColors.textDark)),
                      const SizedBox(height: 2),
                      Text(_email, style: AppTextStyles.bodySm(), overflow: TextOverflow.ellipsis),
                      Text(_mobile, style: AppTextStyles.bodySm()),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _SectionCard(
              title: ProfileStrings.accountDetails,
              children: [
                _InfoRow(label: ProfileStrings.fullName, value: _name),
                _InfoRow(label: ProfileStrings.email, value: _email),
                _InfoRow(label: ProfileStrings.mobile, value: _mobile),
                _InfoRow(label: ProfileStrings.city, value: _city),
                _InfoRow(label: ProfileStrings.institution, value: _institution, isLast: true),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: ProfileStrings.security,
              children: [
                _ActionRow(icon: Icons.lock_outline_rounded, label: ProfileStrings.changePassword, onTap: () => context.push(AppRouter.forgotPassword)),
                _ToggleRow(
                  icon: Icons.verified_user_outlined,
                  label: ProfileStrings.twoFactorAuth,
                  value: _twoFactorEnabled,
                  onChanged: (v) => setState(() => _twoFactorEnabled = v),
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: ProfileStrings.preferences,
              children: [
                _ToggleRow(
                  icon: Icons.notifications_none_rounded,
                  label: ProfileStrings.pushNotifications,
                  value: _pushEnabled,
                  onChanged: (v) => setState(() => _pushEnabled = v),
                ),
                _ToggleRow(
                  icon: Icons.mail_outline_rounded,
                  label: ProfileStrings.emailAlerts,
                  value: _emailEnabled,
                  onChanged: (v) => setState(() => _emailEnabled = v),
                ),
                _ToggleRow(
                  icon: Icons.sms_outlined,
                  label: ProfileStrings.smsAlerts,
                  value: _smsEnabled,
                  onChanged: (v) => setState(() => _smsEnabled = v),
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: ProfileStrings.supportLegal,
              children: [
                _ActionRow(icon: Icons.help_outline_rounded, label: ProfileStrings.helpCenter, onTap: () {}),
                _ActionRow(icon: Icons.description_outlined, label: ProfileStrings.terms, onTap: () {}),
                _ActionRow(icon: Icons.privacy_tip_outlined, label: ProfileStrings.privacy, onTap: () {}),
                _InfoRow(label: ProfileStrings.appVersion, value: '1.0.0', isLast: true),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: ProfileStrings.dangerZone,
              titleColor: AppColors.error,
              children: [
                _ActionRow(
                  icon: Icons.logout_rounded,
                  label: ProfileStrings.logout,
                  onTap: () => _confirmAndRun(
                    title: ProfileStrings.logoutConfirmTitle,
                    body: ProfileStrings.logoutConfirmBody,
                    confirmLabel: ProfileStrings.logout,
                    onConfirm: _handleLogout,
                  ),
                ),
                _ActionRow(
                  icon: Icons.delete_outline_rounded,
                  label: ProfileStrings.deleteAccount,
                  color: AppColors.error,
                  isLast: true,
                  onTap: () => _confirmAndRun(
                    title: ProfileStrings.deleteConfirmTitle,
                    body: ProfileStrings.deleteConfirmBody,
                    confirmLabel: ProfileStrings.deleteAccount,
                    onConfirm: _handleDeleteAccount,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children, this.titleColor});

  final String title;
  final List<Widget> children;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelCaps(color: titleColor ?? AppColors.textGrey)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E2E2)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.isLast = false});

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySm()),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.label, required this.onTap, this.color, this.isLast = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final rowColor = color ?? AppColors.textDark;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: rowColor),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTextStyles.bodySm(color: rowColor).copyWith(fontWeight: FontWeight.w600))),
            Icon(Icons.chevron_right_rounded, size: 18, color: color ?? AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.icon, required this.label, required this.value, required this.onChanged, this.isLast = false});

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textDark),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600))),
          Switch(value: value, activeThumbColor: AppColors.accentOrange, onChanged: onChanged),
        ],
      ),
    );
  }
}
