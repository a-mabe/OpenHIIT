import 'dart:async';
import 'dart:io';
import 'package:openhiit/utils/log/log.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../models/workout_type.dart';

class DatabaseManager {
  static const String _databaseName = "core1.db";
  static const String _workoutTableName = "WorkoutTable";
  Database? _database;

  DatabaseManager() {
    _initPlatformDatabaseSettings();
  }

  void _initPlatformDatabaseSettings() {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfiNoIsolate;
    }
  }

  Future<Database> _getDatabase() async {
    if (_database != null) return _database!;
    return _database = await openWorkoutDatabase();
  }

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

    String path = join(await getDatabasesPath(), _databaseName);
    String dbPath =
        (Platform.isWindows || Platform.isLinux) ? inMemoryDatabasePath : path;
    int dbVersion = (Platform.isWindows || Platform.isLinux) ? 5 : 6;

    return openDatabase(
      dbPath,
      version: dbVersion,
      onCreate: (db, version) async {
        await db.execute(createWorkoutTableQuery);
      },
      onUpgrade: _handleUpgrade,
    );
  }

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
  }

  Future<void> insertWorkout(Workout workout) async {
    logger.d("Inserting workout: ${workout.title}");

    final db = await _getDatabase();
    await db.insert(
      _workoutTableName,
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

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

  Future<void> deleteWorkout(String id) async {
    logger.d("Deleting workout with ID: $id");

    final db = await _getDatabase();
    await db.delete(
      _workoutTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Workout>> getWorkouts() async {
    logger.d("Getting all workouts");

    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_workoutTableName);
    return maps.map((map) => Workout.fromMap(map)).toList();
  }
}
