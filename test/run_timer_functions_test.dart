import 'package:flutter_test/flutter_test.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/core/utils/interval_calculation.dart';
import 'package:openhiit/features/run_timer/widgets/functions/functions.dart';

TimerType buildTimer({required int restarts, int breakTime = 30}) {
  final timer = TimerType.empty()
    ..id = "timer-1"
    ..name = "Sets Tester"
    ..activeIntervals = 2;
  timer.timeSettings
    ..getReadyTime = 10
    ..workTime = 10
    ..restTime = 5
    ..breakTime = breakTime
    ..restarts = restarts;
  return timer;
}

void main() {
  group('listItems', () {
    test('should label each interval with its set number', () {
      final timer = buildTimer(restarts: 2);
      final items = listItems(timer, generateIntervalsFromTimer(timer));

      expect(items.map((i) => i.action).toList(), [
        "Get Ready", //
        "Work", "Rest", "Work", "Rest between sets", //
        "Work", "Rest", "Work", "Rest between sets", //
        "Work", "Rest", "Work",
      ]);
      expect(items.map((i) => i.set).toList(),
          [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3]);
      expect(items.map((i) => i.interval).toList(),
          [0, 1, 0, 2, 0, 1, 0, 2, 0, 1, 0, 2]);
      expect(items.first.setString(), "Set 1 of 3 • 2 left");
      expect(items.last.setString(), "Set 3 of 3 • last set");
      expect(items[4].nextSetString(), "Next: Set 2 of 3");
      expect(items[1].nextSetString(), isEmpty);
    });

    test('should treat plain rest between sets as rest between sets', () {
      final timer = buildTimer(restarts: 1, breakTime: 0);
      final items = listItems(timer, generateIntervalsFromTimer(timer));

      expect(items[4].action, "Rest between sets");
      expect(items[5].set, 2);
    });

    test('should hide the set label for a single set', () {
      final timer = buildTimer(restarts: 0);
      final items = listItems(timer, generateIntervalsFromTimer(timer));

      expect(items.every((i) => i.setString().isEmpty), isTrue);
    });
  });

  group('total time', () {
    test('should count down the whole workout', () {
      final timer = buildTimer(restarts: 1);
      final intervals = generateIntervalsFromTimer(timer);
      // Get Ready 10, Work 10, Rest 5, Work 10, Break 30, Work 10, Rest 5,
      // Work 10.
      expect(workoutSecondsRemaining(intervals, 0, 10000000), 90);
      expect(workoutSecondsRemaining(intervals, 4, 12000000), 37);
      expect(workoutSecondsRemaining(intervals, intervals.length, 0), 0);
      expect(totalTimeString(intervals, 4, 12000000), "Total 0:53 / 1:30");
    });

    test('should format durations as m:ss or h:mm:ss', () {
      expect(formatDuration(0), "0:00");
      expect(formatDuration(446), "7:26");
      expect(formatDuration(3725), "1:02:05");
    });
  });
}
