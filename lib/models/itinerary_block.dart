import 'package:flutter/material.dart';

enum BlockType { travel, activity, meal, rest }

extension BlockTypeInfo on BlockType {
  String get label => switch (this) {
        BlockType.travel => 'Travel',
        BlockType.activity => 'Activity',
        BlockType.meal => 'Meal',
        BlockType.rest => 'Rest',
      };

  IconData get icon => switch (this) {
        BlockType.travel => Icons.directions_car_rounded,
        BlockType.activity => Icons.hiking_rounded,
        BlockType.meal => Icons.restaurant_rounded,
        BlockType.rest => Icons.hotel_rounded,
      };
}

/// One timeline entry on a day of the generated itinerary — a leg of
/// travel, a booked activity, a meal, or a rest/check-in block.
class ItineraryBlock {
  const ItineraryBlock({
    required this.type,
    required this.time,
    required this.title,
    required this.subtitle,
    this.cost,
  });

  final BlockType type;
  final String time;
  final String title;
  final String subtitle;
  final int? cost;

  ItineraryBlock copyWith({BlockType? type, String? time, String? title, String? subtitle, int? cost}) {
    return ItineraryBlock(
      type: type ?? this.type,
      time: time ?? this.time,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      cost: cost ?? this.cost,
    );
  }
}
