import 'package:background_hiit_timer/utils/log.dart';
import 'package:openhiit/core/db/database.dart';
import 'package:openhiit/core/db/repositories/timer_sound_settings_repository.dart';
import 'package:openhiit/core/db/repositories/timer_time_settings_repository.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/core/db/tables.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TimerRepository {
  final DatabaseManager _databaseManager = DatabaseManager();
  final TimerSoundSettingsRepository _timerSoundSettingsRepository =
      TimerSoundSettingsRepository();
  final TimerTimeSettingsRepository _timerTimeSettingsRepository =
      TimerTimeSettingsRepository();

  TimerRepository();

  /// Inserts a timer safely inside a transaction
  Future<void> insertTimer(TimerType timer) async {
    final db = await _databaseManager.database;
    await db.transaction((txn) async {
      await txn.insert(
        timerTableName,
        timer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// Get a single timer by ID
  Future<TimerType?> getTimerById(String id) async {
    final db = await _databaseManager.database;
    return await db.transaction((txn) async {
      final List<Map<String, dynamic>> maps = await txn.query(
        timerTableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;

      final timer = TimerType.fromMap(maps.first);

      // Load settings inside the same transaction
      timer.timeSettings = (await _timerTimeSettingsRepository
          .getTimeSettingsByTimerId(timer.id, txn: txn))!;
      timer.soundSettings = (await _timerSoundSettingsRepository
          .getSoundSettingsByTimerId(timer.id, txn: txn))!;

      return timer;
    });
  }

  /// Get all timers with their settings
  Future<List<TimerType>> getAllTimers() async {
    final db = await _databaseManager.database;
    return await db.transaction((txn) async {
      final timerMaps = await txn.query(timerTableName);

      // Fetch all settings in the same transaction
      final timeSettingsList =
          await _timerTimeSettingsRepository.getAllTimeSettings(txn: txn);
      final soundSettingsList =
          await _timerSoundSettingsRepository.getAllSoundSettings(txn: txn);

      final timeSettingsMap = {for (var s in timeSettingsList) s.timerId: s};
      final soundSettingsMap = {for (var s in soundSettingsList) s.timerId: s};

      return timerMaps.map((timerMap) {
        final timer = TimerType.fromMap(timerMap);
        timer.timeSettings = timeSettingsMap[timer.id]!;
        timer.soundSettings = soundSettingsMap[timer.id]!;
        return timer;
      }).toList();
    });
  }

  /// Update a single timer
  Future<int> updateTimer(TimerType timer) async {
    final db = await _databaseManager.database;
    return await db.transaction((txn) async {
      final rowsAffected = await txn.update(
        timerTableName,
        timer.toMap(),
        where: 'id = ?',
        whereArgs: [timer.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return rowsAffected;
    });
  }

  /// Delete a timer by ID
  Future<void> deleteTimer(String id) async {
    final db = await _databaseManager.database;
    await db.transaction((txn) async {
      await txn.delete(
        timerTableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  /// Batch update multiple timers
  Future<void> updateTimers(List<TimerType> timers) async {
    final db = await _databaseManager.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final timer in timers) {
        batch.update(
          timerTableName,
          timer.toMap(),
          where: 'id = ?',
          whereArgs: [timer.id],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }
}
