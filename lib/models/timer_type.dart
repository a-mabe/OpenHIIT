import 'package:openhiit/models/interval_type.dart';

class IntervalTimer {
  String name;
  int color;
  String id;
  List<IntervalType> intervals;
  int iterations;

  IntervalTimer({
    required this.name,
    required this.color,
    required this.id,
    required this.intervals,
    required this.iterations,
  });
}
