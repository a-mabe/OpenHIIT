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

  testWidgets('simple_timer', (WidgetTester tester) async {
    await tester.pumpWidget(WorkoutTimer());

    // App loaded.
    await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '1_simple-timer_home',
        settle: true);

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

    // Start button appears with animation, so don't settle.
    await tapButtonByKey(
        tester, 'save-button', '7_simple-timer_save-button', binding, false);

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

    // Save timer. Start button appears with animation, so don't settle.
    await tapButtonByKey(
        tester, 'save-button', '11_simple-timer_save-button', binding, false);

    // Back to home screen. Make sure the new timer is shown.
    await tapBackArrow(tester, '12_simple-timer_back-arrow', binding);

    // Check that the proper total time of 0 minutes is shown.
    expect(find.textContaining("Total - 0 minutes"), findsOneWidget);

    // Key for timer is ${item.name}-${item.timerIndex}.
    await tapButtonByKey(tester, 'My New Timer-0',
        '13_simple-timer_open-new-timer', binding, false);

    // Start the timer.
    await tapButtonByKey(tester, 'start-button',
        '14_simple-timer_load-new-timer', binding, true);
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
    // Make sure the Nice job! screen is shown.
    await pumpForDuration(tester, Duration(seconds: 10),
        screenShotName: '19_simple-timer_running-interval-2', settle: false);
    // Exit the timer.
    await tapButtonByKey(
        tester, 'timer-end-back', '20_simple-timer_end-back', binding, false);
    // ---
  });
}
