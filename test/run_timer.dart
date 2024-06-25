import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhiit/main.dart';

import 'functions.dart';

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

    await createOrEditWorkout(
        tester,
        workoutName,
        3,
        true,
        true,
        false,
        "Long whistle",
        "Ding",
        "Quick beep sequence",
        "Beep",
        "Horn",
        "10",
        "5");

    // Tap the workout to view details
    await tester.tap(find.text(workoutName));

    await tester.pump(); // allow the application to handle

    await tester.pump(const Duration(seconds: 1)); // skip past the animation

    // Verify the ViewWorkout page has loaded
    expect(find.text("Start"), findsOneWidget);

    // Find and tap the edit button
    await tester.tap(find.text("Start"));

    await tester.pump(); // allow the application to handle

    await tester.pump(const Duration(seconds: 1)); // skip past the animation

    // Verify the timer has started
    expect(find.text("Get ready"), findsOneWidget);

    await tester.pump(const Duration(
        seconds: 11)); // skip past the first portion of the timer

    // Should see text "1 of 3"
    expect(find.text("1 of 3"), findsOneWidget);
    // Verify the exercise name
    expect(find.textContaining("Push-ups"), findsAtLeast(2));

    await tester.pump(const Duration(
        seconds: 11)); // skip past the first work portion of the timer

    // Should no longer see text "1 of 3"
    expect(find.text("1 of 3"), findsNothing);

    await tester.pump(const Duration(
        seconds: 6)); // skip past the first rest portion of the timer

    // Should no longer see text "1 of 3"
    expect(find.text("2 of 3"), findsOne);
    // Verify the exercise name
    expect(find.textContaining("Sit-ups"), findsAtLeast(2));

    await tester.pump(const Duration(
        seconds: 11)); // skip past the second work portion of the timer

    // Should no longer see text "1 of 3"
    expect(find.text("2 of 3"), findsNothing);

    await tester.pump(const Duration(
        seconds: 6)); // skip past the second rest portion of the timer

    // Should no longer see text "1 of 3"
    expect(find.text("3 of 3"), findsOne);
    // Verify the exercise name
    expect(find.textContaining("Jumping Jacks"), findsAtLeast(2));

    await tester.pump(const Duration(
        seconds: 11)); // skip past the third work portion of the timer

    await tester.pump(const Duration(seconds: 2));

    // Find the Nice job screen
    expect(find.text("Nice job!"), findsOne);

    // Find and tap the restart button
    await tester.tap(find.text("Restart"));

    await tester.pump();

    await tester.pump(const Duration(seconds: 2));

    // Verify the timer has started
    expect(find.text("Get ready"), findsOneWidget);
  });
}
