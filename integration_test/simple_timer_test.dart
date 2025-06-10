import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'functions/functions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('end-to-end test', () {
    testWidgets('simple timer and restart', (tester) async {
      await loadApp(tester);
      expect(find.text('No saved timers'), findsOneWidget);
      await tapInfoButton(tester);
      expect(find.text('About OpenHIIT'), findsOneWidget);
      await closeInfoButton(tester);
      await tapCreateTimerButton(tester);
      await pickTimerType(tester, false);
      await enterTimerName(tester, 'Test Timer');
      await pickColor(tester);
      await enterInterval(tester, 2);
      await tapSubmit(tester);
      await enterTime(tester, "work-seconds", "6");
      await enterTime(tester, "rest-seconds", "4");
      await tapSubmit(tester);
      await selectSound(tester, "work-sound", "Harsh beep sequence");
      await tapSubmit(tester);
      await openViewTimer(tester, 'Test Timer');
      await tapStartButton(tester);
      await waitForText(tester, "Get Ready");
      await waitForText(tester, "1 of 2");
      await waitForText(tester, "2 of 2");
      await waitForText(tester, "Nice job!");
      await tapRestart(tester);
      await waitForText(tester, "Get Ready");
      await waitForText(tester, "1 of 2");
      await tapNextButton(tester);
      await waitForText(tester, "2 of 2");
      await waitForText(tester, "Nice job!");
      await tapTimerEndBack(tester);
    });

    testWidgets('copy timer', (tester) async {
      await loadApp(tester);
      expect(find.text('Test Timer'), findsOneWidget);
      await openViewTimer(tester, 'Test Timer');
      await copyWorkoutOrTimer(tester);
      expect(find.text('Test Timer'), findsNWidgets(2));
    });

    testWidgets('delete timer', (tester) async {
      await loadApp(tester);
      expect(find.text('Test Timer'), findsNWidgets(2));
      await openViewTimer(tester, 'Test Timer');
      await deleteWorkoutOrTimer(tester);
      expect(find.text('Test Timer'), findsOneWidget);
    });
  });
}
