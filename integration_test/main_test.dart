import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openhiit/main.dart';

import 'utils/enter_data.dart';
import 'utils/misc.dart';
import 'utils/screenshot.dart';
import 'utils/tap_buttons.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('simple_timer', (WidgetTester tester) async {
    await tester.pumpWidget(WorkoutTimer());

    await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '1_simple-timer_home',
        settle: true);

    await tapButtonByKey(
        tester, 'new-timer', '2_simple-timer_new-timer', binding, true);

    await enterTextByKey(tester, 'timer-name', 'My New Timer',
        '3_simple-timer_new-timer-name', binding);

    await enterTextByKey(tester, 'active-intervals', '3',
        '4_simple-timer_active-intervals', binding);
    await enterTextByKey(
        tester, 'work-time', '4', '5_simple-timer_work-time', binding);
    await enterTextByKey(
        tester, 'rest-time', '3', '6_simple-timer_rest-time', binding);

    await closeKeyboard(tester, false);

    // Start button appears with animation, so don't settle.
    await tapButtonByKey(
        tester, 'save-button', '7_simple-timer_save-button', binding, false);

    await tapBackArrow(tester, '8_simple-timer_back-arrow', binding);

    // Key for timer is ${item.name}-${item.timerIndex}
    await tapButtonByKey(tester, 'My New Timer-0',
        '9_simple-timer_open-new-timer', binding, false);

    await tapButtonByKey(tester, 'start-button',
        '10_simple-timer_load-new-timer', binding, true);

    await pumpUntilFound(
        tester, find.textContaining("Get Ready"), Duration(seconds: 10), false,
        screenShotName: '11_simple-timer_run-new-timer');

    await pumpUntilGone(
        tester, find.textContaining("Get Ready"), Duration(seconds: 10), false,
        screenShotName: '12_simple-timer_work-interval-1');
  });
}
