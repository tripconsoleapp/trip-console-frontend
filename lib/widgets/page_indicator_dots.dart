import 'package:flutter/material.dart';

/// Dot pagination used on every swipeable carousel in the design
/// (onboarding slides, image galleries on hotel/activity detail screens).
class PageIndicatorDots extends StatelessWidget {
  const PageIndicatorDots({
    super.key,
    required this.count,
    required this.activeIndex,
    this.dotColor = const Color(0x66FFFFFF),
    this.activeColor = const Color(0xFFFF6B35),
    this.dotSize = 6,
    this.activeWidth = 24,
    this.gap = 8,
  });

  final int count;
  final int activeIndex;
  final Color dotColor;
  final Color activeColor;
  final double dotSize;
  final double activeWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return Padding(
          padding: EdgeInsets.only(right: index == count - 1 ? 0 : gap),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isActive ? activeWidth : dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: isActive ? activeColor : dotColor,
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
        );
      }),
    );
  }
}
