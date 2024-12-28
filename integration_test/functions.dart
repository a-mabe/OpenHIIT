import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhiit/main.dart';

Future<void> selectSound(WidgetTester tester, Key key, String soundName) async {
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
  await tester.tap(find
      .descendant(of: find.byKey(key), matching: find.text(soundName))
      .last);
  await tester.pumpAndSettle();
}

Future<void> selectColor(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('color-picker')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Select'));
  await tester.pumpAndSettle();
}

Future<void> setExercises(WidgetTester tester) async {
  const exercises = ['Push-ups', 'Sit-ups', 'Jumping Jacks'];
  for (int i = 0; i < exercises.length; i++) {
    await tester.enterText(find.byKey(Key('exercise-$i')), exercises[i]);
  }
}

Future<void> setTimings(WidgetTester tester, String workTime, String restTime,
    bool fullWorkout) async {
  await tester.enterText(find.byKey(const Key('work-seconds')), workTime);
  await tester.enterText(find.byKey(const Key('rest-seconds')), restTime);

  if (fullWorkout) {
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pump(Duration(seconds: 1));
    const timings = {
      'get-ready-seconds': '40',
      'cooldown-seconds': '30',
      'warmup-seconds': '20',
      'iterations': '2',
      'break-seconds': '90'
    };
    for (var key in timings.keys) {
      if (key != 'break-seconds') {
        await tester.enterText(find.byKey(Key(key)), timings[key]!);
      } else {
        await tester.pump(Duration(seconds: 1));
        await tester.enterText(find.byKey(Key(key)), timings[key]!);
      }
    }
  }
}

Future<void> createOrEditWorkoutOrTimer(
    WidgetTester tester,
    String workoutName,
    int numIntervals,
    bool addExercises,
    bool isWorkout,
    bool fullWorkout,
    String workSound,
    String restSound,
    String halfwaySound,
    String countdownSound,
    String endSound,
    String workTime,
    String restTime) async {
  await selectColor(tester);
  await tester.enterText(
      find.byKey(const Key('interval-input')), numIntervals.toString());
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();

  if (addExercises) await setExercises(tester);
  if (isWorkout) {
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
  }

  await setTimings(tester, workTime, restTime, fullWorkout);
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();

  expect(find.text('Work Sound'), findsOneWidget);
  await selectSound(tester, const Key('work-sound'), workSound);
  await selectSound(tester, const Key('rest-sound'), restSound);
  await selectSound(tester, const Key('halfway-sound'), halfwaySound);
  await selectSound(tester, const Key('countdown-sound'), countdownSound);
  await selectSound(tester, const Key('end-sound'), endSound);

  await tester.tap(find.text('Submit'));
  await tester.pump(Duration(seconds: 1));
  await tester.pumpAndSettle();
  expect(find.text(workoutName), findsOneWidget);
}

Future<void> editWorkoutOne(
    WidgetTester tester,
    String workoutName,
    int numIntervals,
    bool addExercises,
    bool isWorkout,
    bool fullWorkout,
    String workSound,
    String restSound,
    String halfwaySound,
    String countdownSound,
    String endSound,
    String workTime,
    String restTime) async {
  await selectColor(tester);
  await tester.enterText(
      find.byKey(const Key('interval-input')), numIntervals.toString());
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();

  if (isWorkout) {
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
  }

  await setTimings(tester, workTime, restTime, fullWorkout);
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();

  expect(find.text('Work Sound'), findsOneWidget);
  await selectSound(tester, const Key('work-sound'), workSound);
  await selectSound(tester, const Key('rest-sound'), restSound);
  await selectSound(tester, const Key('halfway-sound'), halfwaySound);
  await selectSound(tester, const Key('countdown-sound'), countdownSound);
  await selectSound(tester, const Key('end-sound'), endSound);

  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();
  expect(find.text(workoutName), findsOneWidget);
}

Future<void> loadApp(WidgetTester tester) async {
  await tester.pumpWidget(const WorkoutTimer());
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

Future<void> navigateToAddWorkoutOrTimer(
    WidgetTester tester, bool isWorkout) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(isWorkout ? Icons.fitness_center : Icons.timer));
  await tester.pumpAndSettle();
}

Future<void> createWorkout(WidgetTester tester, String name) async {
  await tester.enterText(find.byKey(const Key('timer-name')), name);
  await createOrEditWorkoutOrTimer(
      tester,
      name,
      3,
      true,
      true,
      false,
      "Harsh beep sequence",
      "Ding",
      "Quick beep sequence",
      "Beep",
      "Horn",
      "10",
      "10");
}

