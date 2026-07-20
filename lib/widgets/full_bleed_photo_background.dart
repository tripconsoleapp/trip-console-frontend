import 'package:flutter/material.dart';

/// Full-screen photo with a gradient scrim for text legibility.
/// Every hero/onboarding screen in the design uses this exact pattern —
/// an edge-to-edge background image plus a top-to-bottom (or reversed)
/// gradient overlay — just with different gradient stops.
class FullBleedPhotoBackground extends StatelessWidget {
  const FullBleedPhotoBackground({
    super.key,
    required this.imageAsset,
    required this.gradientColors,
    this.gradientStops,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  final String imageAsset;
  final List<Color> gradientColors;
  final List<double>? gradientStops;
  final Alignment begin;
  final Alignment end;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(imageAsset, fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: gradientColors,
              stops: gradientStops,
            ),
          ),
        ),
      ],
    );
  }
}
