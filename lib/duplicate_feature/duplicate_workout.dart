import 'package:openhiit/workout_data_type/workout_type.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
class DuplicateWorkout{
  void duplicateWorkout(Workout workout, Future<Database> database) async {
    var uuid = const Uuid();
    //DuplicateWorkout and add to database with new id and workoutIndex
    Workout duplicateWorkout = Workout(
      uuid.v4(),
      workout.title,
      workout.numExercises,
      workout.exercises,
      workout.exerciseTime,
      workout.restTime,
      workout.halfTime,
      workout.halfwayMark,
      workout.workSound,
      workout.restSound,
      workout.halfwaySound,
      workout.completeSound,
      workout.countdownSound,
      workout.colorInt,
      workout.workoutIndex + 1,
      workout.showMinutes
    );
    final db = await database;
    await db.insert(
      'WorkoutTable',
      duplicateWorkout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}