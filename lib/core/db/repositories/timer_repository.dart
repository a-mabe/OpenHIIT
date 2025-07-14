import 'package:openhiit/core/db/database.dart';
import 'package:openhiit/core/db/repositories/timer_sound_settings_repository.dart';
import 'package:openhiit/core/db/repositories/timer_time_settings_repository.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:openhiit/core/db/tables.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TimerRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  final TimerSoundSettingsRepository _timerSoundSettingsRepository =
      TimerSoundSettingsRepository();
  final TimerTimeSettingsRepository _timerTimeSettingsRepository =
      TimerTimeSettingsRepository();

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
    final timerMaps = await db.query(timerTableName);

    // Fetch all time and sound settings in advance for efficiency
    final timeSettingsList =
        await _timerTimeSettingsRepository.getAllTimeSettings();
    final soundSettingsList =
        await _timerSoundSettingsRepository.getAllSoundSettings();

    // Map timerId to settings for quick lookup
    final timeSettingsMap = {for (var s in timeSettingsList) s.timerId: s};
    final soundSettingsMap = {for (var s in soundSettingsList) s.timerId: s};

    return timerMaps.map((timerMap) {
      final timer = TimerType.fromMap(timerMap);
      timer.timeSettings = timeSettingsMap[timer.id]!;
      timer.soundSettings = soundSettingsMap[timer.id]!;
      return timer;
    }).toList();
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

  Future<void> updateTimers(List<TimerType> timers) async {
    final db = await _databaseManager.database;
    final batch = db.batch();
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
  }
}
