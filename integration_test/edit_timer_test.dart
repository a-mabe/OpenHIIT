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

  testWidgets('edit_existing_timer', (WidgetTester tester) async {
    await launchApp(tester);

    // Tap "Got it!" to dismiss the welcome screen.
    await tapGotItButton(tester, binding);

    // Create a timer to edit. launchApp starts from an empty database.
    await tapButtonByKey(
        tester, 'new-timer', '1_edit_create-new', binding, true);
    await enterTextByKey(
        tester, 'timer-name', 'Editable Timer', '2_edit_timer-name', binding);
    await enterTextByKey(
        tester, 'active-intervals', '5', '3_edit_active-intervals', binding);
    await enterTextByKey(tester, 'work-time', '5', '4_edit_work-time', binding);
    await enterTextByKey(tester, 'rest-time', '3', '5_edit_rest-time', binding);
    await closeKeyboard(tester, false);
    await tapSaveButton(tester, '6_edit_start-save-button', binding);
    await tapBackArrow(tester, '7_edit_back-home', binding);

    // Open the timer for editing.
    await tapButtonByKey(
        tester, 'Editable Timer-0', '8_edit_open-timer', binding, false);

    // Modify work and rest times.
    await enterTextByKey(
        tester, 'work-time', '8', '9_edit_modify-work-time', binding);
    await enterTextByKey(
        tester, 'rest-time', '2', '10_edit_modify-rest-time', binding);
    await closeKeyboard(tester, false);
    await tapSaveButton(tester, '11_edit_save-modified', binding);

    // Go back to the home screen and reopen timer to verify updates.
    await tapBackArrow(tester, '12_edit_back-home-after-save', binding);
    await tapButtonByKey(
        tester, 'Editable Timer-0', '13_edit_reopen-timer', binding, false);

    // Validate the updated values appear in their fields. The fields are
    // filled in after the screen opens, so wait for them.
    final workTime = find.descendant(
        of: find.byKey(const ValueKey('work-time')),
        matching: find.textContaining('8'));
    final restTime = find.descendant(
        of: find.byKey(const ValueKey('rest-time')),
        matching: find.textContaining('2'));
    await waitFor(tester, workTime);
    await waitFor(tester, restTime);
    expect(workTime, findsOneWidget, reason: 'Updated work time not found');
    expect(restTime, findsOneWidget, reason: 'Updated rest time not found');

    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '14_edit_timer_updated',
      settle: false,
    );
  });
}
