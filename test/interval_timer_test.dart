import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhiit/main.dart';

const double portraitWidth = 1242.0;
const double portraitHeight = 2208.0;
const double landscapeWidth = portraitHeight;
const double landscapeHeight = portraitWidth;

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

void main() {
  testWidgets('Test CreateInterval', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();

    await binding.setSurfaceSize(const Size(portraitWidth, portraitHeight));

    String timerName = "Test interval timer 1";

    // Build our app and trigger a frame.
    await tester.pumpWidget(const WorkoutTimer());

    // Tap the '+' icon and trigger the add Workout or Timer page.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the next page has loaded.
    expect(find.text('Interval Timer'), findsOneWidget);
    expect(find.text('Workout'), findsOneWidget);

    ///
    /// CREATE FORM
    ///

    // Tap to add a Workout.
    await tester.tap(find.byIcon(Icons.timer));
    await tester.pumpAndSettle();

    // Verify that the next page has loaded.
    expect(find.text('Enter a name:'), findsOneWidget);

    // Enter a name
    await tester.enterText(find.byKey(const Key('timer-name')), timerName);

    await createOrEditWorkout(tester, timerName, 3, "Long whistle", "Ding",
        "Quick beep sequence", "Beep", "Horn", "60", "30");

    // Tap the workout to view details
    await tester.tap(find.text(timerName));

    await tester.pump(); // allow the application to handle

    await tester.pump(const Duration(seconds: 1)); // skip past the animation

    // Verify the ViewWorkout page has loaded
    expect(find.text("Start"), findsOneWidget);

    // Find and tap the edit button
    await tester.tap(find.byKey(const Key('edit-workout')));

    await tester.pump(); // allow the application to handle

    await tester.pump(const Duration(seconds: 1)); // skip past the animation

    await createOrEditWorkout(tester, timerName, 2, "Ding", "Long whistle",
        "Horn", "None", "Quick beep sequence", "90", "20");

    // Tap the workout to view details
    await tester.tap(find.text(timerName));

    await tester.pump(); // allow the application to handle

    await tester.pump(const Duration(seconds: 1)); // skip past the animation

    // Verify the ViewWorkout page has loaded
    expect(find.text("Start"), findsOneWidget);

    // Find and tap the delete button
    await tester.tap(find.byKey(const Key('delete-workout')));

    // Wait for the dialog to appear
    await tester.pump(const Duration(seconds: 1));

    // Verify that the dialog is displayed
    expect(find.text('Delete $timerName'), findsOneWidget);

    // Tap the Delete button in the dialog
    await tester.tap(find.text('Delete'));

    // Wait for the dialog to close
    await tester.pumpAndSettle();

    // Verify that the workout is no longer displayed
    expect(find.text(timerName), findsNothing);
  });
}
