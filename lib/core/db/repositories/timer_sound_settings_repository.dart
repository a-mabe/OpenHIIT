import 'package:openhiit/core/db/database.dart';
import 'package:openhiit/old/models/timer/timer_sound_settings.dart';
import 'package:openhiit/old/utils/database/constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TimerSoundSettingsRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  TimerSoundSettingsRepository();

  Future<void> insertSoundSettings(TimerSoundSettings soundSettings) async {
    final db = await _databaseManager.database;
    await db.insert(
      soundSettingsTableName,
      soundSettings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<TimerSoundSettings?> getSoundSettingsByTimerId(String timerId) async {
    final db = await _databaseManager.database;
    final List<Map<String, dynamic>> maps = await db.query(
      soundSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );

    if (maps.isNotEmpty) {
      return TimerSoundSettings.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateSoundSettings(TimerSoundSettings soundSettings) async {
    final db = await _databaseManager.database;
    await db.update(
      soundSettingsTableName,
      soundSettings.toMap(),
      where: 'timerId = ?',
      whereArgs: [soundSettings.timerId],
    );
  }

  Future<void> deleteSoundSettings(String timerId) async {
    final db = await _databaseManager.database;
    await db.delete(
      soundSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );
  }
}
