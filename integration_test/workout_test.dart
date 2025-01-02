import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'functions/functions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  const String workoutName = 'Test Workout';
  const String workoutName2 = 'Test Workout Edited';

  group('end-to-end test', () {
    testWidgets('create a workout', (tester) async {
      await loadApp(tester);
      await binding.setSurfaceSize(const Size(1080, 2400));
      await navigateToAddWorkoutOrTimer(tester, true);
      await createWorkout(tester, workoutName);
    });
    testWidgets('check timer settings', (tester) async {
      await loadApp(tester);
      await verifyWorkoutOrTimerOpens(tester, workoutName);
      await checkWorkoutOrTimer(tester, workoutName, 3, true, {
        "10": 3,
      }, {
        "work-sound": "Harsh beep sequence",
        "rest-sound": "Ding",
        "halfway-sound": "Quick beep sequence",
        "countdown-sound": "Beep",
        "end-sound": "Horn",
      });
    });
    testWidgets('run a workout and restart', (tester) async {
      await loadApp(tester);
      await verifyWorkoutOrTimerOpens(tester, workoutName);
      await runWorkoutOne(tester, binding);
    });
    testWidgets('edit workout', (tester) async {
      await loadApp(tester);
      await verifyWorkoutOrTimerOpens(tester, workoutName);
      await editWorkout(tester, workoutName2);
    });
    testWidgets('run an edited workout and restart', (tester) async {
      await loadApp(tester);
      await verifyWorkoutOrTimerOpens(tester, workoutName2);
      await runWorkoutTwo(tester);
    });
  });
}
