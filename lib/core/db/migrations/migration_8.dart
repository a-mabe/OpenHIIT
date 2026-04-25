import 'package:openhiit/core/logs/logs.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> migration5(Database db) async {} // no-op
Future<void> migration6(Database db) async {} // no-op
Future<void> migration7(Database db) async {} // no-op
Future<void> migration8(Database db) async {
  Log.debug(
      "Running migration 5: Adding breakSound column to SoundSettingsTable");
  await db
      .execute("ALTER TABLE SoundSettingsTable ADD COLUMN breakSound TEXT;");
}
