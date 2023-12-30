import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhiit/main.dart';

const double portraitWidth = 1242.0;
const double portraitHeight = 2208.0;
const double landscapeWidth = portraitHeight;
const double landscapeHeight = portraitWidth;

void main() {
  testWidgets('Test CreateWorkout', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();

    await binding.setSurfaceSize(const Size(portraitWidth, portraitHeight));

    String workoutName = "Test workout 1";

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
    await tester.tap(find.byIcon(Icons.fitness_center));
    await tester.pumpAndSettle();

    // Verify that the next page has loaded.
    expect(find.text('Enter a name:'), findsOneWidget);

    // Enter a name
    await tester.enterText(find.byKey(const Key('timer-name')), workoutName);

    // Tap the color picker
    await tester.tap(find.byKey(const Key('color-picker')));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // In the color picker dialog, select a color
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle(); // Wait for the dialog to close

    // Enter the number of intervals
    await tester.enterText(find.byKey(const Key('interval-input')), '3');

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

    // Enter exercise names
    await tester.enterText(find.byKey(const Key('exercise-0')), 'Push-ups');
    await tester.enterText(find.byKey(const Key('exercise-1')), 'Sit-ups');
    await tester.enterText(
        find.byKey(const Key('exercise-2')), 'Jumping Jacks');

    // Tap the Submit button
    await tester.tap(find.text('Submit'));

    // Wait for the navigation to complete
    await tester.pumpAndSettle();

    ///
    /// SET TIMINGS
    ///

    // Verify that the setTimings view has loaded
    expect(find.byKey(const Key('work-seconds')), findsOneWidget);

    // Enter work time
    await tester.enterText(find.byKey(const Key('work-seconds')), '60');

    // Enter rest time
    await tester.enterText(find.byKey(const Key('rest-seconds')), '30');

    // Tap the Submit button
    await tester.tap(find.text('Submit'));

    // Wait for the navigation to complete
    await tester.pumpAndSettle();

    ///
    /// SET SOUNDS
    ///

    // Verify that the SetSounds screen is navigated to
    expect(find.text('Work Sound'), findsOneWidget);

    // Tap the dropdowns and select sound options
    await tester.tap(find.byKey(const Key('work-sound')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.descendant(
        of: find.byKey(const Key('work-sound')),
        matching: find.text('Long whistle')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('rest-sound')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.descendant(
        of: find.byKey(const Key('rest-sound')), matching: find.text("Ding")));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('halfway-sound')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.descendant(
        of: find.byKey(const Key('halfway-sound')),
        matching: find.text('Quick beep sequence')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('countdown-sound')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.descendant(
        of: find.byKey(const Key('countdown-sound')),
        matching: find.text('Beep')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('end-sound')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.descendant(
        of: find.byKey(const Key('end-sound')), matching: find.text('Horn')));
    await tester.pumpAndSettle();

    // Tap the Submit button
    await tester.tap(find.text('Submit'));

    // Wait for the navigation to complete
    await tester.pumpAndSettle();

    ///
    /// MAIN PAGE
    ///

    // Verify that the workout was submitted successfully
    expect(find.text(workoutName), findsOneWidget);

    // Tap the workout to view details
    await tester.tap(find.text(workoutName));

    // Wait for the navigation to complete
    await tester.pumpAndSettle();

    // Verify the ViewWorkout page has loaded
    expect(find.text("Start"), findsOneWidget);

    // Find and tap the delete button
    await tester.tap(find.byKey(const Key('delete-workout')));

    // Wait for the dialog to appear
    await tester.pump(const Duration(seconds: 1));

    // Verify that the dialog is displayed
    expect(find.text('Delete $workoutName'), findsOneWidget);

    // Tap the Delete button in the dialog
    await tester.tap(find.text('Delete'));

    // Wait for the dialog to close
    await tester.pumpAndSettle();

    // Verify that the workout is no longer displayed
    expect(find.text(workoutName), findsNothing);
  });
}
