import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Taps a widget identified by [ValueKey].
Future<void> tapButtonByKey(WidgetTester tester, String key) async {
  final buttonFinder = find.byKey(ValueKey(key));
  expect(buttonFinder, findsOneWidget,
      reason: 'Button with key "$key" not found');

  await tester.tap(buttonFinder);
  await tester.pumpAndSettle(); // let animations / UI updates finish
}
