import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openhiit/main.dart';

import 'utils/enter_data.dart';
import 'utils/pump_and_settle.dart';
import 'utils/screenshot.dart';
import 'utils/tap_buttons.dart';
import 'utils/other.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('advanced_timer', (WidgetTester tester) async {
    await tester.pumpWidget(WorkoutTimer());

    // App loaded.
    await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '1_advanced-timer_home',
        settle: true);

    // Tap the "New" button in the bottom nav bar to create a new timer.
    await tapButtonByKey(
        tester, 'new-timer', '2_advanced-timer_new-timer', binding, true);

    // ---
    // Fill out the form to create a new timer.
    // Work - 4. Rest - 3. Active Intervals - 2. Get Ready - 10.
    // Warmup - 5. Cooldown - 6. Restarts - 2. Break - 7.

    // Enter the name first.
    await enterTextByKey(tester, 'timer-name', 'My New Timer',
        '3_advanced-timer_new-timer-name', binding);
    // Active intervals 2.
    await enterTextByKey(tester, 'active-intervals', '2',
        '4_advanced-timer_active-intervals', binding);
    // Work time 4.
    await enterTextByKey(
        tester, 'work-time', '4', '5_advanced-timer_work-time', binding);
    // Rest time 3.
    await enterTextByKey(
        tester, 'rest-time', '3', '6_advanced-timer_rest-time', binding);
    // Warmup time 5.
    await enterTextByKey(
        tester, 'warm-up', '5', '7_advanced-timer_warmup-time', binding);
    // Cooldown time 6.
    await enterTextByKey(
        tester, 'cool-down', '6', '8_advanced-timer_cooldown-time', binding);
    // Restarts 2.
    await enterTextByKey(
        tester, 'restarts', '2', '9_advanced-timer_restarts', binding);
    // Break time 7.
    await enterTextByKey(
        tester, 'break', '7', '10_advanced-timer_break-time', binding);
    // Close keyboard to ensure save button is visible.
    await closeKeyboard(tester, false);
    // ---

    // Tap the Edit tab.
    await tapButtonByKey(
        tester, 'edit-tab', '11_advanced-timer_edit-tab', binding, true);

    // Enter activities for the two work intervals.
    await enterTextByKey(
        tester, 'activity-0', '', '12_advanced-timer_activity-blank', binding);
    await enterTextByKey(tester, 'activity-0', 'Push-ups',
        '13_advanced-timer_activity-0', binding);

    await closeKeyboard(tester, true);

    await enterTextByKey(
        tester, 'activity-1', '', '14_advanced-timer_activity-blank', binding);
    await enterTextByKey(tester, 'activity-1', 'Sit-ups',
        '15_advanced-timer_activity-1', binding);
    // Start button appears with animation, so don't settle.
    await tapButtonByKey(tester, 'start-save-button',
        '15_advanced-timer_start-save-button', binding, false,
        waitForDisappearance: false);

    // Back to home screen. Make sure the new timer is shown.
    await tapBackArrow(tester, '16_advanced-timer_back-arrow', binding);

    // Key for timer is ${item.name}-${item.timerIndex}.
    await tapButtonByKey(tester, 'My New Timer-0',
        '17_advanced-timer_open-new-timer', binding, false);

    // Start the timer.
    await tapButtonByKey(tester, 'start-save-button',
        '18_advanced-timer_load-new-timer', binding, true,
        waitForDisappearance: false);

    // ---
    // The timer should now be running. Do not settle, as the UI is constantly updating.
    // Get Ready -> Warmup -> Rest -> Work 1 -> Rest 2 -> Work 2 -> Break (restart)

    // Wait until "Warmup" is shown.
    await pumpUntilFound(
        tester, find.textContaining("Warmup"), Duration(seconds: 15), false,
        screenShotName: '19_advanced-timer_run-new-timer');
    // Verify Warmup is shown
    expect(find.textContaining("Warmup"), findsOneWidget,
        reason: 'Warmup interval not found');
    // Wait until "Warmup" is gone and first work interval is shown.
    await pumpUntilGone(
        tester, find.textContaining("Warmup"), Duration(seconds: 30), false,
        screenShotName: '20_advanced-timer_warmup-interval');
    // Wait until first work interval is shown..
    await pumpUntilFound(
        tester, find.textContaining("1 of 2"), Duration(seconds: 15), false,
        screenShotName: '21_advanced-timer_work-interval-1-iteration-1');
    // Verify that the first exercise 'Push-ups' is shown.
    // There should be two because there is a restart.
    expect(find.textContaining("Push-ups"), findsAtLeast(1),
        reason: 'First exercise not found');
    // Wait until first rest interval is gone and second work interval is shown.
    await pumpUntilFound(
        tester, find.textContaining("2 of 2"), Duration(seconds: 15), false,
        screenShotName: '22_advanced-timer_work-interval-2-iteration-1');
    // Verify the second exercise 'Sit-ups' is shown.
    // There should be two because there is a restart.
    expect(find.textContaining("Sit-ups"), findsAtLeast(1),
        reason: 'Second exercise not found');
    // Verify Break is shown in the widget tree
    expect(find.textContaining("Break"), findsOneWidget,
        reason: 'Break interval not found');
    // Wait until all work intervals are done and cooldown is shown. Do this by waiting
    // until the second and third sets of exercises is gone.
    await pumpUntilGone(
        tester, find.textContaining("Push-ups"), Duration(seconds: 120), false,
        screenShotName: '23_advanced-work-interval-1-end-iteration-2');
    await pumpUntilGone(
        tester, find.textContaining("Sit-ups"), Duration(seconds: 120), false,
        screenShotName: '24_advanced-work-interval-2-end-iteration-2');
    await pumpUntilGone(
        tester, find.textContaining("Push-ups"), Duration(seconds: 120), false,
        screenShotName: '25_advanced-work-interval-1-end-iteration-3');
    await pumpUntilGone(
        tester, find.textContaining("Sit-ups"), Duration(seconds: 120), false,
        screenShotName: '26_advanced-work-interval-2-end-iteration-3');
    // Verify Cooldown is shown in the widget tree
    expect(find.textContaining("Cooldown"), findsOneWidget,
        reason: 'Cooldown interval not found');
    // Make sure the Nice job! screen is shown.
    await pumpForDuration(tester, Duration(seconds: 30),
        screenShotName: '27_advanced-timer_nice-job-screen', settle: false);
    // Exit the timer.
    await tapButtonByKey(
        tester, 'timer-end-back', '28_advanced-timer_end-back', binding, false);
    // ---
  });
}
