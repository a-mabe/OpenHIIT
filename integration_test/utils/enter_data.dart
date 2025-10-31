import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'screenshot.dart';

/// Enters [text] into a [TextFormField] or [TextField] identified by [ValueKey].
Future<void> enterTextByKey(WidgetTester tester, String key, String text,
    String screenShotName, IntegrationTestWidgetsFlutterBinding binding) async {
  final fieldFinder = find.byKey(ValueKey(key));
  expect(fieldFinder, findsOneWidget,
      reason: 'Form field with key "$key" not found');
  print('Entering text "$text" into field with key "$key"');
  await tester.enterText(fieldFinder, text);
  await tester.pumpAndSettle(); // settle animations / validations
  print('Entered text "$text" into field with key "$key"');
  await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: screenShotName,
      settle: true);
}

Future<void> enterTextInDescendantByKey(
    WidgetTester tester,
    String key,
    String text,
    int descendantIndex,
    String screenShotName,
    IntegrationTestWidgetsFlutterBinding binding) async {
  final fieldFinder = find.descendant(
      of: find.byKey(ValueKey(key)), matching: find.byType(TextField));
  expect(fieldFinder, findsAtLeast(descendantIndex + 1),
      reason: 'Descendant TextField with key "$key" not found');
  final targetField = fieldFinder.at(descendantIndex);
  print(
      'Entering text "$text" into descendant field with key "$key" at index $descendantIndex');
  await tester.enterText(targetField, text);
  await tester.pumpAndSettle(); // settle animations / validations
  print('Entered text "$text" into descendant field with key "$key"');
  await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: screenShotName,
      settle: true);
}
