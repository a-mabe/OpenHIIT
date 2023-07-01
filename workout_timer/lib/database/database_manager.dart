/// Copyright (C) 2021 Abigail Mabe - All Rights Reserved
/// You may use, distribute and modify this code under the terms
/// of the license.
///
/// You should have received a copy of the license with this file.
/// If not, please email <mabe.abby.a@gmail.com>
///
/// Defines the Database Manager class which defines the database
/// and its helper functions.
///

import 'dart:async';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../workout_type/workout_type.dart';

class DatabaseManager {
  ///
  /// -------------
  /// FIELDS
  /// -------------
  ///

  /// The name of the database.
  ///
  /// e.g., "database.db"
  ///
  static const String databaseName = "workouts.db";

  /// The name of the table in the database where workouts are stored.
  ///
  /// e.g., "workouts"
  ///
  static const String workoutTableName = "WorkoutTable";

  /// The name of the table in the database where exercises are stored.
  ///
  /// e.g., "exercises"
  ///
  // static const String exerciseTableName = "exercises";

  ///
  /// -------------
  /// END FIELDS
  /// -------------
  ///

  ///
  /// -------------
  /// GETTERS/SETTERS
  /// -------------
  ///

  ///
  /// -------------
  /// END GETTERS/SETTERS
  /// -------------
  ///

  ///
  /// -------------
  /// CONSTRUCTORS
  /// -------------
  ///

  ///
  /// -------------
  /// END CONSTRUCTORS
  /// -------------
  ///

  ///
  /// -------------
  /// FUNCTIONS
  /// -------------
  ///

  /// Opens the database.
  ///
  // Future<Database> open() async {

  //   String path = join(await getDatabasesPath(), "core1.db");
  //   await deleteDatabase(path);

  //   return openDatabase(
  //     // Set the path to the database. Note: Using the `join` function from the
  //     // `path` package is best practice to ensure the path is correctly
  //     // constructed for each platform.
  //     join(await getDatabasesPath(), databaseName),

  //     // When the database is first created, create a table to store workouts.
  //     onCreate: (db, version) async {
  //       // Run the CREATE TABLE statement on the database.
  //       await db.execute(
  //         '''
  //         CREATE TABLE WorkoutTable(id TEXT PRIMARY KEY,
  //         title TEXT,
  //         numExercises INTEGER,
  //         exercises TEXT,
  //         exerciseTime INTEGER,
  //         restTime INTEGER,
  //         halfTime INTEGER
  //         )
  //         ''',
  //       );
  //       // db.execute(
  //       //   '''
  //       //   CREATE TABLE items(listId TEXT PRIMARY KEY,
  //       //   id TEXT,
  //       //   title TEXT,
  //       //   description TEXT,
  //       //   icon TEXT,
  //       //   status INTEGER
  //       //   )
  //       //   ''',
  //       // );
  //       log("Created the DB.");
  //     },
  //     // Set the version. This executes the onCreate function and provides a
  //     // path to perform database upgrades and downgrades.
  //     version: 1,
  //   );
  // }
  Future<Database> initDB() async {
    print("initDB executed");
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(await getDatabasesPath(), "core1.db");
    // Clear database for testing
    // await deleteDatabase(path);
    return await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''
            CREATE TABLE WorkoutTable(id TEXT PRIMARY KEY,
            title TEXT,
            numExercises INTEGER,
            exercises TEXT,
            exerciseTime INTEGER,
            restTime INTEGER,
            halfTime INTEGER
            )
            ''');
      /*await db.execute(tableEmployee +
          tableAudit +
          tableProject +
          tableJobPosition +
          tableWorkType +
          tableAssignedJobPosition +
          tableTimeTrack +
          tableAllowedWorkType);*/
    });
  }

  /// Inserts the given list into the given database.
  ///
  Future<void> insertList(Workout workout, Database database) async {
    /// Get a reference to the database.
    ///
    final db = database;

    log(workout.toString());

    /// Insert the TodoList into the correct table.
    ///
    /// In this case, replace any previous data.
    ///
    await db.insert(
      workoutTableName,
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Inserts the given item into the given database.
  ///
  // Future<void> insertItem(List<String> exercises, Future<Database> database) async {
  //   /// Get a reference to the database.
  //   ///
  //   final db = await database;

  //   /// Insert the TodoList into the correct table.
  //   ///
  //   /// In this case, replace any previous data.
  //   ///
  //   await db.insert(
  //     exerciseTableName,
  //     exercises.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  /// Update the given list in the given database.
  ///
  Future<void> updateList(Workout workout, Database database) async {
    /// Get a reference to the database.
    ///
    final db = await database;

    await db.update(
      workoutTableName,
      workout.toMap(),
      where: 'id = ?', // Ensure that the List has a matching id.
      whereArgs: [
        workout.id
      ], // Pass the id as a whereArg to prevent SQL injection.
    );
  }

  /// Update the given item in the given database.
  ///
  // Future<void> updateItems(TodoItem todoItem, Future<Database> database) async {
  //   /// Get a reference to the database.
  //   ///
  //   final db = await database;

  //   await db.update(
  //     listTableName,
  //     todoItem.toMap(),
  //     where: 'id = ?', // Ensure that the List has a matching id.
  //     whereArgs: [
  //       todoItem.id
  //     ], // Pass the id as a whereArg to prevent SQL injection.
  //   );
  // }

  Future<void> deleteList(String id, Future<Database> database) async {
    /// Get a reference to the database.
    ///
    final db = await database;

    await db.delete(
      workoutTableName,
      where: 'id = ?', // Use a `where` clause to delete a specific list.
      whereArgs: [
        id
      ], // Pass the List's id as a whereArg to prevent SQL injection.
    );
  }

  // Future<void> deleteItem(int id, Future<Database> database) async {
  //   /// Get a reference to the database.
  //   ///
  //   final db = await database;

  //   await db.delete(
  //     listTableName,
  //     where: 'id = ?', // Use a `where` clause to delete a specific list.
  //     whereArgs: [
  //       id
  //     ], // Pass the List's id as a whereArg to prevent SQL injection.
  //   );
  // }

  Future<List<Workout>> lists(Future<Database> database) async {
    /// Get a reference to the database.
    ///
    final db = await database;

    /// Query the table for all the TodoLists.
    ///
    final List<Map<String, dynamic>> maps = await db.query(workoutTableName);

    /// Convert the List<Map<String, dynamic> into a List<TodoList>.
    ///
    return List.generate(maps.length, (i) {
      return Workout(
          maps[i]['id'],
          maps[i]['title'],
          maps[i]['numExercises'],
          maps[i]['exercises'],
          maps[i]['exerciseTime'],
          maps[i]['restTime'],
          maps[i]['halfTime']);
    });
  }

  // Future<List<TodoItem>> items(Future<Database> database) async {
  //   /// Get a reference to the database.
  //   ///
  //   final db = await database;

  //   /// Query the table for all the TodoItems.
  //   ///
  //   final List<Map<String, dynamic>> maps = await db.query(itemTableName);

  //   /// Convert the List<Map<String, dynamic> into a List<TodoItem>.
  //   ///
  //   return List.generate(maps.length, (i) {
  //     return TodoItem(
  //       title: maps[i]['title'],
  //       description: maps[i]['description'],
  //       icon: maps[i]['icon'],
  //       status: maps[i]['status'],
  //       id: maps[i]['id'],
  //       listId: maps[i]['listId'],
  //     );
  //   });
  // }

  ///
  /// -------------
  /// END FUNCTIONS
  /// -------------
  ///
}
