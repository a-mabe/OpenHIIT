import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/core/db/repositories/deprecated_workout_repository.dart';
import 'package:openhiit/core/db/repositories/interval_repository.dart';
import 'package:openhiit/core/db/repositories/timer_repository.dart';
import 'package:openhiit/core/db/repositories/timer_sound_settings_repository.dart';
import 'package:openhiit/core/db/repositories/timer_time_settings_repository.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/interval_provider/interval_provider.dart';
import 'package:openhiit/core/providers/timer_provider/migrations/migration_1.dart';
import 'package:openhiit/core/providers/timer_provider/migrations/migration_2.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/core/utils/interval_calculation.dart';
import 'package:uuid/uuid.dart';

class TimerProvider extends ChangeNotifier {
  // Deprecated - Included to migrate old data
  final WorkoutRepository _workoutRepository = WorkoutRepository();

  List<TimerType> _timers = [];
  List<TimerType> get timers => _timers;
  final TimerRepository _timerRepository = TimerRepository();

  final IntervalRepository _intervalRepository = IntervalRepository();

  final TimerTimeSettingsRepository _timerTimeSettingsRepository =
      TimerTimeSettingsRepository();
  final TimerSoundSettingsRepository _timerSoundSettingsRepository =
      TimerSoundSettingsRepository();

  late IntervalProvider _intervalProvider;

  void setIntervalProvider(IntervalProvider provider) {
    _intervalProvider = provider;
  }

  Future<List<TimerType>> loadTimers() async {
    try {
      final workouts = await _workoutRepository.getAllWorkouts();

      if (workouts.isNotEmpty) {
        Log.info("Migrating old workouts to timers and intervals...");
        await workoutsMigration(
            workouts, _intervalRepository, _timerRepository);
        Log.info("Migration completed successfully.");

        try {
          await _workoutRepository.deleteAllWorkouts();
          Log.info("Old workouts deleted after migration.");
        } catch (error) {
          Log.error("Error deleting old workouts: $error");
        }
      }

      // Run warmup migration
      await warmupMigration(
        _timers,
        _intervalRepository,
        _timerRepository,
        _timerTimeSettingsRepository,
      );

      // Load timers
      _timers = await _timerRepository.getAllTimers();
      _timers.sort((a, b) => a.timerIndex.compareTo(b.timerIndex));
      notifyListeners();

      return _timers;
    } catch (error, stackTrace) {
      Log.error("Error loading timers: $error\n$stackTrace");
      rethrow; // rethrow so FutureBuilder sees it and shows error UI
    }
  }

  Future<void> updateTimerOrder(List<TimerType> timers) async {
    _timers = timers;

    for (int i = 0; i < _timers.length; i++) {
      _timers[i].timerIndex = i;
    }

    await _timerRepository.updateTimers(_timers);
    notifyListeners();
  }

  Future<void> pushTimer(TimerType timer) async {
    _timers.insert(0, timer);
    await _timerRepository.insertTimer(timer);
    await _timerTimeSettingsRepository.insertTimeSettings(timer.timeSettings);
    await _timerSoundSettingsRepository
        .insertSoundSettings(timer.soundSettings);
    await updateTimerOrder(_timers);
    await pushIntervalsFromTimer(timer);
    notifyListeners();
  }

  Future<void> pushTimerCopy(TimerType timer) async {
    timer.name = "${timer.name} Copy";
    timer.id = Uuid().v4();
    timer.timeSettings.id = Uuid().v4();
    timer.soundSettings.id = Uuid().v4();
    timer.timeSettings.timerId = timer.id;
    timer.soundSettings.timerId = timer.id;
    await pushTimer(timer);
    notifyListeners();
  }

  Future<void> updateTimer(TimerType timer) async {
    int index = _timers.indexWhere((t) => t.id == timer.id);
    if (index != -1) {
      _timers[index] = timer;
      int timerRowsUpdated = await _timerRepository.updateTimer(timer);
      Log.debug("Updated $timerRowsUpdated rows in timer table.");
      int timeSettingsRowsUpdated = await _timerTimeSettingsRepository
          .updateTimeSettings(timer.timeSettings);
      Log.debug(
          "Updated $timeSettingsRowsUpdated rows in timer_time_settings table.");
      int soundSettingsRowsUpdated = await _timerSoundSettingsRepository
          .updateSoundSettings(timer.soundSettings);
      Log.debug(
          "Updated $soundSettingsRowsUpdated rows in timer_sound_settings table.");
      await _intervalProvider.deleteIntervals(timer.id);
      await pushIntervalsFromTimer(timer);
      Log.info("Timer with id ${timer.id} updated.");
      notifyListeners();
    } else {
      Log.warning("Timer with id ${timer.id} not found for update.");
    }
  }

  bool timerExists(String id) {
    return _timers.any((timer) => timer.id == id);
  }

  Future<void> pushIntervalsFromTimer(TimerType timer) async {
    List<IntervalType> intervals = generateIntervalsFromTimer(timer);
    try {
      if (intervals.isNotEmpty) {
        await _intervalRepository.insertIntervals(intervals);
        _intervalProvider.setIntervals(intervals);
        notifyListeners();
      }
    } catch (error) {
      Log.error("Error generating intervals: $error");
    }
  }

  Future<List<IntervalType>> getIntervalsForTimer(String timerId) async {
    return _intervalRepository.getIntervalsByTimerId(timerId);
  }

  Future<void> deleteTimer(TimerType timer) async {
    _timers.removeWhere((t) => t.id == timer.id);
    await _timerRepository.deleteTimer(timer.id);
    await _timerTimeSettingsRepository
        .deleteTimeSettings(timer.timeSettings.id);
    await _timerSoundSettingsRepository
        .deleteSoundSettings(timer.soundSettings.id);
    await _intervalProvider.deleteIntervals(timer.id);
    await updateTimerOrder(_timers);
    notifyListeners();
  }
}
