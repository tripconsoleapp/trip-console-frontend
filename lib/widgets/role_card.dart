import 'package:flutter/material.dart';

import '../models/user_role.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Selectable card for one role option on the Role Selection screen.
class RoleCard extends StatelessWidget {
  const RoleCard({super.key, required this.role, required this.selected, required this.onTap});

  final UserRole role;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.accentOrange : const Color(0xFFE2E2E2), width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(role.icon, color: AppColors.textDark, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role.label, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(role.description, style: AppTextStyles.bodySm()),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.accentOrange, size: 22),
          ],
        ),
      ),
    );
  }
}
