import 'package:openhiit/core/db/database.dart';
import 'package:openhiit/old/models/timer/timer_time_settings.dart';
import 'package:openhiit/old/utils/database/constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TimerTimeSettingsRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  TimerTimeSettingsRepository();

  Future<void> insertTimeSettings(TimerTimeSettings timeSettings) async {
    final db = await _databaseManager.database;
    await db.insert(
      timeSettingsTableName,
      timeSettings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<TimerTimeSettings?> getTimeSettingsByTimerId(String timerId) async {
    final db = await _databaseManager.database;
    final List<Map<String, dynamic>> maps = await db.query(
      timeSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );

    if (maps.isNotEmpty) {
      return TimerTimeSettings.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateTimeSettings(TimerTimeSettings timeSettings) async {
    final db = await _databaseManager.database;
    await db.update(
      timeSettingsTableName,
      timeSettings.toMap(),
      where: 'timerId = ?',
      whereArgs: [timeSettings.timerId],
    );
  }

  Future<void> deleteTimeSettings(String timerId) async {
    final db = await _databaseManager.database;
    await db.delete(
      timeSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );
  }
}
