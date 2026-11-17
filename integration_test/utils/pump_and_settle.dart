import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'screenshot.dart';

/// How often the condition-based waits below re-check the widget tree.
///
/// Small enough not to miss short-lived states (e.g. a 3s interval), large
/// enough not to burn CPU on slow CI emulators.
const Duration pollInterval = Duration(milliseconds: 100);

/// Pumps frames until [condition] returns true, or fails the test after
/// [timeout].
///
/// This is the building block for every wait in these tests. Prefer it over
/// fixed delays (`pump(Duration(seconds: n))`) and over `pumpAndSettle`, which
/// never returns on screens with endless animations (the shimmering "Start"
/// button, the running timer).
Future<void> waitUntil(
  WidgetTester tester,
  bool Function() condition, {
  required String description,
  Duration timeout = const Duration(seconds: 15),
}) async {
  final stopwatch = Stopwatch()..start();
  while (true) {
    await tester.pump(pollInterval);
    if (condition()) return;
    if (stopwatch.elapsed > timeout) {
      throw TestFailure('Timed out after $timeout waiting for $description');
    }
  }
}

/// Waits until [finder] matches at least one widget.
Future<void> waitFor(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 15)}) {
  return waitUntil(tester, () => finder.evaluate().isNotEmpty,
      description: finder.describeMatch(Plurality.one), timeout: timeout);
}

/// Waits until [finder] matches no widgets.
Future<void> waitForGone(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 15)}) {
  return waitUntil(tester, () => finder.evaluate().isEmpty,
      description: 'no ${finder.describeMatch(Plurality.many)}',
      timeout: timeout);
}

/// Waits until exactly one widget matches [finder], it can receive a tap at
/// its center (not covered by a dialog, barrier, or mid-transition route),
/// it is enabled, and it has stopped moving.
///
/// Tapping before all of these hold is the most common source of flakiness:
/// the tap lands on an overlay, on a disabled "Saving" button, or on the spot
/// where an animating widget used to be.
Future<void> waitForTappable(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 15)}) {
  Offset? lastCenter;
  return waitUntil(
    tester,
    () {
      final hittable = finder.hitTestable().evaluate();
      if (hittable.length != 1) {
        lastCenter = null;
        return false;
      }
      if (!_isEnabled(hittable.single.widget)) {
        lastCenter = null;
        return false;
      }
      final center = tester.getCenter(finder);
      final stable = center == lastCenter;
      lastCenter = center;
      return stable;
    },
    description:
        'exactly one enabled, hit-testable, stationary ${finder.describeMatch(Plurality.one)}',
    timeout: timeout,
  );
}

bool _isEnabled(Widget widget) {
  if (widget is FloatingActionButton) return widget.onPressed != null;
  if (widget is ButtonStyleButton) return widget.onPressed != null;
  if (widget is IconButton) return widget.onPressed != null;
  if (widget is InkWell) return widget.onTap != null;
  if (widget is ListTile) return widget.enabled;
  return true;
}

/// Like `pumpAndSettle`, but gives up quietly after [timeout] instead of
/// failing.
///
/// Use this for cosmetic settling (before a screenshot, after typing) where
/// the screen may legitimately never settle. Never use it as a substitute for
/// waiting on a real condition.
Future<void> settleBriefly(WidgetTester tester,
    {Duration timeout = const Duration(seconds: 3)}) async {
  try {
    await tester.pumpAndSettle(
        pollInterval, EnginePhase.sendSemanticsUpdate, timeout);
  } on FlutterError catch (e) {
    if (!e.message.contains('pumpAndSettle timed out')) rethrow;
    debugPrint('settleBriefly: UI still animating after $timeout, continuing');
  }
}

Future<void> _maybeScreenshot(WidgetTester tester, String? screenShotName,
    {required bool settle}) async {
  if (screenShotName == null) return;
  await takeScreenShot(
      binding: IntegrationTestWidgetsFlutterBinding.instance,
      tester: tester,
      screenShotName: screenShotName,
      settle: settle);
}

/// Waits until [finder] matches, then optionally takes a screenshot.
///
/// Pass `settle: false` while a timer is running so the screenshot does not
/// wait on the constantly updating UI.
Future<void> pumpUntilFound(
    WidgetTester tester, Finder finder, Duration timeout, bool settle,
    {String? screenShotName}) async {
  await waitFor(tester, finder, timeout: timeout);
  await _maybeScreenshot(tester, screenShotName, settle: settle);
}

/// Waits until [finder] no longer matches, then optionally takes a screenshot.
Future<void> pumpUntilGone(
    WidgetTester tester, Finder finder, Duration timeout, bool settle,
    {String? screenShotName}) async {
  await waitForGone(tester, finder, timeout: timeout);
  await _maybeScreenshot(tester, screenShotName, settle: settle);
}
