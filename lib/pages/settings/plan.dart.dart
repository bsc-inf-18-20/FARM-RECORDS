import 'package:flutter/material.dart';

class Plan {
  final String title; // Name of the plan (e.g., Free, Pro, Enterprise)
  final String description; // Details about the plan's features
  final String
      actionButtonText; // Text for the action button (e.g., Select, Contact Us)
  final VoidCallback onPressed; // Callback for the button action

  Plan({
    required this.title,
    required this.description,
    required this.actionButtonText,
    required this.onPressed,
  });
}
