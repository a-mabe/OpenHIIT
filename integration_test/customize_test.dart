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
          tester, 'new-timer', '1_edit_create-new', binding, true);
      await enterTextByKey(
          tester, 'timer-name', 'Editable Timer', '2_edit_timer-name', binding);
      await enterTextByKey(
          tester, 'work-time', '5', '3_edit_work-time', binding);
      await enterTextByKey(
          tester, 'rest-time', '3', '4_edit_rest-time', binding);
      await closeKeyboard(tester, false);
      await tapButtonByKey(
          tester, 'save-button', '5_edit_save-button', binding, false);
      await tapBackArrow(tester, '6_edit_back-home', binding);
    }

    // Open the timer for editing.
    await tapButtonByKey(
        tester, 'Editable Timer-0', '7_edit_open-timer', binding, false);

    // Change the name.
    await enterTextByKey(tester, 'timer-name', 'Renamed Timer',
        '8_rename_rename-timer', binding);
    // Change the color.
    await tapButtonByKey(
        tester, 'color-picker', '9_rename_open-color-picker', binding, true);
    await tapJustBelowCenterAndSlightlyLeft(tester, true);

    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '10_rename_color-picked',
      settle: false,
    );

    // Save the changes.
    await closeKeyboard(tester, false);
    await tapButtonByKey(
        tester, 'save-button', '11_rename_save-changes', binding, false);

    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '12_edit_timer_updated',
      settle: false,
    );
  });
}
