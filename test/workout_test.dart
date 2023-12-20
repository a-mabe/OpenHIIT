// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:openhiit/main.dart';

Future changeTime(WidgetTester tester, int changeTime, String changeResult,
    String buttonKey) async {
  // Change time.
  for (var i = 0; i < changeTime; i++) {
    await tester.tap(find.byKey(Key(buttonKey)));
    await tester.pumpAndSettle();
  }

  // Time should be changed.
  expect(find.text(changeResult), findsOneWidget);
}

void main() {
  testWidgets('Add workout smoke test', (WidgetTester tester) async {
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
    expect(find.text('Enter a name:'), findsOneWidget);

    // Fill out the Workout name.
    expect(find.byKey(const Key('timer-name')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('timer-name')), workoutName);

    // Verify the workout name was filled out.
    expect(find.text(workoutName), findsOneWidget);

    // Verify the exercise number defaults to 10.
    expect(find.text('10'), findsOneWidget);

    //   for (var i = 0; i < 8; i++) {
    //     // Reduce the number of exercises by 1.
    //     await tester.tap(find.byIcon(Icons.remove));
    //     await tester.pumpAndSettle();
    //   }

    //   // Verify the exercise number is 2 as expected.
    //   expect(find.text('2'), findsOneWidget);

    //   await tester.dragUntilVisible(
    //     find.byType(InkWell), // what you want to find
    //     find.byType(SingleChildScrollView), // widget you want to scroll
    //     const Offset(-250, 0), // delta to move
    //   );

    //   // Tap to go to the next page.
    //   await tester.tap(find.byType(InkWell));
    //   await tester.pumpAndSettle();

    //   // Verify that the next page has loaded.
    //   expect(find.text('List Exercises'), findsOneWidget);

    //   for (var i = 1; i < 3; i++) {
    //     final exercise = find.ancestor(
    //       of: find.text('Exercise #$i'),
    //       matching: find.byType(TextFormField),
    //     );

    //     await tester.enterText(exercise, 'testing $i');

    //     expect(find.text('testing $i'), findsOneWidget);
    //   }

    //   // Tap to go to the next page.
    //   await tester.tap(find.byType(InkWell));
    //   await tester.pumpAndSettle();

    //   await changeTime(tester, 2, 'Working time: 18 seconds', 'work-decrement');
    //   await changeTime(tester, 3, 'Working time: 21 seconds', 'work-increment');
    //   await changeTime(tester, 2, 'Rest time: 8 seconds', 'rest-decrement');
    //   await changeTime(tester, 3, 'Rest time: 11 seconds', 'rest-increment');

    //   // Tap to go to the next page.
    //   await tester.tap(find.byType(InkWell));
    //   await tester.pumpAndSettle();

    //   // TODO: Test selecting different sounds.
    //   expect(find.widgetWithText(DropdownMenu<String>, "Short whistle"),
    //       findsNWidgets(5));

    //   await tester.dragUntilVisible(
    //     find.text("Submit"), // what you want to find
    //     find.byType(ListView), // widget you want to scroll
    //     const Offset(0, -250), // delta to move
    //   );

    //   // Tap to go to the next page.
    //   await tester.tap(
    //     find.text("Submit"),
    //   );
    //   await tester.pumpAndSettle();

    //   // expect(find.text(workoutName), findsOneWidget);
  });
}
