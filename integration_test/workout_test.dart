import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'functions/functions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('end-to-end test', () {
    testWidgets('timer with exercises and all settings changed',
        (tester) async {
      await loadApp(tester);
      expect(find.text('No saved timers'), findsOneWidget);
      await tapCreateTimerButton(tester);
      await pickTimerType(tester, true);
      await enterTimerName(tester, 'Test Workout');
      await pickColor(tester);
      await enterInterval(tester, 2);
      await tapSubmit(tester);
      await enterExercise(tester, 0, "Push-ups");
      await enterExercise(tester, 1, "Squats");
      await closeKeyboard(tester);
      await tapSubmit(tester);
      await enterTime(tester, "work-seconds", "8");
      await enterTime(tester, "rest-seconds", "5");
      await enterAdvancedTime(tester, "7", "8", "8", "1", "5");
      await tapSubmit(tester);
      await selectSound(tester, "work-sound", "None");
      await selectSound(tester, "rest-sound", "None");
      await selectSound(tester, "halfway-sound", "None");
      await selectSound(tester, "countdown-sound", "None");
      await selectSound(tester, "end-sound", "None");
      await tapSubmit(tester);
      await openViewTimer(tester, 'Test Workout');
      await tapStartButton(tester);
      await waitForText(tester, "7");
      await waitForText(tester, "Warmup");
      await waitForText(tester, "1 of 2");
      await waitForText(tester, "Push-ups");
      await waitForText(tester, "2 of 2");
      await waitForText(tester, "Squats");
      await waitForText(tester, "Break");
      await waitForText(tester, "1 of 2");
      await waitForText(tester, "Push-ups");
      await waitForText(tester, "2 of 2");
      await waitForText(tester, "Squats");
      await waitForText(tester, "Cooldown");
      await waitForText(tester, "Nice job!");
    });
  });
}
