import 'package:flutter/material.dart';

import '../../models/user_role.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

/// Shown when a role's home experience hasn't been designed yet
/// (Operator, Field Coordinator) — swap for the real dashboard once
/// those Figma frames arrive.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(role.icon, size: 48, color: AppColors.accentOrange),
                const SizedBox(height: 20),
                Text('${role.label} experience', style: AppTextStyles.h2(color: AppColors.textDark), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  "This role's screens haven't been designed yet.",
                  style: AppTextStyles.bodyLg(color: AppColors.textGrey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
