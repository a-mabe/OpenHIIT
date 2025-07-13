import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:openhiit/core/db/repositories/interval_repository.dart';
import 'package:openhiit/core/db/repositories/timer_repository.dart';
import 'package:openhiit/core/db/repositories/timer_time_settings_repository.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> warmupMigration(
    List<TimerType> timers,
    IntervalRepository intervalRepository,
    TimerRepository timerRepository,
    TimerTimeSettingsRepository timerTimeSettingsRepository) async {
  final prefs = await SharedPreferences.getInstance();
  bool hasRunWarmupMigration = prefs.getBool('hasRunWarmupMigration') ?? false;

  if (!hasRunWarmupMigration) {
    for (var timer in timers) {
      // Grab time settings from the timer
      timer.timeSettings = (await timerTimeSettingsRepository
          .getTimeSettingsByTimerId(timer.id))!;

      if (timer.timeSettings.warmupTime > 0) {
        // Retrieve the intervals for the timer
        List<IntervalType> intervals =
            await intervalRepository.getIntervalsByTimerId(timer.id);

        // Find the warmup interval
        final warmupInterval = intervals.firstWhere(
          (interval) => interval.name == "Warmup",
          orElse: () => IntervalType(
              id: "",
              workoutId: "",
              time: 0,
              name: "",
              color: 0,
              intervalIndex: 0,
              startSound: "",
              halfwaySound: "",
              countdownSound: "",
              endSound: ""),
        );

        if (warmupInterval.name == "Warmup") {
          // Create a new rest interval
          final restInterval = IntervalType(
            id: "${timer.id}_warmup_rest",
            workoutId: timer.id,
            time: timer.timeSettings.restTime,
            name: "Rest",
            color: timer.color,
            intervalIndex: warmupInterval.intervalIndex + 1,
            startSound: timer.soundSettings.restSound,
            countdownSound: timer.soundSettings.countdownSound,
            halfwaySound: "",
            endSound: "",
          );

          intervals.insert(warmupInterval.intervalIndex + 1, restInterval);

          // Update indices for subsequent intervals
          for (var interval in intervals) {
            if (interval.intervalIndex >= restInterval.intervalIndex &&
                interval.id != restInterval.id) {
              interval.intervalIndex += 1;
            }
          }

          await intervalRepository.insertInterval(restInterval);
          await intervalRepository.updateIntervals(intervals);
        }
      }
    }
    await prefs.setBool('hasRunWarmupMigration', true);
  }
}
