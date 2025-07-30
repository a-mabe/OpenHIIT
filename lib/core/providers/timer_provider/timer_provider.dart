import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/db/repositories/deprecated_workout_repository.dart';
import 'package:openhiit/core/db/repositories/interval_repository.dart';
import 'package:openhiit/core/db/repositories/timer_repository.dart';
import 'package:openhiit/core/db/repositories/timer_sound_settings_repository.dart';
import 'package:openhiit/core/db/repositories/timer_time_settings_repository.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_provider/migrations/migration_1.dart';
import 'package:openhiit/core/providers/timer_provider/migrations/migration_2.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:openhiit/old/models/timer/workout_type.dart';
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

  var logger = Logger(
    printer: JsonLogPrinter('TimerProvider'),
    level: Level.info,
  );

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
    notifyListeners();
  }

  bool timerExists(String id) {
    return _timers.any((timer) => timer.id == id);
  }
}