Future<void> editWorkout(WidgetTester tester, String name) async {
  await tester.tap(find.byIcon(Icons.edit));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('timer-name')), name);
  await editWorkoutOne(tester, name, 2, true, true, false,
      "Harsh beep sequence", "Ding", "None", "Beep", "Horn", "20", "10");
}

Future<void> createTimer(WidgetTester tester, String name) async {
  await tester.enterText(find.byKey(const Key('timer-name')), name);
  await createOrEditWorkoutOrTimer(tester, name, 1, false, false, true, "None",
      "None", "None", "None", "None", "10", "10");
}

Future<void> verifyWorkoutOrTimerOpens(
    WidgetTester tester, String workoutName) async {
  await tester.tap(find.text(workoutName));
  await tester.pump(Duration(seconds: 1));
  expect(find.text("Start"), findsOneWidget);
}

Future<void> runWorkoutOne(WidgetTester tester) async {
  print("going to tap start");

  await tester.tap(find.text('Start'));
  print("tapped start");
  await tester.pumpAndSettle();
  print("checking for get ready");
  expect(find.textContaining("Get Ready"), findsOneWidget);

  for (int i = 0; i < 12; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
  print("Checking for push-ups");
  expect(find.textContaining("1 of 3"), findsOneWidget);
  expect(find.textContaining("Push-ups"), findsOneWidget);

  await tester.pump(const Duration(seconds: 10));
  expect(find.textContaining("1 of 3"), findsNothing);

  await tester.pump(const Duration(seconds: 10));
  expect(find.textContaining("2 of 3"), findsOneWidget);
  expect(find.textContaining("Sit-ups"), findsOneWidget);

  await tester.pump(const Duration(seconds: 20));
  expect(find.textContaining("3 of 3"), findsOneWidget);
  expect(find.textContaining("Jumping Jacks"), findsOneWidget);

  await tester.pump(const Duration(seconds: 10));
  expect(find.textContaining("Nice"), findsOneWidget);
  await tester.tap(find.text("Restart"));
  await tester.pumpAndSettle();
  expect(find.textContaining("Get Ready"), findsOneWidget);
}

Future<void> runWorkoutTwo(WidgetTester tester) async {
  await tester.tap(find.text('Start'));
  await tester.pumpAndSettle();
  expect(find.textContaining("Get Ready"), findsOneWidget);

  await tester.pump(const Duration(seconds: 10));
  expect(find.textContaining("1 of 2"), findsOneWidget);
  expect(find.textContaining("Push-ups"), findsOneWidget);

  await tester.pump(const Duration(seconds: 20));
  expect(find.textContaining("1 of 2"), findsNothing);

  await tester.pump(const Duration(seconds: 12));
  expect(find.textContaining("2 of 2"), findsOneWidget);
  expect(find.textContaining("Sit-ups"), findsOneWidget);

  await tester.pump(const Duration(seconds: 20));
  expect(find.textContaining("Nice"), findsOneWidget);
  await tester.tap(find.text("Restart"));
  await tester.pumpAndSettle();
  expect(find.textContaining("Get Ready"), findsOneWidget);
}

Future<void> runTimerOne(WidgetTester tester) async {
  await tester.tap(find.text('Start'));
  await tester.pumpAndSettle();
  expect(find.textContaining("Get Ready"), findsOneWidget);
  expect(find.textContaining("Warmup"), findsOneWidget);

  await tester.pump(const Duration(seconds: 50));
  await tester.pump(const Duration(seconds: 12));
  expect(find.textContaining("1 of 1"), findsOneWidget);
  expect(find.textContaining("Work"), findsAtLeast(1));

  await tester.pump(const Duration(seconds: 10));
  expect(find.textContaining("1 of 1"), findsNothing);
  expect(find.textContaining("Break"), findsAtLeast(1));

  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pump(Duration(seconds: 1));
  expect(find.text("Start"), findsOneWidget);
}

Future<void> deleteWorkoutOrTimer(WidgetTester tester, String name) async {
  await verifyWorkoutOrTimerOpens(tester, name);
  await tester.tap(find.byKey(const Key('Menu')));
  await tester.pump(Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.delete));
  await tester.pump(Duration(seconds: 1));
  await tester.tap(find.text("Delete"));
  await tester.pump(Duration(seconds: 1));
  expect(find.text(name), findsNothing);
}
