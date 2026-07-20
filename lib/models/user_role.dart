import 'package:flutter/material.dart';

/// The three ways someone can use TripConsole — chosen once at signup and
/// determining which home experience they land on.
enum UserRole { organizer, operator, fieldCoordinator }

extension UserRoleInfo on UserRole {
  String get label => switch (this) {
        UserRole.organizer => 'Organizer',
        UserRole.operator => 'Operator',
        UserRole.fieldCoordinator => 'Field Coordinator',
      };

  String get description => switch (this) {
        UserRole.organizer => 'Planning trips for groups',
        UserRole.operator => 'Managing fleet and logistics',
        UserRole.fieldCoordinator => 'On-ground operations support',
      };

  IconData get icon => switch (this) {
        UserRole.organizer => Icons.groups_rounded,
        UserRole.operator => Icons.local_shipping_rounded,
        UserRole.fieldCoordinator => Icons.location_on_rounded,
      };
}
