import 'package:flutter/material.dart';
import 'package:openhiit/core/models/timer_type.dart';

class GeneralTab extends StatefulWidget {
  final TimerType? timer;

  const GeneralTab({super.key, required this.timer});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
    );
  }
}
