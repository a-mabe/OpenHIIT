import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'pump_and_settle.dart';

bool _surfaceConverted = false;

/// Takes a screenshot named [screenShotName].
///
/// [settle] (default true) briefly lets animations finish first. It is
/// bounded, so it is safe on screens that never settle, but pass `false`
/// while a timer is running to avoid delaying the test.
Future<void> takeScreenShot({
  required IntegrationTestWidgetsFlutterBinding binding,
  required WidgetTester tester,
  required String screenShotName,
  bool? settle,
}) async {
  // On Android the Flutter surface has to be converted to an image before
  // screenshots can be captured. This must only happen once per app run:
  // repeated calls are what used to hang and need the 10s timeout.
  if (!kIsWeb && Platform.isAndroid && !_surfaceConverted) {
    _surfaceConverted = true;
    try {
      await binding
          .convertFlutterSurfaceToImage()
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('convertFlutterSurfaceToImage failed: $e');
    }
  }

  if (settle ?? true) {
    await settleBriefly(tester);
  } else {
    await tester.pump();
  }
  await binding.takeScreenshot(screenShotName);
}
