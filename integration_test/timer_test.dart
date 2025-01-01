import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'functions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  const String timerName = 'Test Timer';

  group('end-to-end test', () {
    testWidgets('verify app load', (tester) async {
      await loadApp(tester);
      await binding.setSurfaceSize(const Size(1080, 2400));
      expect(find.text('No saved timers'), findsOneWidget);
    });
    testWidgets('create a timer', (tester) async {
      await loadApp(tester);
      await navigateToAddWorkoutOrTimer(tester, false);
      await createTimer(tester, timerName);
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
