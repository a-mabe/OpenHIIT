import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openhiit/main.dart';

import 'utils/enter_data.dart';
import 'utils/misc.dart';
import 'utils/screenshot.dart';
import 'utils/tap_buttons.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('add_and_remove_restart_rounds', (WidgetTester tester) async {
    await tester.pumpWidget(WorkoutTimer());
    await tester.pumpAndSettle();

    // Create a new timer for restart testing.
    await tapButtonByKey(
        tester, 'new-timer', '1_restart_new-timer', binding, true);
    await enterTextByKey(tester, 'timer-name', 'Restart Tester',
        '2_restart_timer-name', binding);
    await enterTextByKey(
        tester, 'active-intervals', '2', '3_restart_active-intervals', binding);
    await enterTextByKey(
        tester, 'work-time', '4', '4_restart_work-time', binding);
    await enterTextByKey(
        tester, 'rest-time', '3', '5_restart_rest-time', binding);
    await closeKeyboard(tester, false);
    await tapButtonByKey(
        tester, 'save-button', '7_restart_save-initial', binding, false);
    await tapBackArrow(tester, '8_restart_back-home', binding);

    // Open timer (immediately editable).
    await tapButtonByKey(
        tester, 'Restart Tester-0', '9_restart_open', binding, false);

    // Add restart rounds.
    await enterTextByKey(
        tester, 'restarts', '2', '10_restart_add-rounds', binding);
    await closeKeyboard(tester, false);

    // Verify the break TextFormField is active (enabled for input).
    await enterTextByKey(
        tester, 'break', '120', '11_restart_break-time', binding);

    await tapButtonByKey(
        tester, 'save-button', '12_restart_save-added', binding, false);
    await tapBackArrow(tester, '13_restart_back-home-after-add', binding);
    // Reopen to verify restarts updated.
    await tapButtonByKey(
        tester, 'Restart Tester-0', '14_restart_reopen', binding, false);
    expect(find.text('2'), findsWidgets,
        reason: 'Restart count not updated to 2 after adding');
    expect(find.text('120'), findsWidgets,
        reason: 'Break time not updated to 120 after adding');

    // Remove restart rounds.
    await enterTextByKey(
        tester, 'restarts', '0', '15_restart_remove-rounds', binding);
    await closeKeyboard(tester, false);
    await tapButtonByKey(
        tester, 'save-button', '16_restart_save-removed', binding, false);
    await tapBackArrow(tester, '17_restart_back-home-after-remove', binding);
    // Reopen to verify removal.
    await tapButtonByKey(tester, 'Restart Tester-0',
        '18_restart_reopen-after-remove', binding, false);
    expect(find.text('0'), findsWidgets,
        reason: 'Restart count not reset to 0 after removal');

    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '19_restart_rounds_final',
      settle: false,
    );
  });
}
