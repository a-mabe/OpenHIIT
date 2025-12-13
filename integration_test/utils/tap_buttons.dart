import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'pump_and_settle.dart';
import 'screenshot.dart';

/// Taps a widget identified by [ValueKey].
Future<void> tapButtonByKey(
    WidgetTester tester,
    String key,
    String screenShotName,
    IntegrationTestWidgetsFlutterBinding binding,
    bool settle,
    {bool waitForDisappearance = true}) async {
  final buttonFinder = find.byKey(ValueKey(key));
  expect(buttonFinder, findsOneWidget,
      reason: 'Button with key "$key" not found');

  print('Tapping button with key "$key"');

  await pumpUntilFound(tester, buttonFinder, Duration(seconds: 10), settle);

  await tester.tap(buttonFinder);
  if (settle && !waitForDisappearance) {
    await tester.pumpAndSettle(); // let animations / UI updates finish
  } else if (waitForDisappearance) {
    await pumpUntilGone(tester, buttonFinder, Duration(seconds: 30), settle);
  } else {
    for (int i = 0; i < 3; i++) {
      await tester.pump();
    }
  }
  print('Tapped button with key "$key"');
  await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: screenShotName,
      settle: settle);
}

Future<void> tapBackArrow(WidgetTester tester, String screenShotName,
    IntegrationTestWidgetsFlutterBinding binding) async {
  final backButtonFinder = find.byTooltip('Back');
  expect(backButtonFinder, findsOneWidget, reason: 'Back button not found');

  await tester.tap(backButtonFinder);
  await tester.pumpAndSettle(); // let animations / UI updates finish

  await takeScreenShot(
      binding: binding, tester: tester, screenShotName: screenShotName);
}

// If Got it button is present, tap it
Future<void> tapGotItButton(
    WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  final gotItButtonFinder = find.byKey(ValueKey('got_it_button'));
  if (gotItButtonFinder.evaluate().isNotEmpty) {
    await tapButtonByKey(
        tester, 'got_it_button', 'got_it_button', binding, true,
        waitForDisappearance: true);
  }
}
