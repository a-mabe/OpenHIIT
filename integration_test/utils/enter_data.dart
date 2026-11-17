import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'pump_and_settle.dart';
import 'screenshot.dart';

/// Enters [text] into a [TextFormField] or [TextField] identified by [ValueKey].
Future<void> enterTextByKey(WidgetTester tester, String key, String text,
    String screenShotName, IntegrationTestWidgetsFlutterBinding binding) async {
  final fieldFinder = find.byKey(ValueKey(key));
  await _enterText(tester, fieldFinder, text, 'field "$key"');
  await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: screenShotName,
      settle: true);
}

/// Enters [text] into the [descendantIndex]-th [TextField] under the widget
/// identified by [key], such as the minutes or seconds box of a time input.
Future<void> enterTextInDescendantByKey(
    WidgetTester tester,
    String key,
    String text,
    int descendantIndex,
    String screenShotName,
    IntegrationTestWidgetsFlutterBinding binding) async {
  final allFields = find.descendant(
      of: find.byKey(ValueKey(key)), matching: find.byType(TextField));
  await waitUntil(tester, () => allFields.evaluate().length > descendantIndex,
      description: 'TextField #$descendantIndex under "$key"');
  await _enterText(tester, allFields.at(descendantIndex), text,
      'field "$key"[$descendantIndex]');
  await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: screenShotName,
      settle: true);
}

Future<void> _enterText(
    WidgetTester tester, Finder fieldFinder, String text, String label) async {
  await waitFor(tester, fieldFinder);
  expect(fieldFinder, findsOneWidget, reason: '$label is not unique');

  // Fields lower in the form can be scrolled off screen or hidden behind the
  // keyboard after earlier input.
  await tester.ensureVisible(fieldFinder);
  await tester.pump();

  debugPrint('Entering "$text" into $label');
  await tester.enterText(fieldFinder, text);
  await settleBriefly(tester);
}
