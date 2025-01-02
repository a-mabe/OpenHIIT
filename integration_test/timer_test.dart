import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'functions/functions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  const String timerName = 'Test Timer';

  group('end-to-end test', () {
    testWidgets('create a timer', (tester) async {
      await loadApp(tester);
      await navigateToAddWorkoutOrTimer(tester, false);
      await createTimer(tester, timerName);
    });
    testWidgets('check timer settings', (tester) async {
      await loadApp(tester);
      await verifyWorkoutOrTimerOpens(tester, timerName);
      await checkWorkoutOrTimer(tester, timerName, 1, false, {
        "10": 2,
        "40": 1,
        "30": 1,
        "90": 1,
        "20": 1,
        "2": 1
      }, {
        "work-sound": "None",
        "rest-sound": "None",
        "halfway-sound": "None",
        "countdown-sound": "None",
        "end-sound": "None",
      });
    });
    testWidgets('run timer and cancel timer', (tester) async {
      await loadApp(tester);
      await verifyWorkoutOrTimerOpens(tester, timerName);
      await runTimerOne(tester);
    });
    testWidgets('delete timer', (tester) async {
      await loadApp(tester);
      await deleteWorkoutOrTimer(tester, timerName);
    });
  });
}
