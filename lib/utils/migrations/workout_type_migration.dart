import 'package:openhiit/models/interval_type.dart';
import 'package:openhiit/models/workout_type.dart';
import 'package:openhiit/utils/database/database_manager.dart';
import 'package:openhiit/utils/import_export/local_file_util.dart';

class WorkoutTypeMigration {
  Future migrateToInterval(Workout workout, bool update) async {
    DatabaseManager dbManager = DatabaseManager();
    List<IntervalType> intervals = [];
    int currentIndex = 0; // Track the index of each interval

    // Add warmup interval if time is non-zero
    if (workout.warmupTime > 0) {
      intervals.add(IntervalType(
        id: "${workout.id}_warmup",
        workoutId: workout.id,
        time: workout.warmupTime,
        name: "Warmup",
        color: workout.colorInt,
        intervalIndex: currentIndex++,
        sound: workout.countdownSound,
      ));
    }

    // Add get ready interval if time is non-zero
    if (workout.getReadyTime > 0) {
      intervals.add(IntervalType(
        id: "${workout.id}_get_ready",
        workoutId: workout.id,
        time: workout.getReadyTime,
        name: "Get Ready",
        color: workout.colorInt,
        intervalIndex: currentIndex++,
        sound: workout.countdownSound,
      ));
    }

    logger.d(workout.iterations);

    // Loop for each iteration
    int iteration = 0;
    do {
      for (int i = 0; i < workout.numExercises; i++) {
        // Add work interval
        if (workout.workTime > 0) {
          intervals.add(IntervalType(
            id: "${workout.id}_work_${iteration}_$i",
            workoutId: workout.id,
            time: workout.workTime,
            name: "Work",
            color: workout.colorInt,
            intervalIndex: currentIndex++,
            sound: workout.workSound,
            halfwaySound: workout.halfwaySound,
          ));
        }

        // Add rest interval
        if (workout.restTime > 0) {
          intervals.add(IntervalType(
            id: "${workout.id}_rest_${iteration}_$i",
            workoutId: workout.id,
            time: workout.restTime,
            name: "Rest",
            color: workout.colorInt,
            intervalIndex: currentIndex++,
            sound: workout.restSound,
          ));
        }
      }

      // Add break interval if time is non-zero, but only between iterations
      if (workout.breakTime > 0 && iteration < workout.iterations - 1) {
        intervals.add(IntervalType(
          id: "${workout.id}_break_$iteration",
          workoutId: workout.id,
          time: workout.breakTime,
          name: "Break",
          color: workout.colorInt,
          intervalIndex: currentIndex++,
          sound: workout.restSound,
        ));
      }

      iteration++;
    } while (iteration < workout.iterations);

    // Add cooldown interval if time is non-zero
    if (workout.cooldownTime > 0) {
      intervals.add(IntervalType(
        id: "${workout.id}_cooldown",
        workoutId: workout.id,
        time: workout.cooldownTime,
        name: "Cooldown",
        color: workout.colorInt,
        intervalIndex: currentIndex++,
        sound: workout.completeSound,
      ));
    }

    logger.d("Migrating workout to intervals: ${workout.title}");
    for (var interval in intervals) {
      logger.d(interval);
    }

    if (update) {
      dbManager.updateIntervals(intervals);
    } else {
      dbManager.insertIntervals(intervals);
    }
  }
}
