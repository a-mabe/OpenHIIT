import 'package:flutter/material.dart';
import 'package:openhiit/features/whats_new/models/whats_new_item.dart';

class WhatsNewData {
  static const version = "1.7.0";

  static final List<WhatsNewItem> items = [
    WhatsNewItem(
      title: "Swipe to Delete",
      description: "Remove timers by swiping left.",
      icon: Icons.swipe_left,
    ),
    WhatsNewItem(
      title: "Break Sound",
      description: "Set a custom break sound.",
      icon: Icons.music_note,
    ),
    WhatsNewItem(
      title: "Settings Page",
      description: "Adjust app preferences and appearance.",
      icon: Icons.settings,
    ),
  ];
}
