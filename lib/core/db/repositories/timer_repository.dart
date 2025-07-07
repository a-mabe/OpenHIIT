import 'package:openhiit/core/db/database.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:openhiit/core/db/tables.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TimerRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  TimerRepository();

  Future<void> insertTimer(TimerType timer) async {
    final db = await _databaseManager.database;
    await db.insert(
      timerTableName,
      timer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<TimerType?> getTimerById(String id) async {
    final db = await _databaseManager.database;
    final List<Map<String, dynamic>> maps = await db.query(
      timerTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TimerType.fromMap(maps.first);
    }
    return null;
  }

  Future<List<TimerType>> getAllTimers() async {
    final db = await _databaseManager.database;
    final List<Map<String, dynamic>> maps = await db.query(timerTableName);

    return List.generate(maps.length, (i) {
      return TimerType.fromMap(maps[i]);
    });
  }

  Future<void> updateTimer(TimerType timer) async {
    final db = await _databaseManager.database;
    await db.update(
      timerTableName,
      timer.toMap(),
      where: 'id = ?',
      whereArgs: [timer.id],
    );
  }

  Future<void> deleteTimer(String id) async {
    final db = await _databaseManager.database;
    await db.delete(
      timerTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
