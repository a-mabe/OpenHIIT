import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils/app.dart';
import 'utils/enter_data.dart';
import 'utils/pump_and_settle.dart';
import 'utils/screenshot.dart';
import 'utils/tap_buttons.dart';
import 'utils/other.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Finder activeIntervalsShowing(String value) => find.descendant(
      of: find.byKey(const ValueKey('active-intervals')),
      matching: find.text(value));

  testWidgets('adjust_intervals_in_existing_timer',
      (WidgetTester tester) async {
    await launchApp(tester);

    // Tap "Got it!" to dismiss the welcome screen.
    await tapGotItButton(tester, binding);

    // Create a new timer for interval testing.
    await tapButtonByKey(
        tester, 'new-timer', '1_intervals_new-timer', binding, true);
    await enterTextByKey(tester, 'timer-name', 'Interval Adjuster',
        '2_intervals_timer-name', binding);
    await enterTextByKey(tester, 'active-intervals', '2',
        '3_intervals_initial-active-intervals', binding);
    await enterTextByKey(
        tester, 'work-time', '4', '4_intervals_work-time', binding);
    await enterTextByKey(
        tester, 'rest-time', '3', '5_intervals_rest-time', binding);
    await closeKeyboard(tester, false);
    await tapSaveButton(tester, '6_intervals_save', binding);
    await tapBackArrow(tester, '7_intervals_back-home', binding);

    // Open and edit timer.
    await tapButtonByKey(tester, 'Interval Adjuster-0',
        '8_intervals_open-timer', binding, false);

    // Increase active intervals.
    await enterTextByKey(tester, 'active-intervals', '4',
        '10_intervals_increase-active', binding);
    await closeKeyboard(tester, false);
    await tapSaveButton(tester, '11_intervals_save-increased', binding);

    // Verify increased interval count reflected.
    await tapBackArrow(tester, '12_intervals_back-home-after-save', binding);
    await tapButtonByKey(
        tester, 'Interval Adjuster-0', '13_intervals_reopen', binding, false);
    await waitFor(tester, activeIntervalsShowing('4'));
    expect(activeIntervalsShowing('4'), findsOneWidget,
        reason: 'Increased interval count not reflected');

    // Decrease active intervals.
    await enterTextByKey(tester, 'active-intervals', '2',
        '15_intervals_decrease-active', binding);
    await closeKeyboard(tester, false);
    await tapSaveButton(tester, '16_intervals_save-decreased', binding);
    await tapBackArrow(
        tester, '17_intervals_back-home-after-decrease', binding);

    // Reopen and verify decrease.
    await tapButtonByKey(tester, 'Interval Adjuster-0',
        '18_intervals_reopen-after-decrease', binding, false);
    await waitFor(tester, activeIntervalsShowing('2'));
    expect(activeIntervalsShowing('2'), findsOneWidget,
        reason: 'Decreased interval count not reflected');

    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '19_intervals_adjusted',
      settle: false,
    );
  });
}
