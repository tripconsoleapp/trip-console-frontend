import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Bottom tab bar shared by every main-shell screen (Home, My Trips,
/// Profile) once the user is past onboarding/auth.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.card_travel_rounded, label: 'My Trips'),
    (icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = index == currentIndex;
              final color = isActive ? AppColors.accentOrange : AppColors.textGrey;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: color, size: 24),
                      const SizedBox(height: 2),
                      Text(item.label, style: AppTextStyles.labelCaps(color: color).copyWith(fontSize: 11)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
