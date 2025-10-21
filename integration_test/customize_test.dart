import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openhiit/main.dart';

import 'utils/enter_data.dart';
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
      await tapButtonByKey(tester, 'start-save-button',
          '6_customize_start-save-button', binding, false,
          waitForDisappearance: false);
      await tapBackArrow(tester, '7_customize_back-home', binding);
    }

    // Open the timer for editing.
    await tapButtonByKey(
        tester, 'Editable Timer-0', '8_customize_open-timer', binding, false);

    // Change the name.
    await enterTextByKey(tester, 'timer-name', 'Renamed Timer',
        '9_customize_rename-timer', binding);
    // Change the color.
    await tapButtonByKey(
        tester, 'color-picker', '10_customize_open-color-picker', binding, true,
        waitForDisappearance: false);
    await tapJustBelowCenterAndSlightlyLeft(tester, true);

    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '11_customize_color-picked',
      settle: false,
    );

    // Save the changes.
    await closeKeyboard(tester, false);
    await tapButtonByKey(tester, 'start-save-button',
        '12_customize_save-changes', binding, false,
        waitForDisappearance: false);

    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '13_customize_timer_updated',
      settle: false,
    );
  });
}
