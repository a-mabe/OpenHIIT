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

  testWidgets('edit_name_and_color', (WidgetTester tester) async {
    await launchApp(tester);

    // Tap "Got it!" to dismiss the welcome screen.
    await tapGotItButton(tester, binding);

    // Create a timer to customize. launchApp starts from an empty database.
    await tapButtonByKey(
        tester, 'new-timer', '1_customize_create-new', binding, true);
    await enterTextByKey(tester, 'timer-name', 'Editable Timer',
        '2_customize_timer-name', binding);
    await enterTextByKey(tester, 'active-intervals', '5',
        '3_customize_active-intervals', binding);
    await enterTextByKey(
        tester, 'work-time', '5', '4_customize_work-time', binding);
    await enterTextByKey(
        tester, 'rest-time', '3', '5_customize_rest-time', binding);
    await closeKeyboard(tester, false);
    await tapSaveButton(tester, '6_customize_start-save-button', binding);
    await tapBackArrow(tester, '7_customize_back-home', binding);

    // Open the timer for editing.
    await tapButtonByKey(
        tester, 'Editable Timer-0', '8_customize_open-timer', binding, false);

    // Change the name.
    await enterTextByKey(tester, 'timer-name', 'Renamed Timer',
        '9_customize_rename-timer', binding);
    await closeKeyboard(tester, false);

    // Change the color. Wait for the picker dialog to open fully before
    // tapping a swatch by position, then for it to close.
    await tapButtonByKey(
        tester, 'color-picker', '10_customize_open-color-picker', binding, true,
        waitForDisappearance: false);
    final dialog = find.byType(AlertDialog);
    await waitForTappable(tester, dialog);
    await tapJustBelowCenterAndSlightlyLeft(tester, false);
    await waitForGone(tester, dialog);

    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '11_customize_color-picked',
      settle: false,
    );

    // Save the changes.
    await tapSaveButton(tester, '12_customize_save-changes', binding);

    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '13_customize_timer_updated',
      settle: false,
    );
  });
}
