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

  testWidgets('edit_name_and_color', (WidgetTester tester) async {
    await tester.pumpWidget(WorkoutTimer());
    await tester.pumpAndSettle();

    // Ensure a timer exists or create one for editing.
    if (find.textContaining("No saved timers").evaluate().isNotEmpty) {
      await tapButtonByKey(
          tester, 'new-timer', '1_minutes-view_create-new', binding, true);
      await enterTextByKey(tester, 'timer-name', 'Editable Timer',
          '2_minutes-view_timer-name', binding);
      await tapButtonByKey(tester, 'timer-display-toggle',
          '3_minutes-view_timer-display-toggle', binding, true);
      await tapButtonByKey(tester, 'minutes-option',
          '4_minutes-view_minutes-option', binding, true);
      // Active intervals 2.
      await enterTextByKey(tester, 'active-intervals', '4',
          '4_simple-timer_active-intervals', binding);
      // Enter work time as 2 minutes and 30 seconds.
      await enterTextInDescendantByKey(tester, 'work-time', '2', 0,
          '5_minutes-view_work-time-minutes', binding);
      await enterTextInDescendantByKey(tester, 'work-time', '30', 1,
          '6_minutes-view_work-time-seconds', binding);

      // Enter rest time as 1 minute.
      await enterTextInDescendantByKey(tester, 'rest-time', '1', 0,
          '7_minutes-view_rest-time-minutes', binding);
      await closeKeyboard(tester, false);

      // Expect to find a '2' and '30' in the work time field and '1' in the rest time field.
      expect(find.text('2'), findsOneWidget,
          reason: 'Work time minutes "2" not found');
      expect(find.text('30'), findsOneWidget,
          reason: 'Work time seconds "30" not found');
      expect(find.text('1'), findsOneWidget,
          reason: 'Rest time minutes "1" not found');

      // Tap on the Editor tab.
      await tapButtonByKey(
          tester, 'edit-tab', '8_minutes-view_open-edit-tab', binding, true);

      // Expect to find at least one interval with 2:30 and one with 1:00 display.
      expect(find.text('2:30'), findsAtLeastNWidgets(1),
          reason: 'Interval with "2:30" not found');
      expect(find.text('1:00'), findsAtLeastNWidgets(1),
          reason: 'Interval with "1:00" not found');

      // Save the timer.
      await tapButtonByKey(
          tester, 'save-button', '9_minutes-view_save-timer', binding, false);

      // Start the timer to verify display during countdown.
      await tapButtonByKey(tester, 'start-button',
          '10_minutes-view_start-timer', binding, false);

      // Wait until "Get Ready" is shown.
      await pumpUntilFound(tester, find.textContaining("Get Ready"),
          Duration(seconds: 15), false,
          screenShotName: '11_minutes-view_run-timer');

      // Expect to find at least one interval with 2:30 and one with 1:00 display.
      expect(find.text('2:30'), findsAtLeastNWidgets(1),
          reason: 'Interval with "2:30" not found');
      expect(find.text('1:00'), findsAtLeastNWidgets(1),
          reason: 'Interval with "1:00" not found');

      await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '12_minutes-view_timer_updated',
        settle: false,
      );
    }
  });
}
