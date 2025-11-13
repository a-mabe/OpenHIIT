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
}
