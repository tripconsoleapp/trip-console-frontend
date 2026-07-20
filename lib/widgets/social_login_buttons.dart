import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Google/Apple sign-in row shown under the primary action on both the
/// Sign Up and Login screens.
class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key, this.onGoogleTap, this.onAppleTap});

  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SocialButton(label: 'Google', icon: Icons.g_mobiledata_rounded, onTap: onGoogleTap)),
        const SizedBox(width: 12),
        Expanded(child: _SocialButton(label: 'Apple', icon: Icons.apple_rounded, onTap: onAppleTap)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label, required this.icon, this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFE2E2E2)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.textDark),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
        ],
      ),
    );
  }
}
