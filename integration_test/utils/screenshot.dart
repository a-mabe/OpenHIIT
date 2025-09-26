import 'dart:io';

import 'package:flutter/foundation.dart';

takeScreenShot({binding, tester, String? screenShotName, bool? settle}) async {
  if (kIsWeb) {
    await binding.takeScreenshot(screenShotName);
    return;
  } else if (Platform.isAndroid || Platform.isIOS) {
    try {
      await binding
          .convertFlutterSurfaceToImage()
          .timeout(Duration(seconds: 2));
    } catch (e) {
      print('convert timed out or failed: $e — proceeding to takeScreenshot()');
    }
    if (settle == true || settle == null) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }
  await binding.takeScreenshot(screenShotName);
}
