import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> selectSound(WidgetTester tester, Key key, String soundName) async {
  await tester.tap(find.byKey(key));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.descendant(
    of: find.byKey(key),
    matching: find.text(soundName),
  ));
  await tester.pumpAndSettle();
}

Future<void> createOrEditWorkout(
    WidgetTester tester,
    String workoutName,
    int numIntervals,
    bool addExercises,
    bool isWorkout,
    String workSound,
    String restSound,
    String halfwaySound,
    String countdownSound,
    String endSound,
    String workTime,
    String restTime) async {
  // Tap the color picker
  await tester.tap(find.byKey(const Key('color-picker')));
  await tester.pumpAndSettle(); // Wait for the dialog to appear

  // In the color picker dialog, select a color
  await tester.tap(find.text('Select'));
  await tester.pumpAndSettle(); // Wait for the dialog to close

  // Enter the number of intervals
  await tester.enterText(
      find.byKey(const Key('interval-input')), numIntervals.toString());

  // Tap the Timer Display option (assuming there are two options)
  // await tester.tap(find.text('Timer display:').last);
  // await tester.pumpAndSettle();

  // Submit the form
  await tester.tap(find.text(
      'Submit')); // Replace 'Submit' with the actual text of your submit button
  await tester.pumpAndSettle();

  ///
  /// SET EXERCISES
  ///

  if (addExercises) {
    // Enter exercise names
    await tester.enterText(find.byKey(const Key('exercise-0')), 'Push-ups');
    await tester.enterText(find.byKey(const Key('exercise-1')), 'Sit-ups');
    await tester.enterText(
        find.byKey(const Key('exercise-2')), 'Jumping Jacks');
  }

  if (isWorkout) {
    // Tap the Submit button
    await tester.tap(find.text('Submit'));

    // Wait for the navigation to complete
    await tester.pumpAndSettle();
  }

  ///
  /// SET TIMINGS
  ///

  // Verify that the setTimings view has loaded
  expect(find.byKey(const Key('work-seconds')), findsOneWidget);

  // Enter work time
  await tester.enterText(find.byKey(const Key('work-seconds')), workTime);

  // Enter rest time
  await tester.enterText(find.byKey(const Key('rest-seconds')), restTime);

  // Tap the Submit button
  await tester.tap(find.text('Submit'));

  // Wait for the navigation to complete
  await tester.pumpAndSettle();

  ///
  /// SET SOUNDS
  ///

  // Verify that the SetSounds screen is navigated to
  expect(find.text('Work Sound'), findsOneWidget);

  // Select work sound
  await selectSound(tester, const Key('work-sound'), workSound);

  // Select rest sound
  await selectSound(tester, const Key('rest-sound'), restSound);

  // Select halfway sound
  await selectSound(tester, const Key('halfway-sound'), halfwaySound);

  // Select countdown sound
  await selectSound(tester, const Key('countdown-sound'), countdownSound);

  // Select end sound
  await selectSound(tester, const Key('end-sound'), endSound);

  // Tap the Submit button
  await tester.tap(find.text('Submit'));

  // Wait for the navigation to complete
  await tester.pumpAndSettle();

  ///
  /// MAIN PAGE
  ///

  // Verify that the workout was submitted successfully
  expect(find.text(workoutName), findsOneWidget);
}
