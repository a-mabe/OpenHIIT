import 'package:openhiit/core/db/database.dart';
import 'package:openhiit/core/db/tables.dart';
import 'package:openhiit/old/models/timer/workout_type.dart';

/// The Workout datatype is now deprecated.
/// This class exists to maintain compatibility with existing data.
/// It is recommended to use the new TimerType class instead.
///
/// Migration from Workout to TimerType exists within the Timer Provider.
class WorkoutRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  WorkoutRepository();

  Future<List<Workout>> getAllWorkouts() async {
    final db = await _databaseManager.database;

    // Check if the workoutTable exists
    final tableCheck = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [workoutTableName],
    );
    if (tableCheck.isEmpty) {
      // Table does not exist, return empty list
      return [];
    }

    final List<Map<String, dynamic>> maps = await db.query(workoutTableName);
    return maps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<void> deleteAllWorkouts() async {
    final db = await _databaseManager.database;
    await db.delete(workoutTableName);
  }
}
