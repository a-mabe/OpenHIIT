import 'package:logger/logger.dart';
import 'package:openhiit/core/db/migrations/migration_index.dart';
import 'package:openhiit/core/db/tables.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

var logger = Logger(
  printer: JsonLogPrinter('DatabaseManager'),
  level: Level.info,
);

Future<void> runMigrations(Database db, int oldVersion, int newVersion) async {
  if (oldVersion != newVersion) {
    logger.i("Upgrading database from $oldVersion to $newVersion");
  }

  for (int i = oldVersion; i < newVersion; i++) {
    final migration = migrations[i];
    if (migration != null) {
      await migration(db);
    }
  }

  // Table creation logic on fresh install (optional)
  if (oldVersion < newVersion) {
    await db.execute(createIntervalTableQuery);
    await db.execute(createTimerTableQuery);
    await db.execute(createTimeSettingsTableQuery);
    await db.execute(createSoundSettingsTableQuery);
  }
}
