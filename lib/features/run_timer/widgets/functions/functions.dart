import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/features/run_timer/widgets/models/timer_list_tile_model.dart';

/// Generates a list of [ListTileModel] objects representing the workout intervals
/// based on the provided list of [exercises] and the [Workout] argument.
///
/// Parameters:
///   - [exercises]: The list of exercises to be included in the workout intervals.
///   - [workoutArgument]: The 'Workout' object containing workout configuration.
///
/// Returns:
///   - A list of [ListTileModel] objects representing each interval in the workout.
///
List<TimerListTileModel> listItems(
    TimerType timer, List<IntervalType> intervals) {
  List<TimerListTileModel> listItems = [];

  const nonActiveNames = {"rest", "get ready", "warmup", "cooldown", "break"};
  final totalSets =
      (timer.timeSettings.restarts > 0 ? timer.timeSettings.restarts + 1 : 1);

  int workIntervalIndex = 0;
  int currentSet = 1;
  bool setIncrementPending = false;

  for (var interval in intervals) {
    final isActive = !nonActiveNames.contains(interval.name.toLowerCase());
    final isBetweenSets = setIncrementPending && !isActive;

    if (setIncrementPending) {
      if (!isActive || workIntervalIndex >= timer.activeIntervals) {
        if (currentSet < totalSets) {
          currentSet += 1;
        }
        workIntervalIndex = 0;
        setIncrementPending = false;
      }
    }

    if (isActive) {
      workIntervalIndex += 1;
      if (workIntervalIndex == timer.activeIntervals &&
          currentSet < totalSets) {
        setIncrementPending = true;
      }
    }

    listItems.add(
      TimerListTileModel(
        action: interval.name == "Break" || isBetweenSets
            ? "Rest between sets"
            : interval.name,
        showMinutes: timer.showMinutes,
        interval: isActive ? workIntervalIndex : 0,
        total: timer.activeIntervals,
        seconds: interval.time,
        set: currentSet,
        totalSets: totalSets,
      ),
    );
  }

  return listItems;
}

/// Returns the seconds left in the whole workout: the time remaining in the
/// [currentInterval] plus the full length of every interval after it.
int workoutSecondsRemaining(List<IntervalType> intervals, int currentInterval,
    int currentMicroSeconds) {
  if (currentInterval >= intervals.length) {
    return 0;
  }
  final later = intervals
      .skip(currentInterval + 1)
      .fold<int>(0, (sum, interval) => sum + interval.time);
  return later + (currentMicroSeconds / Duration.microsecondsPerSecond).round();
}

/// Formats [totalSeconds] as m:ss, or h:mm:ss when an hour or longer.
String formatDuration(int totalSeconds) {
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
  if (hours > 0) {
    return "$hours:${minutes.toString().padLeft(2, '0')}:$seconds";
  }
  return "$minutes:$seconds";
}

/// Builds the overall progress label, e.g. "Total 7:26 / 20:00".
String totalTimeString(List<IntervalType> intervals, int currentInterval,
    int currentMicroSeconds) {
  final total = intervals.fold<int>(0, (sum, interval) => sum + interval.time);
  if (total == 0) {
    return "";
  }
  final remaining =
      workoutSecondsRemaining(intervals, currentInterval, currentMicroSeconds);
  final elapsed = (total - remaining).clamp(0, total);
  return "Total ${formatDuration(elapsed)} / ${formatDuration(total)}";
}
