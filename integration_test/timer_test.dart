import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'functions/functions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('end-to-end test', () {
    testWidgets('timer with work and rest', (tester) async {
      await loadApp(tester);
      expect(find.text('No saved timers'), findsOneWidget);
      await tapCreateTimerButton(tester);
      await pickTimerType(tester, false);
      await enterTimerName(tester, 'Test Timer');
      await pickColor(tester);
      await enterInterval(tester, 4);
      await tapSubmit(tester);
      await enterTime(tester, "work-seconds", "8");
      await enterTime(tester, "rest-seconds", "5");
      await tapSubmit(tester);
      await selectSound(tester, "work-sound", "Harsh beep sequence");
      await tapSubmit(tester);
      await openViewTimer(tester, 'Test Timer');
      await tapStartButton(tester);
      await waitForText(tester, "Get Ready");
      await waitForText(tester, "1 of 4");
      await waitForText(tester, "2 of 4");
      await waitForText(tester, "3 of 4");
      await waitForText(tester, "4 of 4");
      await waitForText(tester, "Nice job!");
    });
  });
}
