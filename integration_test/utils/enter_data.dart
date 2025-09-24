import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Enters [text] into a [TextFormField] or [TextField] identified by [ValueKey].
Future<void> enterTextByKey(
    WidgetTester tester, String key, String text) async {
  final fieldFinder = find.byKey(ValueKey(key));
  expect(fieldFinder, findsOneWidget,
      reason: 'Form field with key "$key" not found');

  await tester.enterText(fieldFinder, text);
  await tester.pumpAndSettle(); // settle animations / validations
}
