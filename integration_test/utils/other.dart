import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> closeKeyboard(WidgetTester tester, bool settle) async {
  // Tap outside to close the keyboard
  FocusManager.instance.primaryFocus?.unfocus();
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

Future<void> tapJustRightOfCenter(WidgetTester tester, bool settle) async {
  // Get the screen size
  final screenSize = tester.binding.renderView.size;
  // Calculate a position a little to the right of the center of the screen
  final center = Offset(screenSize.width / 2, screenSize.height / 2);
  final tapPosition = Offset(center.dx + screenSize.width * 0.25, center.dy);

  await tester.tapAt(tapPosition);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

Future<void> tapJustBelowCenterAndSlightlyLeft(
    WidgetTester tester, bool settle) async {
  // Get the screen size
  final screenSize = tester.binding.renderView.size;
  // Calculate a position a little below the center of the screen
  final center = Offset(screenSize.width / 2, screenSize.height / 2);
  final tapPosition = Offset(center.dx - screenSize.width * 0.125,
      center.dy + screenSize.height * 0.125);

  await tester.tapAt(tapPosition);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}
