import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openhiit/main.dart';

import 'utils/enter_data.dart';
import 'utils/screenshot.dart';
import 'utils/tap_buttons.dart';
import 'utils/other.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('edit_existing_timer', (WidgetTester tester) async {
    await tester.pumpWidget(WorkoutTimer());
    await tester.pumpAndSettle();

    // Ensure a timer exists or create one for editing.
    if (find.textContaining("No saved timers").evaluate().isNotEmpty) {
      await tapButtonByKey(
          tester, 'new-timer', '1_edit_create-new', binding, true);
      await enterTextByKey(
          tester, 'timer-name', 'Editable Timer', '2_edit_timer-name', binding);
      await enterTextByKey(
          tester, 'active-intervals', '5', '3_edit_active-intervals', binding);
      await enterTextByKey(
          tester, 'work-time', '5', '4_edit_work-time', binding);
      await enterTextByKey(
          tester, 'rest-time', '3', '5_edit_rest-time', binding);
      await closeKeyboard(tester, false);
      await tapButtonByKey(tester, 'start-save-button',
          '6_edit_start-save-button', binding, false);
      await tapBackArrow(tester, '7_edit_back-home', binding);
    }

    // Open the timer for editing.
    await tapButtonByKey(
        tester, 'Editable Timer-0', '8_edit_open-timer', binding, false);

    // Modify work and rest times.
    await enterTextByKey(
        tester, 'work-time', '8', '9_edit_modify-work-time', binding);
    await enterTextByKey(
        tester, 'rest-time', '2', '10_edit_modify-rest-time', binding);
    await closeKeyboard(tester, false);
    await tapButtonByKey(
        tester, 'start-save-button', '11_edit_save-modified', binding, false);

    // Go back to the home screen and reopen timer to verify updates.
    await tapBackArrow(tester, '12_edit_back-home-after-save', binding);
    await tapButtonByKey(
        tester, 'Editable Timer-0', '13_edit_reopen-timer', binding, false);

    // Validate the updated values appear in UI.
    expect(find.textContaining("8"), findsOneWidget,
        reason: 'Updated work time not found');
    expect(find.textContaining("2"), findsOneWidget,
        reason: 'Updated rest time not found');

    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '14_edit_timer_updated',
      settle: false,
    );
  });
}
