import 'package:flutter/material.dart';
import 'package:openhiit/core/models/timer_type.dart';

class EditorTab extends StatefulWidget {
  final TimerType? timer;

  const EditorTab({super.key, required this.timer});

  @override
  State<EditorTab> createState() => _EditorTabState();
}

class _EditorTabState extends State<EditorTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
    );
  }
}
