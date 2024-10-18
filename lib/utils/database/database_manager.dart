import 'dart:async';
import 'dart:io';
import 'package:openhiit/models/interval_type.dart';
import 'package:openhiit/utils/log/log.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../models/workout_type.dart';

class DatabaseManager {
  static const String _databaseName = "core1.db";
  static const String _workoutTableName = "WorkoutTable";
  static const String _intervalTableName = "IntervalTable";

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

    const createWorkoutTableQuery = '''
      CREATE TABLE IF NOT EXISTS $_workoutTableName(
        id TEXT PRIMARY KEY,
        title TEXT,
        numExercises INTEGER,
        exercises TEXT,
        getReadyTime INTEGER,
        exerciseTime INTEGER,
        restTime INTEGER,
        halfTime INTEGER,
        breakTime INTEGER,
        warmupTime INTEGER,
        cooldownTime INTEGER,
        iterations INTEGER,
        halfwayMark INTEGER,
        workSound TEXT,
        restSound TEXT,
        halfwaySound TEXT,
        completeSound TEXT,
        countdownSound TEXT,
        colorInt INTEGER,
        workoutIndex INTEGER,
        showMinutes INTEGER
      )
    ''';

    const createIntervalTableQuery = '''
      CREATE TABLE IF NOT EXISTS $_intervalTableName(
        id TEXT PRIMARY KEY,
        workoutId TEXT,
        time INTEGER,
        name TEXT,
        color INTEGER,
        intervalIndex INTEGER,
        sound TEXT,
        halfwaySound TEXT
      )
    ''';

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
      1: ["ALTER TABLE $_workoutTableName ADD COLUMN colorInt INTEGER;"],
      2: ["ALTER TABLE $_workoutTableName ADD COLUMN workoutIndex INTEGER;"],
      3: ["ALTER TABLE $_workoutTableName ADD COLUMN showMinutes INTEGER;"],
      4: [
        "ALTER TABLE $_workoutTableName ADD COLUMN getReadyTime INTEGER;",
        "ALTER TABLE $_workoutTableName ADD COLUMN breakTime INTEGER;",
        "ALTER TABLE $_workoutTableName ADD COLUMN warmupTime INTEGER;",
        "ALTER TABLE $_workoutTableName ADD COLUMN cooldownTime INTEGER;",
        "ALTER TABLE $_workoutTableName ADD COLUMN iterations INTEGER;"
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
      const createIntervalTableQuery = '''
        CREATE TABLE IF NOT EXISTS $_intervalTableName(
          id TEXT PRIMARY KEY,
          workoutId TEXT,
          time INTEGER,
          name TEXT,
          color INTEGER,
          intervalIndex INTEGER,
          sound TEXT,
          halfwaySound TEXT
        )
      ''';

      await db.execute(createIntervalTableQuery);
    }
  }

  // Insert interval
  Future<void> insertInterval(IntervalType interval) async {
    logger.d("Inserting interval: ${interval.name}");

    final db = await _getDatabase();
    await db.insert(
      _intervalTableName,
      interval.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // Insert intervals
  Future<void> insertIntervals(List<IntervalType> intervals) async {
    logger.d("Inserting ${intervals.length} intervals");

    final db = await _getDatabase();
    Batch batch = db.batch();

    for (var interval in intervals) {
      batch.insert(
        _intervalTableName,
        interval.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  // Insert workout
  Future<void> insertWorkout(Workout workout) async {
    logger.d("Inserting workout: ${workout.title}");

    final db = await _getDatabase();
    await db.insert(
      _workoutTableName,
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // Update interval
  Future<void> updateInterval(IntervalType interval) async {
    logger.d("Updating interval: ${interval.name}");

    final db = await _getDatabase();
    await db.update(
      _intervalTableName,
      interval.toMap(),
      where: 'id = ?',
      whereArgs: [interval.id],
    );
  }

  // Batch update intervals
  Future<void> updateIntervals(List<IntervalType> intervals) async {
    logger.d("Updating ${intervals.length} intervals");

    final db = await _getDatabase();
    Batch batch = db.batch();

    for (var interval in intervals) {
      batch.update(
        _intervalTableName,
        interval.toMap(),
        where: 'id = ?',
        whereArgs: [interval.id],
      );
    }

    await batch.commit(noResult: true);
  }

  // Update workout
  Future<void> updateWorkout(Workout workout) async {
    logger.d("Updating workout: ${workout.title}");

    final db = await _getDatabase();
    await db.update(
      _workoutTableName,
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  // Batch update workouts
  Future<void> updateWorkouts(List<Workout> workouts) async {
    logger.d("Updating ${workouts.length} workouts");

    final db = await _getDatabase();
    Batch batch = db.batch();

    for (var workout in workouts) {
      batch.update(
        _workoutTableName,
        workout.toMap(),
        where: 'id = ?',
        whereArgs: [workout.id],
      );
    }

    await batch.commit(noResult: true);
  }

  // Delete workout
  Future<void> deleteWorkout(String id) async {
    logger.d("Deleting workout with ID: $id");

    final db = await _getDatabase();
    await db.delete(
      _workoutTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete interval
  Future<void> deleteInterval(String id) async {
    logger.d("Deleting interval with ID: $id");

    final db = await _getDatabase();
    await db.delete(
      _intervalTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete intervals
  Future<void> deleteIntervalsByWorkoutId(String workoutId) async {
    logger.d("Deleting intervals for workout ID: $workoutId");

    final db = await _getDatabase();
    await db.delete(
      _intervalTableName,
      where: 'workoutId = ?',
      whereArgs: [workoutId],
    );
  }

  // Get all workouts
  Future<List<Workout>> getWorkouts() async {
    logger.d("Getting all workouts");

    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_workoutTableName);
    return maps.map((map) => Workout.fromMap(map)).toList();
  }

  // Get all intervals
  Future<List<IntervalType>> getIntervals() async {
    logger.d("Getting all intervals");

    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_intervalTableName);
    return maps.map((map) => IntervalType.fromMap(map)).toList();
  }
}
