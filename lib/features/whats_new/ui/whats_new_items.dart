import 'package:flutter/material.dart';
import 'package:openhiit/features/whats_new/models/whats_new_item.dart';

class WhatsNewData {
  static const version = "1.6.0";

  static final List<WhatsNewItem> items = [
    WhatsNewItem(
      title: "UI Improvements",
      description:
          "The home screen and timer creation UI have been revamped for better usability.",
      icon: Icons.edit,
    ),
    WhatsNewItem(
      title: "Timer and Workout Combined",
      description:
          "Timers and workouts are now unified into a single timer entity for simplicity.",
      icon: Icons.timer,
    ),
  ];
}
