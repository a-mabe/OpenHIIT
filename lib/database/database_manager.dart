import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../workout_data_type/workout_type.dart';

class DatabaseManager {
  /// The name of the database.
  ///
  /// e.g., "database.db"
  ///
  static const String _databaseName = "core1.db";

  /// The name of the table in the database where workouts are stored.
  ///
  /// e.g., "workouts"
  ///
  static const String _workoutTableName = "WorkoutTable";

  Future<Database> initDB() async {
    debugPrint("initDB executed");

    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory
      databaseFactory = databaseFactoryFfiNoIsolate;
    }

    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(await getDatabasesPath(), _databaseName);
    // Clear database for testing
    // await deleteDatabase(path);
    if (Platform.isWindows || Platform.isLinux) {
      return await openDatabase(
        inMemoryDatabasePath,
        version: 5,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS WorkoutTable(id TEXT PRIMARY KEY,
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
            ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion == 1) {
            await db.execute(
                "ALTER TABLE WorkoutTable ADD COLUMN colorInt INTEGER;");
          }
          if (oldVersion == 2) {
            await db.execute(
                "ALTER TABLE WorkoutTable ADD COLUMN workoutIndex INTEGER;");
          }
          if (oldVersion == 3) {
            await db.execute(
                "ALTER TABLE WorkoutTable ADD COLUMN showMinutes INTEGER;");
          }
          if (oldVersion < newVersion) {
            print("Add columns");
            await db.execute(
                "ALTER TABLE WorkoutTable ADD COLUMN getReadyTime INTEGER;");
            await db.execute(
                "ALTER TABLE WorkoutTable ADD COLUMN breakTime INTEGER;");
            await db.execute(
                "ALTER TABLE WorkoutTable ADD COLUMN warmupTime INTEGER;");
            await db.execute(
                "ALTER TABLE WorkoutTable ADD COLUMN cooldownTime INTEGER;");
            await db.execute(
                "ALTER TABLE WorkoutTable ADD COLUMN iterations INTEGER;");
          }
        },
      );
    }
    return await openDatabase(
      path,
      version: 6,
      onCreate: (Database db, int version) async {
        await db.execute('''
            CREATE TABLE IF NOT EXISTS WorkoutTable(id TEXT PRIMARY KEY,
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
            ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion == 2) {
          await db
              .execute("ALTER TABLE WorkoutTable ADD COLUMN colorInt INTEGER;");
        }
        if (oldVersion == 3) {
          await db.execute(
              "ALTER TABLE WorkoutTable ADD COLUMN workoutIndex INTEGER;");
        }
        if (oldVersion == 4) {
          await db.execute(
              "ALTER TABLE WorkoutTable ADD COLUMN showMinutes INTEGER;");
        }
        if (oldVersion < newVersion) {
          print("Add columns");
          await db.execute(
              "ALTER TABLE WorkoutTable ADD COLUMN getReadyTime INTEGER;");
          await db.execute(
              "ALTER TABLE WorkoutTable ADD COLUMN breakTime INTEGER;");
          await db.execute(
              "ALTER TABLE WorkoutTable ADD COLUMN warmupTime INTEGER;");
          await db.execute(
              "ALTER TABLE WorkoutTable ADD COLUMN cooldownTime INTEGER;");
          await db.execute(
              "ALTER TABLE WorkoutTable ADD COLUMN iterations INTEGER;");
        }
      },
    );
  }

  /// Inserts the given list into the given database.
  ///
  Future<void> insertList(Workout workout, Database database) async {
    /// Get a reference to the database.
    ///
    final db = database;

    /// Insert the TodoList into the correct table.
    ///
    /// In this case, replace any previous data.
    ///
    await db.insert(
      _workoutTableName,
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /// Update the given list in the given database.
  ///
  Future<void> updateList(Workout workout, Database database) async {
    /// Get a reference to the database.
    ///
    final db = database;

    await db.update(
      _workoutTableName,
      workout.toMap(),
      where: 'id = ?', // Ensure that the List has a matching id.
      whereArgs: [
        workout.id
      ], // Pass the id as a whereArg to prevent SQL injection.
    );
  }

  Future<void> deleteList(String id, Future<Database> database) async {
    /// Get a reference to the database.
    ///
    final db = await database;

    await db.delete(
      _workoutTableName,
      where: 'id = ?', // Use a `where` clause to delete a specific list.
      whereArgs: [
        id
      ], // Pass the List's id as a whereArg to prevent SQL injection.
    );
  }

  Future<List<Workout>> lists(Future<Database> database) async {
    /// Get a reference to the database.
    ///
    final db = await database;

    /// Query the table for all the TodoLists.
    ///
    final List<Map<String, dynamic>> maps = await db.query(_workoutTableName);

    /// Convert the List<Map<String, dynamic> into a List<TodoList>.
    ///
    return List.generate(maps.length, (i) {
      return Workout(
          maps[i]['id'],
          maps[i]['title'],
          maps[i]['numExercises'],
          maps[i]['exercises'],
          maps[i]['getReadyTime'] ?? 10,
          maps[i]['exerciseTime'],
          maps[i]['restTime'],
          maps[i]['halfTime'],
          maps[i]['breakTime'] ?? 0,
          maps[i]['warmupTime'] ?? 0,
          maps[i]['cooldownTime'] ?? 0,
          maps[i]['iterations'] ?? 0,
          maps[i]['halfwayMark'],
          maps[i]['workSound'],
          maps[i]['restSound'],
          maps[i]['halfwaySound'],
          maps[i]['completeSound'],
          maps[i]['countdownSound'],
          maps[i]['colorInt'] ??
              4280391411, // Default to blue if no previous color selected
          maps[i]['workoutIndex'] ??
              i, // Default to the current index if no index change passed
          maps[i]['showMinutes'] ?? 0 // Default to 0 if no previous selection
          );
    });
  }

  ///
  /// -------------
  /// END FUNCTIONS
  /// -------------
  ///
}
