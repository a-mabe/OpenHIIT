import 'dart:async';
import 'dart:io';

import 'package:openhiit/core/db/migrations/migration_runner.dart';
import 'package:openhiit/core/db/tables.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

int databaseVersion = 7; // Current database version

class DatabaseManager {
  static const String _databaseName = "core1.db";
  static final DatabaseManager _instance = DatabaseManager._internal();

  DatabaseManager._internal() {
    _initPlatformDatabaseSettings();
  }

  factory DatabaseManager() {
    return _instance;
  }

  Database? _database;

  void _initPlatformDatabaseSettings() {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfiNoIsolate;
    }
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    String dbPath =
        (Platform.isWindows || Platform.isLinux) ? inMemoryDatabasePath : path;

    return openDatabase(
      dbPath,
      version: databaseVersion,
      onCreate: (db, version) async {
        Batch batch = db.batch();
        batch.execute(createIntervalTableQuery);
        batch.execute(createTimerTableQuery);
        batch.execute(createTimeSettingsTableQuery);
        batch.execute(createSoundSettingsTableQuery);
        await batch.commit(noResult: true);
      },
      onUpgrade: _handleUpgrade,
    );
  }

  // Handle database upgrades
  Future<void> _handleUpgrade(
      Database db, int oldVersion, int newVersion) async {
    await runMigrations(db, oldVersion, newVersion);
  }

  // Future<void> insertInterval(IntervalType interval) async {
  //   final db = await _getDatabase();
  //   await db.insert(
  //     intervalTableName,
  //     interval.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.fail,
  //   );
  // }

  // Future<void> insertIntervals(List<IntervalType> intervals) async {
  //   final db = await _getDatabase();
  //   const int batchSize = 10000; // Number of rows per batch

  //   for (var i = 0; i < intervals.length; i += batchSize) {
  //     final batch = db.batch();

  //     // Get the next chunk of intervals
  //     final chunk = intervals.skip(i).take(batchSize);

  //     for (var interval in chunk) {
  //       batch.insert(
  //         intervalTableName,
  //         interval.toMap(),
  //         conflictAlgorithm: ConflictAlgorithm.fail,
  //       );
  //     }

  //     // Commit the batch
  //     await batch.commit(noResult: true);
  //   }
  // }

  // Future<void> insertTimer(TimerType timer) async {
  //   final db = await _getDatabase();
  //   await db.insert(
  //     timerTableName,
  //     timer.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.fail,
  //   );
  // }

  // Future<void> insertTimers(List<TimerType> timers) async {
  //   final db = await _getDatabase();
  //   Batch batch = db.batch();

  //   for (var timer in timers) {
  //     batch.insert(
  //       timerTableName,
  //       timer.toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.fail,
  //     );
  //   }

  //   await batch.commit(noResult: true);
  // }

  // Future<void> insertTimeSettings(TimerTimeSettings timeSettings) async {
  //   final db = await _getDatabase();
  //   await db.insert(
  //     timeSettingsTableName,
  //     timeSettings.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.fail,
  //   );
  // }

  // Future<void> insertSoundSettings(TimerSoundSettings soundSettings) async {
  //   final db = await _getDatabase();
  //   await db.insert(
  //     soundSettingsTableName,
  //     soundSettings.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.fail,
  //   );
  // }

  // // Update interval
  // Future<void> updateInterval(IntervalType interval) async {
  //   final db = await _getDatabase();
  //   await db.update(
  //     intervalTableName,
  //     interval.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [interval.id],
  //   );
  // }

  // // Batch update intervals
  // Future<void> updateIntervals(List<IntervalType> intervals) async {
  //   final db = await _getDatabase();
  //   Batch batch = db.batch();

  //   // Collect all interval IDs to be updated
  //   List<String> intervalIds =
  //       intervals.map((interval) => interval.id).toList();
  //   String timerId = intervals.first.workoutId;

  //   // Delete intervals that match the timerId but are not in the update list
  //   await db.delete(
  //     intervalTableName,
  //     where:
  //         'workoutId = ? AND id NOT IN (${List.filled(intervalIds.length, '?').join(', ')})',
  //     whereArgs: [timerId, ...intervalIds],
  //   );

  //   // Update intervals
  //   for (var interval in intervals) {
  //     batch.update(
  //       intervalTableName,
  //       interval.toMap(),
  //       where: 'id = ?',
  //       whereArgs: [interval.id],
  //     );
  //   }

  //   await batch.commit(noResult: true);
  // }

  // Future<void> updateTimer(TimerType timer) async {
  //   final db = await _getDatabase();
  //   await db.update(
  //     timerTableName,
  //     timer.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [timer.id],
  //   );
  // }

  // Future<void> updateTimers(List<TimerType> timers) async {
  //   final db = await _getDatabase();
  //   Batch batch = db.batch();

  //   for (var timer in timers) {
  //     batch.update(
  //       timerTableName,
  //       timer.toMap(),
  //       where: 'id = ?',
  //       whereArgs: [timer.id],
  //     );
  //   }

  //   await batch.commit(noResult: true);
  // }

  // Future<void> updateTimeSettingsByTimerId(
  //     String timerId, TimerTimeSettings timeSettings) async {
  //   final db = await _getDatabase();
  //   await db.update(
  //     timeSettingsTableName,
  //     timeSettings.toMap(),
  //     where: 'timerId = ?',
  //     whereArgs: [timerId],
  //   );
  // }

  // Future<void> updateSoundSettingsByTimerId(
  //     String timerId, TimerSoundSettings soundSettings) async {
  //   final db = await _getDatabase();
  //   await db.update(
  //     soundSettingsTableName,
  //     soundSettings.toMap(),
  //     where: 'timerId = ?',
  //     whereArgs: [timerId],
  //   );
  // }

  // // Delete workout
  // Future<void> deleteWorkout(String id) async {
  //   final db = await _getDatabase();
  //   await db.delete(
  //     workoutTableName,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

  // Future<void> deleteWorkoutTable() async {
  //   final db = await _getDatabase();
  //   await db.execute("DROP TABLE IF EXISTS $workoutTableName");
  // }

  // // Delete interval
  // Future<void> deleteInterval(String id) async {
  //   final db = await _getDatabase();
  //   await db.delete(
  //     intervalTableName,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

  // // Delete intervals
  // Future<void> deleteIntervalsByWorkoutId(String workoutId) async {
  //   final db = await _getDatabase();
  //   await db.delete(
  //     intervalTableName,
  //     where: 'workoutId = ?',
  //     whereArgs: [workoutId],
  //   );
  // }

  // // Delete timer
  // Future<void> deleteTimer(String id) async {
  //   final db = await _getDatabase();
  //   await db.delete(
  //     timerTableName,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

  // // Delete time settings
  // Future<void> deleteTimeSettingsByTimerId(String timerId) async {
  //   final db = await _getDatabase();
  //   await db.delete(
  //     timeSettingsTableName,
  //     where: 'timerId = ?',
  //     whereArgs: [timerId],
  //   );
  // }

  // // Delete sound settings
  // Future<void> deleteSoundSettingsByTimerId(String timerId) async {
  //   final db = await _getDatabase();
  //   await db.delete(
  //     soundSettingsTableName,
  //     where: 'timerId = ?',
  //     whereArgs: [timerId],
  //   );
  // }

  // // Get all workouts
  // Future<List<Workout>> getWorkouts() async {
  //   final db = await _getDatabase();
  //   try {
  //     final List<Map<String, dynamic>> maps = await db.query(workoutTableName);
  //     return maps.map((map) => Workout.fromMap(map)).toList();
  //   } catch (e) {
  //     // If the workouts table does not exist, return an empty list
  //     return [];
  //   }
  // }

  // // Get all intervals
  // Future<List<IntervalType>> getIntervals() async {
  //   final db = await _getDatabase();
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     intervalTableName,
  //     orderBy: 'intervalIndex ASC',
  //   );
  //   return maps.map((map) => IntervalType.fromMap(map)).toList();
  // }

  // Future<List<IntervalType>> getIntervalsByWorkoutId(String workoutId) async {
  //   final db = await _getDatabase();
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     intervalTableName,
  //     where: 'workoutId = ?',
  //     whereArgs: [workoutId],
  //     orderBy: 'intervalIndex ASC',
  //   );
  //   return maps.map((map) => IntervalType.fromMap(map)).toList();
  // }

  // // Get all timers
  // Future<List<TimerType>> getTimers() async {
  //   final db = await _getDatabase();
  //   final List<Map<String, dynamic>> maps = await db.query(timerTableName);
  //   return maps.map((map) => TimerType.fromMap(map)).toList();
  // }

  // // Get all timers with their settings
  // Future<List<TimerType>> getTimersWithSettings() async {
  //   final db = await _getDatabase();
  //   final List<Map<String, dynamic>> timerMaps = await db.query(timerTableName);
  //   List<TimerType> timers = [];

  //   for (var timerMap in timerMaps) {
  //     TimerType timer = TimerType.fromMap(timerMap);

  //     // Fetch and set time settings
  //     TimerTimeSettings? timeSettings =
  //         await getTimeSettingsByTimerId(timer.id);
  //     if (timeSettings != null) {
  //       timer.timeSettings = timeSettings;
  //     }

  //     // Fetch and set sound settings
  //     TimerSoundSettings? soundSettings =
  //         await getSoundSettingsByTimerId(timer.id);
  //     if (soundSettings != null) {
  //       timer.soundSettings = soundSettings;
  //     }

  //     timers.add(timer);
  //   }

  //   return timers;
  // }

  // // Get time settings by timer ID
  // Future<TimerTimeSettings?> getTimeSettingsByTimerId(String timerId) async {
  //   final db = await _getDatabase();
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     timeSettingsTableName,
  //     where: 'timerId = ?',
  //     whereArgs: [timerId],
  //   );
  //   if (maps.isEmpty) {
  //     return null;
  //   }
  //   return TimerTimeSettings.fromMap(maps.first);
  // }

  // // Get sound settings by timer ID
  // Future<TimerSoundSettings?> getSoundSettingsByTimerId(String timerId) async {
  //   final db = await _getDatabase();
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     soundSettingsTableName,
  //     where: 'timerId = ?',
  //     whereArgs: [timerId],
  //   );
  //   if (maps.isEmpty) {
  //     return null;
  //   }
  //   return TimerSoundSettings.fromMap(maps.first);
  // }
}
