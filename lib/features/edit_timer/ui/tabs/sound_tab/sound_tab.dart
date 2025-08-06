import 'package:flutter/material.dart';
import 'package:openhiit/core/models/timer_type.dart';

class SoundTab extends StatefulWidget {
  final TimerType? timer;

  const SoundTab({super.key, required this.timer});

  @override
  State<SoundTab> createState() => _SoundTabState();
}

class _SoundTabState extends State<SoundTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
    );
  }
}
