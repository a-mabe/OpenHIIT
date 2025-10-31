import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:openhiit/core/db/database.dart';
import 'package:openhiit/core/db/tables.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class IntervalRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  IntervalRepository();

  Future<void> insertInterval(IntervalType interval) async {
    final db = await _databaseManager.database;
    await db.insert(
      intervalTableName,
      interval.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> insertIntervals(List<IntervalType> intervals) async {
    final db = await _databaseManager.database;
    await db.transaction((txn) async {
      for (var interval in intervals) {
        await txn.insert(
          intervalTableName,
          interval.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail,
        );
      }
    });
  }

  Future<List<IntervalType>> getIntervalsByTimerId(String timerId) async {
    final db = await _databaseManager.database;
    final List<Map<String, dynamic>> maps = await db.query(
      intervalTableName,
      where: 'workoutId = ?',
      whereArgs: [timerId],
    );

    return maps.map((map) => IntervalType.fromMap(map)).toList();
  }

  Future<void> updateIntervals(List<IntervalType> intervals) async {
    final db = await _databaseManager.database;
    await db.transaction((txn) async {
      for (var interval in intervals) {
        await txn.update(
          intervalTableName,
          interval.toMap(),
          where: 'id = ?',
          whereArgs: [interval.id],
        );
      }
    });
  }

  Future<void> deleteIntervalsByTimerId(String timerId) async {
    final db = await _databaseManager.database;
    await db.delete(
      intervalTableName,
      where: 'workoutId = ?',
      whereArgs: [timerId],
    );
  }
}
