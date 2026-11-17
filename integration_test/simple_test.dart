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

  testWidgets('simple_timer', (WidgetTester tester) async {
    await launchApp(tester);

    // App loaded.
    await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '1_simple-timer_home',
        settle: true);

    // Tap "Got it!" to dismiss the welcome screen.
    await tapGotItButton(tester, binding);

    // Tap the "New" button in the bottom nav bar to create a new timer.
    await tapButtonByKey(
        tester, 'new-timer', '2_simple-timer_new-timer', binding, true);

    // ---
    // Fill out the form to create a new timer.
    // Work - 4. Rest - 3. Active Intervals - 5. Get Ready - 10.

    // Enter the name first.
    await enterTextByKey(tester, 'timer-name', 'My New Timer',
        '3_simple-timer_new-timer-name', binding);
    // Active intervals 5.
    await enterTextByKey(tester, 'active-intervals', '5',
        '4_simple-timer_active-intervals', binding);
    // Work time 4.
    await enterTextByKey(
        tester, 'work-time', '4', '5_simple-timer_work-time', binding);
    // Rest time 3.
    await enterTextByKey(
        tester, 'rest-time', '3', '6_simple-timer_rest-time', binding);
    // Close keyboard to ensure save button is visible.
    await closeKeyboard(tester, false);
    // ---

    await tapSaveButton(tester, '7_simple-timer_start-save-button', binding);

    // Back to home screen. Make sure the new timer is shown.
    await tapBackArrow(tester, '8_simple-timer_back-arrow', binding);

    // Check that the proper total time of 1 minutes is shown.
    expect(find.textContaining("Total - 1 minutes"), findsOneWidget);

    // Key for timer is ${item.name}-${item.timerIndex}.
    await tapButtonByKey(tester, 'My New Timer-0',
        '9_simple-timer_open-new-timer', binding, false);

    // Active intervals decrease to 2.
    await enterTextByKey(tester, 'active-intervals', '2',
        '10_simple-timer_active-intervals', binding);
    await closeKeyboard(tester, false);

    await tapSaveButton(tester, '11_simple-timer_start-save-button', binding);

    // Back to home screen. Make sure the new timer is shown.
    await tapBackArrow(tester, '12_simple-timer_back-arrow', binding);

    // Check that the proper total time of 0 minutes is shown.
    expect(find.textContaining("Total - 0 minutes"), findsOneWidget);

    // Key for timer is ${item.name}-${item.timerIndex}.
    await tapButtonByKey(tester, 'My New Timer-0',
        '13_simple-timer_open-new-timer', binding, false);

    // Start the timer.
    await tapStartButton(tester, '14_simple-timer_load-new-timer', binding);
    // ---
    // The timer should now be running. Do not settle, as the UI is constantly updating.
    // Get Ready -> Work 1 -> Rest 1 -> Work 2 -> Done

    // Wait until "Get Ready" is shown.
    await pumpUntilFound(
        tester, find.textContaining("Get Ready"), Duration(seconds: 15), false,
        screenShotName: '15_simple-timer_run-new-timer');
    // Wait until "Get Ready" is gone and first work interval is shown.
    await pumpUntilGone(
        tester, find.textContaining("Get Ready"), Duration(seconds: 15), false,
        screenShotName: '16_simple-timer_work-interval-1');
    // Wait until first work interval is gone and first rest interval is shown.
    await pumpUntilGone(
        tester, find.textContaining("1 of 2"), Duration(seconds: 15), false,
        screenShotName: '17_simple-timer_rest-interval-1');
    // Wait until first rest interval is gone and second work interval is shown.
    await pumpUntilFound(
        tester, find.textContaining("2 of 2"), Duration(seconds: 15), false,
        screenShotName: '18_simple-timer_work-interval-2');
    // Wait for the "Nice job!" screen.
    await pumpUntilFound(tester, find.byKey(const ValueKey('timer-end-back')),
        Duration(seconds: 30), false,
        screenShotName: '19_simple-timer_running-interval-2');
    // Exit the timer.
    await tapButtonByKey(
        tester, 'timer-end-back', '20_simple-timer_end-back', binding, false);
    // ---

    await tapBackArrow(tester, '21_simple-timer_back-arrow', binding);

    // Verify the timer is shown.
    expect(find.text('My New Timer'), findsOneWidget,
        reason: 'Timer not found before delete');

    await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '22_swipe-delete_before-swipe',
        settle: true);

    // Swipe the timer tile to the left to delete it.
    final tile = find.byKey(const ValueKey('My New Timer-0'));
    await waitForTappable(tester, tile);
    await tester.drag(tile, const Offset(-500, 0));

    // Wait for the dismiss animation and the "deleted" snackbar. The
    // snackbar only shows for 2s, so check it before the screenshot.
    await waitForGone(tester, find.text('My New Timer'),
        timeout: Duration(seconds: 10));
    await waitFor(tester, find.text('My New Timer deleted'),
        timeout: Duration(seconds: 2));
    await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '23_swipe-delete_after-swipe',
        settle: false);

    // The empty state only appears after the snackbar closes and the
    // timer has been deleted from the database.
    await pumpUntilFound(
        tester, find.text('No saved timers'), Duration(seconds: 15), true,
        screenShotName: '24_swipe-delete_empty-state');
  });
}
