import 'package:flutter/material.dart';

/// Tinted circular icon container used as the hero visual on every
/// verification/status screen in the design (enter phone, verify OTP,
/// success/confirmation screens).
class IconBadgeCircle extends StatelessWidget {
  const IconBadgeCircle({
    super.key,
    required this.icon,
    this.diameter = 80,
    this.iconSize = 40,
    this.color = const Color(0xFFFF6B35),
    this.backgroundAlpha = 0.1,
  });

  final IconData icon;
  final double diameter;
  final double iconSize;
  final Color color;
  final double backgroundAlpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color.withValues(alpha: backgroundAlpha),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}
