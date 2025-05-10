import 'dart:async';
import 'dart:io';

import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:openhiit/models/timer/timer_sound_settings.dart';
import 'package:openhiit/models/timer/timer_time_settings.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/utils/database/constants.dart';
import 'package:openhiit/utils/log/log.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../models/timer/workout_type.dart';

class DatabaseManager {
  static const String _databaseName = "core1.db";

  // Singleton instance
  static final DatabaseManager _instance = DatabaseManager._internal();

  // Private constructor
  DatabaseManager._internal() {
    _initPlatformDatabaseSettings();
  }

  // Factory constructor to return the singleton instance
  factory DatabaseManager() {
    return _instance;
  }

  Database? _database;

  // Initialize platform-specific database settings
  void _initPlatformDatabaseSettings() {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfiNoIsolate;
    }
  }

  // Lazy initialization of the database, open it only once
  Future<Database> _getDatabase() async {
    if (_database != null) {
      return _database!;
    }
    _database = await openWorkoutDatabase();
    return _database!;
  }

  // Open the workout database
  Future<Database> openWorkoutDatabase() async {
    logger.d("Opening database");

    String path = join(await getDatabasesPath(), _databaseName);
    String dbPath =
        (Platform.isWindows || Platform.isLinux) ? inMemoryDatabasePath : path;
    int dbVersion = 7;

    return openDatabase(
      dbPath,
      version: dbVersion,
      onCreate: (db, version) async {
        Batch batch = db.batch();
        batch.execute(createWorkoutTableQuery);
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
    if (oldVersion != newVersion) {
      logger.d("Upgrading database from $oldVersion to $newVersion");
    }

    Map<int, List<String>> upgradeQueries = {
      1: ["ALTER TABLE $workoutTableName ADD COLUMN colorInt INTEGER;"],
      2: ["ALTER TABLE $workoutTableName ADD COLUMN workoutIndex INTEGER;"],
      3: ["ALTER TABLE $workoutTableName ADD COLUMN showMinutes INTEGER;"],
      4: [
        "ALTER TABLE $workoutTableName ADD COLUMN getReadyTime INTEGER;",
        "ALTER TABLE $workoutTableName ADD COLUMN breakTime INTEGER;",
        "ALTER TABLE $workoutTableName ADD COLUMN warmupTime INTEGER;",
        "ALTER TABLE $workoutTableName ADD COLUMN cooldownTime INTEGER;",
        "ALTER TABLE $workoutTableName ADD COLUMN iterations INTEGER;"
      ]
    };

    for (int i = oldVersion; i < newVersion; i++) {
      if (upgradeQueries.containsKey(i)) {
        for (var query in upgradeQueries[i]!) {
          await db.execute(query);
        }
      }
    }

    if (oldVersion < newVersion) {
      await db.execute(createIntervalTableQuery);
      await db.execute(createTimerTableQuery);
      await db.execute(createTimeSettingsTableQuery);
      await db.execute(createSoundSettingsTableQuery);
    }

    // if (oldVersion < 8) {
    //   // Check if the old table exists
    //   final tables = await db.rawQuery(
    //       "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
    //       [timeSettingsTableName]);

    //   if (tables.isNotEmpty) {
    //     // Table exists, so do the migration
    //     await db.execute('''
    //   CREATE TABLE time_settings_temp (
    //     id TEXT PRIMARY KEY,
    //     timerId TEXT,
    //     getReadyTime INTEGER,
    //     workTime INTEGER,
    //     restTime INTEGER,
    //     breakTime INTEGER,
    //     warmupTime INTEGER,
    //     cooldownTime INTEGER,
    //     restarts INTEGER
    //   );
    // ''');

    //     await db.execute('''
    //   INSERT INTO time_settings_temp (
    //     id,
    //     timerId,
    //     getReadyTime,
    //     workTime,
    //     restTime,
    //     breakTime,
    //     warmupTime,
    //     cooldownTime,
    //     restarts
    //   )
    //   SELECT
    //     id,
    //     timerId,
    //     getReadyTime,
    //     workTime,
    //     restTime,
    //     breakTime,
    //     warmupTime,
    //     cooldownTime,
    //     restarts
    //   FROM $timeSettingsTableName;
    // ''');

    //     await db.execute("DROP TABLE $timeSettingsTableName;");
    //     await db.execute(
    //         "ALTER TABLE time_settings_temp RENAME TO $timeSettingsTableName;");
    //   } else {
    //     logger.d(
    //         "Skipping getReadyTime -> getReadyTime migration because $timeSettingsTableName does not exist.");
    //   }
    // }
  }

  // Return database version number
  Future<int> getDatabaseVersion() async {
    final db = await _getDatabase();
    return db.getVersion();
  }

  // Insert interval
  Future<void> insertInterval(IntervalType interval) async {
    final db = await _getDatabase();
    await db.insert(
      intervalTableName,
      interval.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // Insert intervals
  Future<void> insertIntervals(List<IntervalType> intervals) async {
    final db = await _getDatabase();
    const int batchSize = 10000; // Number of rows per batch

    for (var i = 0; i < intervals.length; i += batchSize) {
      final batch = db.batch();

      // Get the next chunk of intervals
      final chunk = intervals.skip(i).take(batchSize);

      for (var interval in chunk) {
        batch.insert(
          intervalTableName,
          interval.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail,
        );
      }

      // Commit the batch
      await batch.commit(noResult: true);
    }
  }

  Future<void> insertTimer(TimerType timer) async {
    final db = await _getDatabase();
    await db.insert(
      timerTableName,
      timer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> insertTimers(List<TimerType> timers) async {
    final db = await _getDatabase();
    Batch batch = db.batch();

    for (var timer in timers) {
      batch.insert(
        timerTableName,
        timer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> insertTimeSettings(TimerTimeSettings timeSettings) async {
    final db = await _getDatabase();
    await db.insert(
      timeSettingsTableName,
      timeSettings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> insertSoundSettings(TimerSoundSettings soundSettings) async {
    final db = await _getDatabase();
    await db.insert(
      soundSettingsTableName,
      soundSettings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // Update interval
  Future<void> updateInterval(IntervalType interval) async {
    final db = await _getDatabase();
    await db.update(
      intervalTableName,
      interval.toMap(),
      where: 'id = ?',
      whereArgs: [interval.id],
    );
  }

  // Batch update intervals
  Future<void> updateIntervals(List<IntervalType> intervals) async {
    final db = await _getDatabase();
    Batch batch = db.batch();

    // Collect all interval IDs to be updated
    List<String> intervalIds =
        intervals.map((interval) => interval.id).toList();
    String timerId = intervals.first.workoutId;

    // Delete intervals that match the timerId but are not in the update list
    await db.delete(
      intervalTableName,
      where:
          'workoutId = ? AND id NOT IN (${List.filled(intervalIds.length, '?').join(', ')})',
      whereArgs: [timerId, ...intervalIds],
    );

    // Update intervals
    for (var interval in intervals) {
      batch.update(
        intervalTableName,
        interval.toMap(),
        where: 'id = ?',
        whereArgs: [interval.id],
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> updateTimer(TimerType timer) async {
    final db = await _getDatabase();
    await db.update(
      timerTableName,
      timer.toMap(),
      where: 'id = ?',
      whereArgs: [timer.id],
    );
  }

  Future<void> updateTimers(List<TimerType> timers) async {
    final db = await _getDatabase();
    Batch batch = db.batch();

    for (var timer in timers) {
      batch.update(
        timerTableName,
        timer.toMap(),
        where: 'id = ?',
        whereArgs: [timer.id],
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> updateTimeSettingsByTimerId(
      String timerId, TimerTimeSettings timeSettings) async {
    final db = await _getDatabase();
    await db.update(
      timeSettingsTableName,
      timeSettings.toMap(),
      where: 'timerId = ?',
      whereArgs: [timerId],
    );
  }

  Future<void> updateSoundSettingsByTimerId(
      String timerId, TimerSoundSettings soundSettings) async {
    final db = await _getDatabase();
    await db.update(
      soundSettingsTableName,
      soundSettings.toMap(),
      where: 'timerId = ?',
      whereArgs: [timerId],
    );
  }

  // Delete workout
  Future<void> deleteWorkout(String id) async {
    final db = await _getDatabase();
    await db.delete(
      workoutTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteWorkoutTable() async {
    final db = await _getDatabase();
    await db.execute("DROP TABLE IF EXISTS $workoutTableName");
  }

  // Delete interval
  Future<void> deleteInterval(String id) async {
    final db = await _getDatabase();
    await db.delete(
      intervalTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete intervals
  Future<void> deleteIntervalsByWorkoutId(String workoutId) async {
    final db = await _getDatabase();
    await db.delete(
      intervalTableName,
      where: 'workoutId = ?',
      whereArgs: [workoutId],
    );
  }

  // Delete timer
  Future<void> deleteTimer(String id) async {
    final db = await _getDatabase();
    await db.delete(
      timerTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete time settings
  Future<void> deleteTimeSettingsByTimerId(String timerId) async {
    final db = await _getDatabase();
    await db.delete(
      timeSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );
  }

  // Delete sound settings
  Future<void> deleteSoundSettingsByTimerId(String timerId) async {
    final db = await _getDatabase();
    await db.delete(
      soundSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );
  }

  // Get all workouts
  Future<List<Workout>> getWorkouts() async {
    final db = await _getDatabase();
    try {
      final List<Map<String, dynamic>> maps = await db.query(workoutTableName);
      return maps.map((map) => Workout.fromMap(map)).toList();
    } catch (e) {
      // If the workouts table does not exist, return an empty list
      return [];
    }
  }

  // Get all intervals
  Future<List<IntervalType>> getIntervals() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      intervalTableName,
      orderBy: 'intervalIndex ASC',
    );
    return maps.map((map) => IntervalType.fromMap(map)).toList();
  }

  Future<List<IntervalType>> getIntervalsByWorkoutId(String workoutId) async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      intervalTableName,
      where: 'workoutId = ?',
      whereArgs: [workoutId],
      orderBy: 'intervalIndex ASC',
    );
    return maps.map((map) => IntervalType.fromMap(map)).toList();
  }

  // Get all timers
  Future<List<TimerType>> getTimers() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(timerTableName);
    return maps.map((map) => TimerType.fromMap(map)).toList();
  }

  // Get all timers with their settings
  Future<List<TimerType>> getTimersWithSettings() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> timerMaps = await db.query(timerTableName);
    List<TimerType> timers = [];

    for (var timerMap in timerMaps) {
      TimerType timer = TimerType.fromMap(timerMap);

      // Fetch and set time settings
      TimerTimeSettings? timeSettings =
          await getTimeSettingsByTimerId(timer.id);
      if (timeSettings != null) {
        timer.timeSettings = timeSettings;
      }

      // Fetch and set sound settings
      TimerSoundSettings? soundSettings =
          await getSoundSettingsByTimerId(timer.id);
      if (soundSettings != null) {
        timer.soundSettings = soundSettings;
      }

      timers.add(timer);
    }

    return timers;
  }

  // Get time settings by timer ID
  Future<TimerTimeSettings?> getTimeSettingsByTimerId(String timerId) async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      timeSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );
    if (maps.isEmpty) {
      return null;
    }
    return TimerTimeSettings.fromMap(maps.first);
  }

  // Get sound settings by timer ID
  Future<TimerSoundSettings?> getSoundSettingsByTimerId(String timerId) async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      soundSettingsTableName,
      where: 'timerId = ?',
      whereArgs: [timerId],
    );
    if (maps.isEmpty) {
      return null;
    }
    return TimerSoundSettings.fromMap(maps.first);
  }
}
