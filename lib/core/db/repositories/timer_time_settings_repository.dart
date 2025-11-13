import 'package:openhiit/core/db/database.dart';
import 'package:openhiit/core/models/timer_time_settings.dart';
import 'package:openhiit/core/db/tables.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TimerTimeSettingsRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  TimerTimeSettingsRepository();

  /// Inserts a TimerTimeSettings object, optionally inside a transaction
  Future<void> insertTimeSettings(TimerTimeSettings timeSettings,
      {Transaction? txn}) async {
    final db = txn ?? await _databaseManager.database;
    await (txn ?? db).insert(
      timeSettingsTableName,
      timeSettings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all time settings, optionally inside a transaction
  Future<List<TimerTimeSettings>> getAllTimeSettings({Transaction? txn}) async {
    final db = txn ?? await _databaseManager.database;
    final List<Map<String, dynamic>> maps =
        await (txn ?? db).query(timeSettingsTableName);

    return maps.map((map) => TimerTimeSettings.fromMap(map)).toList();
  }

  /// Get time settings by timerId, optionally inside a transaction
  Future<TimerTimeSettings?> getTimeSettingsByTimerId(String timerId,
      {Transaction? txn}) async {
    final db = txn ?? await _databaseManager.database;
    final List<Map<String, dynamic>> maps = await (txn ?? db).query(
      timeSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );

    if (maps.isNotEmpty) {
      return TimerTimeSettings.fromMap(maps.first);
    }
    return null;
  }

  /// Update time settings, optionally inside a transaction
  Future<int> updateTimeSettings(TimerTimeSettings timeSettings,
      {Transaction? txn}) async {
    final db = txn ?? await _databaseManager.database;
    return await (txn ?? db).update(
      timeSettingsTableName,
      timeSettings.toMap(),
      where: 'timerId = ?',
      whereArgs: [timeSettings.timerId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Delete time settings, optionally inside a transaction
  Future<void> deleteTimeSettings(String timerId, {Transaction? txn}) async {
    final db = txn ?? await _databaseManager.database;
    await (txn ?? db).delete(
      timeSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );
  }
}
