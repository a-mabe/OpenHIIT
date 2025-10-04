import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openhiit/main.dart';

import 'utils/enter_data.dart';
import 'utils/misc.dart';
import 'utils/screenshot.dart';
import 'utils/tap_buttons.dart';

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

    // Start button appears with animation, so don't settle.
    await tapButtonByKey(
        tester, 'save-button', '11_advanced-timer_save-button', binding, false);

    // Back to home screen. Make sure the new timer is shown.
    await tapBackArrow(tester, '12_advanced-timer_back-arrow', binding);

    // Key for timer is ${item.name}-${item.timerIndex}.
    await tapButtonByKey(tester, 'My New Timer-0',
        '13_advanced-timer_open-new-timer', binding, false);

    // Start the timer.
    await tapButtonByKey(tester, 'start-button',
        '14_advanced-timer_load-new-timer', binding, true);

    // ---
    // The timer should now be running. Do not settle, as the UI is constantly updating.
    // Get Ready -> Work 1 -> Rest 1 -> Work 2 -> Done

    // Wait until "Get Ready" is shown.
    await pumpUntilFound(
        tester, find.textContaining("Get Ready"), Duration(seconds: 15), false,
        screenShotName: '15_advanced-timer_run-new-timer');
    // Verify Warmup is shown
    expect(find.textContaining("Warmup"), findsOneWidget,
        reason: 'Warmup interval not found');
    // Wait until "Warmup" is gone and first work interval is shown.
    await pumpUntilGone(
        tester, find.textContaining("Warmup"), Duration(seconds: 15), false,
        screenShotName: '16_advanced-timer_warmup-interval');
    // Wait until first work interval is shown..
    await pumpUntilFound(
        tester, find.textContaining("1 of 2"), Duration(seconds: 15), false,
        screenShotName: '17_advanced-timer_work-interval-1-iteration-1');
    // Wait until first rest interval is gone and second work interval is shown.
    await pumpUntilFound(
        tester, find.textContaining("2 of 2"), Duration(seconds: 15), false,
        screenShotName: '18_advanced-timer_work-interval-2-iteration-1');
    // Verify Break is shown in the widget tree
    expect(find.textContaining("Break"), findsOneWidget,
        reason: 'Break interval not found');
    // Wait until all work intervals are done and cooldown is shown.
    await pumpUntilGone(
        tester, find.textContaining("Work"), Duration(seconds: 120), false,
        screenShotName: '19_advanced-cooldown-interval');
    // Verify Cooldown is shown in the widget tree
    expect(find.textContaining("Cooldown"), findsOneWidget,
        reason: 'Cooldown interval not found');
    // Make sure the Nice job! screen is shown.
    await pumpForDuration(tester, Duration(seconds: 30),
        screenShotName: '20_advanced-timer_nice-job-screen', settle: false);
    // Exit the timer.
    await tapButtonByKey(
        tester, 'timer-end-back', '21_advanced-timer_end-back', binding, false);
    // ---
  });
}
