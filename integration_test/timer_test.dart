import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:permission_handler/permission_handler.dart';

import 'functions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  const String workoutName = 'Test Workout';
  const String workoutName2 = 'Test Workout Edited';
  const String timerName = 'Test Timer';

  group('end-to-end test', () {
    // setUp(() {
    //   Permission.scheduleExactAlarm.
    // });
    testWidgets('verify app load', (tester) async {
      await loadApp(tester);
      // await binding.setSurfaceSize(const Size(1080, 2400));
      expect(find.text('No saved timers'), findsOneWidget);
      if (Platform.isAndroid) {
        await binding.convertFlutterSurfaceToImage();
        await tester.pumpAndSettle();
      }
      final path = await binding.takeScreenshot('screenshot_name');
      print('Screenshot saved at: $path');
    });
    testWidgets('create a workout', (tester) async {
      await loadApp(tester);
      await navigateToAddWorkoutOrTimer(tester, true);
      await createWorkout(tester, workoutName);
    });
    testWidgets('run a workout and restart', (tester) async {
      await loadApp(tester);
      await verifyWorkoutOrTimerOpens(tester, workoutName);
      await runWorkoutOne(tester);
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
