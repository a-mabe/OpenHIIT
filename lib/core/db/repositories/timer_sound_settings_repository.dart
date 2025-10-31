import 'package:openhiit/core/db/database.dart';
import 'package:openhiit/core/models/timer_sound_settings.dart';
import 'package:openhiit/core/db/tables.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TimerSoundSettingsRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  TimerSoundSettingsRepository();

  /// Inserts a TimerSoundSettings object, optionally inside a transaction
  Future<void> insertSoundSettings(TimerSoundSettings soundSettings,
      {Transaction? txn}) async {
    final db = txn ?? await _databaseManager.database;
    await (txn ?? db).insert(
      soundSettingsTableName,
      soundSettings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all sound settings, optionally inside a transaction
  Future<List<TimerSoundSettings>> getAllSoundSettings(
      {Transaction? txn}) async {
    final db = txn ?? await _databaseManager.database;
    final List<Map<String, dynamic>> maps =
        await (txn ?? db).query(soundSettingsTableName);

    return maps.map((map) => TimerSoundSettings.fromMap(map)).toList();
  }

  /// Get sound settings by timerId, optionally inside a transaction
  Future<TimerSoundSettings?> getSoundSettingsByTimerId(String timerId,
      {Transaction? txn}) async {
    final db = txn ?? await _databaseManager.database;
    final List<Map<String, dynamic>> maps = await (txn ?? db).query(
      soundSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );

    if (maps.isNotEmpty) {
      return TimerSoundSettings.fromMap(maps.first);
    }
    return null;
  }

  /// Update sound settings, optionally inside a transaction
  Future<int> updateSoundSettings(TimerSoundSettings soundSettings,
      {Transaction? txn}) async {
    final db = txn ?? await _databaseManager.database;
    return await (txn ?? db).update(
      soundSettingsTableName,
      soundSettings.toMap(),
      where: 'timerId = ?',
      whereArgs: [soundSettings.timerId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Delete sound settings, optionally inside a transaction
  Future<void> deleteSoundSettings(String timerId, {Transaction? txn}) async {
    final db = txn ?? await _databaseManager.database;
    await (txn ?? db).delete(
      soundSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );
  }
}

// import 'package:openhiit/core/db/database.dart';
// import 'package:openhiit/core/models/timer_sound_settings.dart';
// import 'package:openhiit/core/db/tables.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// class TimerSoundSettingsRepository {
//   final DatabaseManager _databaseManager = DatabaseManager();

//   TimerSoundSettingsRepository();

//   Future<void> insertSoundSettings(TimerSoundSettings soundSettings) async {
//     final db = await _databaseManager.database;
//     await db.insert(
//       soundSettingsTableName,
//       soundSettings.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.fail,
//     );
//   }

//   Future<List<TimerSoundSettings>> getAllSoundSettings() async {
//     final db = await _databaseManager.database;
//     final List<Map<String, dynamic>> maps =
//         await db.query(soundSettingsTableName);

//     return maps.map((map) => TimerSoundSettings.fromMap(map)).toList();
//   }

//   Future<TimerSoundSettings?> getSoundSettingsByTimerId(String timerId) async {
//     final db = await _databaseManager.database;
//     final List<Map<String, dynamic>> maps = await db.query(
//       soundSettingsTableName,
//       where: 'timerId = ?',
//       whereArgs: [timerId],
//     );

//     if (maps.isNotEmpty) {
//       return TimerSoundSettings.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<int> updateSoundSettings(TimerSoundSettings soundSettings) async {
//     final db = await _databaseManager.database;
//     int rowsAffected = await db.update(
//       soundSettingsTableName,
//       soundSettings.toMap(),
//       where: 'timerId = ?',
//       whereArgs: [soundSettings.timerId],
//     );
//     return rowsAffected;
//   }

//   Future<void> deleteSoundSettings(String timerId) async {
//     final db = await _databaseManager.database;
//     await db.delete(
//       soundSettingsTableName,
//       where: 'timerId = ?',
//       whereArgs: [timerId],
//     );
//   }
// }
