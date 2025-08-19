import 'package:background_hiit_timer/models/interval_type.dart';

int getTotalTime(List<IntervalType> intervals) {
  return intervals.fold(0, (previous, interval) => previous + interval.time);
}
