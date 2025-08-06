import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'functions/functions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('end-to-end test', () {
    testWidgets('toggle seconds and minutes view', (tester) async {
      await loadApp(tester);
      expect(find.text('No saved timers'), findsOneWidget);
      await tapCreateTimerButton(tester);
      await pickTimerType(tester, false);
      await enterTimerName(tester, 'Test Timer');
      await pickColor(tester);
      await enterInterval(tester, 2);
      await enterTime(tester, "work-seconds", "90");
      await enterTime(tester, "rest-seconds", "60");
      await tapSoundTab(tester);
      await selectSound(tester, "work-sound", "Harsh beep sequence");
      await tapSaveButton(tester);
      await openViewTimer(tester, 'Test Timer');
      await editWorkoutOrTimer(tester);
      expect(find.text('Test Timer'), findsOneWidget);
      await tapMinutesSecondsToggle(tester, true);
      expect(find.text('Minutes View'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '1'), findsNWidgets(2));
      expect(find.widgetWithText(TextFormField, '30'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '0'), findsNWidgets(5));
      await tapSaveButton(tester);
      await openViewTimer(tester, 'Test Timer');
      await tapStartButton(tester);
      await waitForText(tester, "1:30");
    });
  });
}
