import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final dir = Directory('screenshots');
  if (dir.existsSync()) dir.deleteSync(recursive: true);
  dir.createSync();

  try {
    await integrationDriver(
      onScreenshot: (screenshotName, screenshotBytes, [args]) async {
        final File image = await File('screenshots/$screenshotName.png')
            .create(recursive: true);
        await image.writeAsBytes(screenshotBytes);
        return true;
      },
    );
  } catch (e) {
    print('Error occured: $e');
  }
}
