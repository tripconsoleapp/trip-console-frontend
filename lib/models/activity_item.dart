import 'package:flutter/material.dart';

/// One entry in the Home dashboard's Recent Activity feed — a status
/// change on one of the organizer's trips.
class ActivityItem {
  const ActivityItem({
    required this.tripName,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.timeLabel,
  });

  final String tripName;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String timeLabel;
}
