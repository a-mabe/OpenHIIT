import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/db/repositories/deprecated_workout_repository.dart';
import 'package:openhiit/core/db/repositories/interval_repository.dart';
import 'package:openhiit/core/db/repositories/timer_repository.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_provider/migrations/migration_1.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:openhiit/old/models/timer/workout_type.dart';

var logger = Logger(
  printer: JsonLogPrinter('DatabaseManager'),
  level: Level.info,
);

class TimerProvider extends ChangeNotifier {
  // Deprecated - Included to migrate old data
  final List<Workout> _workouts = [];
  final WorkoutRepository _workoutRepository = WorkoutRepository();

  List<TimerType> _timers = [];
  List<TimerType> get timers => _timers;
  final TimerRepository _timerRepository = TimerRepository();

  final IntervalRepository _intervalRepository = IntervalRepository();

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

    return _timerRepository.getAllTimers().then((timers) {
      _timers = timers;
      return _timers;
    }).whenComplete(() {
      notifyListeners();
    });
  }
}
