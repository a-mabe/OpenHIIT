import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'pump_and_settle.dart';

/// Unfocuses the current field and waits for the software keyboard to close.
///
/// The keyboard slides away over a few hundred milliseconds and the layout
/// (including the floating Save/Start button) moves with it, so a tap right
/// after unfocusing can miss. [settle] additionally lets other animations
/// finish briefly.
Future<void> closeKeyboard(WidgetTester tester, bool settle) async {
  FocusManager.instance.primaryFocus?.unfocus();
  try {
    await waitUntil(tester, () => tester.view.viewInsets.bottom == 0,
        description: 'keyboard to close', timeout: const Duration(seconds: 5));
  } on TestFailure {
    // A hardware keyboard or an unusual IME can keep insets non-zero. Carry
    // on, since the tap helpers check that their target is tappable anyway.
    debugPrint('closeKeyboard: view insets still non-zero, continuing');
  }
  if (settle) {
    await settleBriefly(tester);
  } else {
    await tester.pump();
  }
}

/// Taps a point slightly below and left of the screen center, such as a
/// color swatch in the color picker dialog.
Future<void> tapJustBelowCenterAndSlightlyLeft(
    WidgetTester tester, bool settle) async {
  final screenSize = tester.view.physicalSize / tester.view.devicePixelRatio;
  final center = Offset(screenSize.width / 2, screenSize.height / 2);
  final tapPosition = Offset(center.dx - screenSize.width * 0.05,
      center.dy + screenSize.height * 0.05);

  await tester.tapAt(tapPosition);
  if (settle) {
    await settleBriefly(tester);
  } else {
    await tester.pump();
  }
}
