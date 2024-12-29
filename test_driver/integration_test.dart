import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  // await Process.run(
  //   'adb',
  //   [
  //     'shell',
  //     'appops',
  //     'set',
  //     'com.codepup.workout_timer',
  //     'android.permission.SCHEDULE_EXACT_ALARM',
  //     'allow',
  //   ],
  // );
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
  await integrationDriver(
    onScreenshot: (String name, List<int> bytes,
        [Map<String, Object?>? args]) async {
      final File image =
          await File('screenshots/$name.png').create(recursive: true);
      image.writeAsBytesSync(bytes);
      return true;
    },
  );
}
