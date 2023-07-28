// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:openhiit/main.dart';

void main() {
  testWidgets('Load add workout smoke test', (WidgetTester tester) async {
    String workoutName = "Test workout 1";

    // Build our app and trigger a frame.
    await tester.pumpWidget(const WorkoutTimer());

    // Tap the '+' icon and trigger the add Workout or Timer page.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the next page has loaded.
    expect(find.text('Interval Timer'), findsOneWidget);
    expect(find.text('Workout'), findsOneWidget);

    // Tap to add a Workout.
    await tester.tap(find.byIcon(Icons.fitness_center));
    await tester.pumpAndSettle();

    // Verify that the next page has loaded.
    expect(find.text('Name this workout:'), findsOneWidget);

    // Fill out the Workout name.
    expect(find.byType(TextFormField), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), workoutName);

    // Verify the workout name was filled out.
    expect(find.text(workoutName), findsOneWidget);

    // Verify the exercise number defaults to 10.
    expect(find.text('10'), findsOneWidget);

    for (var i = 0; i < 8; i++) {
      // Reduce the number of exercises by 1.
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
    }

    // Verify the exercise number is 2 as expected.
    expect(find.text('2'), findsOneWidget);

    // Tap to go to the next page.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that the next page has loaded.
    expect(find.text('List Exercises'), findsOneWidget);

    for (var i = 1; i < 3; i++) {
      final exercise = find.ancestor(
        of: find.text('Exercise #$i'),
        matching: find.byType(TextFormField),
      );

      await tester.enterText(exercise, 'testing $i');

      expect(find.text('testing $i'), findsOneWidget);
    }
  });
}
