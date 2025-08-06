import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// migration_1
// upgrade the database from version 2 to version 3
Future<void> migration1(Database db) async {
  await db.execute("ALTER TABLE workouts ADD COLUMN colorInt INTEGER;");
}

// migration_2
// upgrade the database from version 3 to version 4
Future<void> migration2(Database db) async {
  await db.execute("ALTER TABLE workouts ADD COLUMN showMinutes INTEGER;");
}

// migration_3
// upgrade the database from version 4 to version 5
Future<void> migration3(Database db) async {
  await db.execute("ALTER TABLE workouts ADD COLUMN workoutIndex INTEGER;");
}

// migration_4
// upgrade the database from version 5 to version 6
Future<void> migration4(Database db) async {
  await db.execute("ALTER TABLE workouts ADD COLUMN countdownSound TEXT;");
  await db.execute("ALTER TABLE workouts ADD COLUMN colorInt INTEGER;");
  await db.execute("ALTER TABLE workouts ADD COLUMN workoutIndex INTEGER;");
  await db.execute("ALTER TABLE workouts ADD COLUMN showMinutes INTEGER;");
}
