import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'migrations_1_to_4.dart';
import 'migration_8.dart';

final Map<int, Future<void> Function(Database db)> migrations = {
  1: migration1,
  2: migration2,
  3: migration3,
  4: migration4,
  5: migration5,
  6: migration6,
  7: migration7,
  8: migration8,
};
