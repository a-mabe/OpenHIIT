import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openhiit/main.dart';

import 'utils/enter_data.dart';
import 'utils/screenshot.dart';
import 'utils/tap_buttons.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('simple_timer', (WidgetTester tester) async {
    await tester.pumpWidget(WorkoutTimer());
    await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '1_simple-timer_home');

    await tapButtonByKey(tester, 'new-timer');
    await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '2_simple-timer_new-timer');

    await enterTextByKey(tester, 'timer-name', 'My New Timer');
    await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '3_simple-timer_new-timer-name');

    await enterTextByKey(tester, 'active-intervals', '3');
    await takeScreenShot(
        binding: binding,
        tester: tester,
        screenShotName: '4_simple-timer_active-intervals');
  });
}
