import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() async {
  await Process.run(
    'adb',
    [
      'shell',
      'pm',
      'grant',
      'com.codepup.workout_timer',
      'android.permission.SCHEDULE_EXACT_ALARM',
    ],
  );
  // await Process.run(
  //   'adb',
  //   [
  //     'shell',
  //     'pm',
  //     'grant',
  //     'com.codepup.workout_timer',
  //     'android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK',
  //   ],
  // );
  // await Process.run(
  //   'adb',
  //   [
  //     'shell',
  //     'pm',
  //     'grant',
  //     'com.codepup.workout_timer',
  //     'android.permission.FOREGROUND_SERVICE',
  //   ],
  // );
  await integrationDriver();
}
