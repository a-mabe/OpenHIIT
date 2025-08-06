import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';

class ListIntervals extends StatefulWidget {
  final List<IntervalType> intervals;

  const ListIntervals({super.key, required this.intervals});

  @override
  State<ListIntervals> createState() => _ListIntervalsState();
}

class _ListIntervalsState extends State<ListIntervals> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
