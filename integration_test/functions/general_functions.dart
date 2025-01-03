import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> tapInfo(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.info_outline));
  await tester.pumpAndSettle();
  expect(find.text("About OpenHIIT"), findsOneWidget);
}

Future<void> closeDialog(WidgetTester tester) async {
  await tester.tap(find.text("Close"));
  await tester.pumpAndSettle();
}
