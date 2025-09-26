import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'misc.dart';
import 'screenshot.dart';

/// Taps a widget identified by [ValueKey].
Future<void> tapButtonByKey(
    WidgetTester tester,
    String key,
    String screenShotName,
    IntegrationTestWidgetsFlutterBinding binding,
    bool settle) async {
  final buttonFinder = find.byKey(ValueKey(key));
  expect(buttonFinder, findsOneWidget,
      reason: 'Button with key "$key" not found');

  print('Tapping button with key "$key"');
  await tester.tap(buttonFinder);
  if (settle) {
    await tester.pumpAndSettle(); // let animations / UI updates finish
  } else {
    await pumpUntilGone(tester, buttonFinder, Duration(seconds: 1), settle);
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
