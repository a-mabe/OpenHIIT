import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../log/log.dart';
import '../old/workout_data_type/workout_type.dart';

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

  /// Initialize the database.
  ///
  Future<Database> initDB() async {
    logger.d("Initializing database");

    /// Get a path to the database.
    ///
    String path = join(await getDatabasesPath(), _databaseName);

    /// The version of the database.
    ///
    int databaseVersion = 6;

    /// The version to start any migrations from.
    ///
    int versionToStartMigration = 2;

    /// If the platform is Windows or Linux, use the FFI database factory.
    /// Full app functionaly for Windows / Linux is not yet available.
    ///
    if (Platform.isWindows || Platform.isLinux) {
      logger.d("Platform is Windows or Linu, using FFI database factory");

      // Initialize FFI
      sqfliteFfiInit();

      // Change the default factory
      databaseFactory = databaseFactoryFfiNoIsolate;

      // Set the path to an in-memory database
      path = inMemoryDatabasePath;
    }

    return await openDatabase(
      path,
      version: databaseVersion,
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
        migrateDatabase(oldVersion, newVersion, db, versionToStartMigration);
      },
    );
  }

  /// Migrate the database from one version to another.
  /// - [oldVersion] The current version of the database.
  /// - [newVersion] The new version of the database.
  /// - [db] The database to migrate.
  /// - [versionToStartMigration] The version to start the migration from.
  ///
  Future<void> migrateDatabase(int oldVersion, int newVersion, Database db,
      int versionToStartMigration) async {
    if (oldVersion == versionToStartMigration) {
      await db.execute("ALTER TABLE WorkoutTable ADD COLUMN colorInt INTEGER;");
    }
    if (oldVersion == versionToStartMigration + 1) {
      await db
          .execute("ALTER TABLE WorkoutTable ADD COLUMN workoutIndex INTEGER;");
    }
    if (oldVersion == versionToStartMigration + 2) {
      await db
          .execute("ALTER TABLE WorkoutTable ADD COLUMN showMinutes INTEGER;");
    }
    if (oldVersion < newVersion) {
      await db
          .execute("ALTER TABLE WorkoutTable ADD COLUMN getReadyTime INTEGER;");
      await db
          .execute("ALTER TABLE WorkoutTable ADD COLUMN breakTime INTEGER;");
      await db
          .execute("ALTER TABLE WorkoutTable ADD COLUMN warmupTime INTEGER;");
      await db
          .execute("ALTER TABLE WorkoutTable ADD COLUMN cooldownTime INTEGER;");
      await db
          .execute("ALTER TABLE WorkoutTable ADD COLUMN iterations INTEGER;");
    }
  }

  /// Inserts the given list into the given database.
  /// - [workout] The workout to insert.
  /// - [database] The database to insert the workout into.
  ///
  Future<void> insertWorkout(Workout workout, Database database) async {
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
  /// - [workout] The workout to update.
  /// - [database] The database to update the workout in.
  ///
  Future<void> updateWorkout(Workout workout, Database database) async {
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

  Future<void> deleteWorkout(String id, Database database) async {
    await database.delete(
      _workoutTableName,
      where: 'id = ?', // Use a `where` clause to delete a specific list.
      whereArgs: [
        id
      ], // Pass the List's id as a whereArg to prevent SQL injection.
    );
  }

  /// Asynchronously deletes a workout list from the database and updates the
  /// workout indices of remaining lists accordingly.
  ///
  /// Parameters:
  ///   - [workoutArgument]: The 'Workout' object representing the list to be deleted.
  ///
  /// Returns:
  ///   - A Future representing the completion of the delete operation.
  Future<void> deleteWorkoutAndReorder(
      Workout workout, Database database) async {
    // Delete the specified workout list from the database.
    await DatabaseManager()
        .deleteWorkout(workout.id, database)
        .then((value) async {
      // Retrieve the updated list of workouts from the database.
      List<Workout> workouts = await DatabaseManager().workouts(database);

      // Sort the workouts based on their workout indices.
      workouts.sort((a, b) => a.workoutIndex.compareTo(b.workoutIndex));

      // Update the workout indices of remaining lists after the deleted list.
      for (int i = workout.workoutIndex; i < workouts.length; i++) {
        workouts[i].workoutIndex = i;
        await DatabaseManager()
            .updateWorkout(workouts[i], await DatabaseManager().initDB());
      }
    });
  }

  Future<List<Workout>> workouts(Database database) async {
    /// Query the table for all the TodoLists.
    ///
    final List<Map<String, dynamic>> maps =
        await database.query(_workoutTableName);

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
