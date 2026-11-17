import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'app.dart';
import 'pump_and_settle.dart';
import 'screenshot.dart';

/// Taps the widget with [key] once it is actually tappable.
///
/// If [waitForDisappearance] is true (the default), waits until the widget is
/// gone afterwards. Use that when the tap navigates away or closes a dialog.
/// Otherwise the UI is briefly settled if [settle] is true, or just pumped.
Future<void> tapButtonByKey(
    WidgetTester tester,
    String key,
    String screenShotName,
    IntegrationTestWidgetsFlutterBinding binding,
    bool settle,
    {bool waitForDisappearance = true}) async {
  final buttonFinder = find.byKey(ValueKey(key));

  await waitForTappable(tester, buttonFinder);
  debugPrint('Tapping button with key "$key"');
  await tester.tap(buttonFinder);

  if (waitForDisappearance) {
    await waitForGone(tester, buttonFinder,
        timeout: const Duration(seconds: 30));
  } else if (settle) {
    await settleBriefly(tester);
  } else {
    await tester.pump();
  }
  debugPrint('Tapped button with key "$key"');

  await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: screenShotName,
      settle: settle);
}

final Finder _startSaveButton = find.byKey(const ValueKey('start-save-button'));

Finder _startSaveLabel(String label) =>
    find.descendant(of: _startSaveButton, matching: find.text(label));

/// Taps the "Save" button on the edit screen and waits until the save
/// has finished, which is when the button turns into "Start".
///
/// Saving writes to the database asynchronously. Going back or tapping
/// "Start" before it finishes was a major source of flakiness: the tap
/// landed on the disabled "Saving" button, or the home list loaded stale
/// data.
Future<void> tapSaveButton(WidgetTester tester, String screenShotName,
    IntegrationTestWidgetsFlutterBinding binding) async {
  await waitFor(tester, _startSaveLabel('Save'));
  await waitForTappable(tester, _startSaveButton);
  debugPrint('Tapping Save');
  await tester.tap(_startSaveButton);

  // Saving can fail validation and revert to "Save", so wait for "Start"
  // specifically. That way the test fails here, with a clear message.
  await waitFor(tester, _startSaveLabel('Start'),
      timeout: const Duration(seconds: 20));
  await waitForTappable(tester, _startSaveButton);
  debugPrint('Save completed');

  // The "Start" label shimmers forever, so don't try to settle.
  await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: screenShotName,
      settle: false);
}

/// Taps the "Start" button on the edit screen and waits for the running
/// timer screen to appear.
Future<void> tapStartButton(WidgetTester tester, String screenShotName,
    IntegrationTestWidgetsFlutterBinding binding) async {
  await waitFor(tester, _startSaveLabel('Start'));
  await waitForTappable(tester, _startSaveButton);
  debugPrint('Tapping Start');
  await tester.tap(_startSaveButton);

  await waitFor(
      tester, find.byKey(const ValueKey('run-timer-appbar-back-button')),
      timeout: const Duration(seconds: 20));
  debugPrint('Timer screen shown');

  // The running timer never settles.
  await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: screenShotName,
      settle: false);
}

/// Taps the app bar back arrow on the edit screen and waits until the home
/// screen has reloaded its timer list.
Future<void> tapBackArrow(WidgetTester tester, String screenShotName,
    IntegrationTestWidgetsFlutterBinding binding) async {
  final backButtonFinder = find.byTooltip('Back');
  await waitForTappable(tester, backButtonFinder);
  await tester.tap(backButtonFinder);

  await waitForGone(tester, backButtonFinder);
  await waitForHomeLoaded(tester);

  await takeScreenShot(
      binding: binding, tester: tester, screenShotName: screenShotName);
}

/// Dismisses the "What's new" dialog if it is showing.
///
/// [launchApp] marks the dialog as already seen, so it normally never
/// appears. This remains as a fallback.
Future<void> tapGotItButton(
    WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  final gotItButtonFinder = find.byKey(const ValueKey('got_it_button'));
  if (gotItButtonFinder.evaluate().isNotEmpty) {
    await tapButtonByKey(
        tester, 'got_it_button', 'got_it_button', binding, true,
        waitForDisappearance: true);
  }
}
