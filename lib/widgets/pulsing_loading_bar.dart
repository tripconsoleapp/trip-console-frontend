import 'package:flutter/material.dart';

/// A thin pulsing progress bar with a caption underneath.
/// Reused across every "processing" style screen in the design (splash,
/// payment processing, itinerary generating, activity booking, etc.) —
/// not just the splash screen — so it lives in widgets/ rather than inline.
class PulsingLoadingBar extends StatefulWidget {
  const PulsingLoadingBar({
    super.key,
    required this.message,
    this.trackColor = const Color(0x33FFFFFF),
    this.fillColor = Colors.white,
    this.textStyle,
    this.width = 48,
  });

  final String message;
  final Color trackColor;
  final Color fillColor;
  final TextStyle? textStyle;
  final double width;

  @override
  State<PulsingLoadingBar> createState() => _PulsingLoadingBarState();
}

class _PulsingLoadingBarState extends State<PulsingLoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            width: widget.width,
            height: 2,
            child: Stack(
              children: [
                Container(color: widget.trackColor),
                AnimatedBuilder(
                  animation: _opacity,
                  builder: (_, __) => FractionallySizedBox(
                    widthFactor: 0.4,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: widget.fillColor.withValues(alpha: _opacity.value),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(widget.message, style: widget.textStyle),
      ],
    );
  }
}
