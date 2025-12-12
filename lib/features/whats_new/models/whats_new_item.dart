import 'package:flutter/material.dart';

class WhatsNewItem {
  final String title;
  final String description;
  final IconData icon;

  WhatsNewItem({
    required this.title,
    required this.description,
    this.icon = Icons.new_releases,
  });
}
