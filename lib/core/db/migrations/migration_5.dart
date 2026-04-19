import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// migration_5
// upgrade the database from version 6 to version 7
Future<void> migration5(Database db) async {
  await db
      .execute("ALTER TABLE SoundSettingsTable ADD COLUMN breakSound TEXT;");
}
