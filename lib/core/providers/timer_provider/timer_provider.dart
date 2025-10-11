import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
import 'package:openhiit/core/models/workout_type.dart';
import 'package:openhiit/core/utils/interval_calculation.dart';
import 'package:uuid/uuid.dart';

class TimerProvider extends ChangeNotifier {
  // Deprecated - Included to migrate old data
  final List<Workout> _workouts = [];
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

  var logger = Logger(
    printer: JsonLogPrinter('TimerProvider'),
  );

  void setIntervalProvider(IntervalProvider provider) {
    _intervalProvider = provider;
  }

  Future<List<TimerType>> loadTimers() async {
    // Load workouts from the old repository
    await _workoutRepository.getAllWorkouts().then((workouts) {});

    if (_workouts.isNotEmpty) {
      logger.i("Migrating old workouts to timers and intervals...");
      await workoutsMigration(_workouts, _intervalRepository, _timerRepository);
      logger.i("Migration completed successfully.");

      _workoutRepository.deleteAllWorkouts().then((_) {
        logger.i("Old workouts deleted after migration.");
      }).catchError((error) {
        logger.e("Error deleting old workouts: $error");
      });
    }

    // Run warmup migration
    await warmupMigration(
      _timers,
      _intervalRepository,
      _timerRepository,
      _timerTimeSettingsRepository,
    );

    return _timerRepository.getAllTimers().then((timers) {
      _timers = timers;
      _timers.sort((a, b) => a.timerIndex.compareTo(b.timerIndex));
      return _timers;
    }).whenComplete(() {
      notifyListeners();
    });
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
    timer.id = Uuid().v8();
    timer.timeSettings.id = Uuid().v8();
    timer.soundSettings.id = Uuid().v8();
    timer.timeSettings.timerId = timer.id;
    timer.soundSettings.timerId = timer.id;
    await pushTimer(timer);
    await pushIntervalsFromTimer(timer);
    notifyListeners();
  }

  Future<void> updateTimer(TimerType timer) async {
    int index = _timers.indexWhere((t) => t.id == timer.id);
    if (index != -1) {
      _timers[index] = timer;
      int timerRowsUpdated = await _timerRepository.updateTimer(timer);
      logger.d("Updated $timerRowsUpdated rows in timer table.");
      int timeSettingsRowsUpdated = await _timerTimeSettingsRepository
          .updateTimeSettings(timer.timeSettings);
      logger.d(
          "Updated $timeSettingsRowsUpdated rows in timer_time_settings table.");
      int soundSettingsRowsUpdated = await _timerSoundSettingsRepository
          .updateSoundSettings(timer.soundSettings);
      logger.d(
          "Updated $soundSettingsRowsUpdated rows in timer_sound_settings table.");
      await _intervalProvider.deleteIntervals(timer.id);
      await pushIntervalsFromTimer(timer);
      logger.i("Timer with id ${timer.id} updated.");
      notifyListeners();
    } else {
      logger.w("Timer with id ${timer.id} not found for update.");
    }
  }

  bool timerExists(String id) {
    return _timers.any((timer) => timer.id == id);
  }

  Future<void> pushIntervalsFromTimer(TimerType timer) async {
    Future<List<IntervalType>> intervalsFuture =
        generateIntervalsFromTimer(timer);
    intervalsFuture.then((intervals) async {
      if (intervals.isNotEmpty) {
        await _intervalRepository.insertIntervals(intervals);
        _intervalProvider.setIntervals(intervals);
        notifyListeners();
      }
    }).catchError((error) {
      logger.e("Error generating intervals: $error");
    });
  }

  Future<List<IntervalType>> getIntervalsForTimer(String timerId) async {
    return _intervalRepository.getIntervalsByTimerId(timerId);
  }
}
