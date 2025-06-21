import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhiit/main.dart';

Future<void> loadApp(WidgetTester tester) async {
  await tester.pumpWidget(const WorkoutTimer());
  await tester.pumpAndSettle();
  await tester.pump(Duration(seconds: 2));
}

Future<void> tapInfoButton(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.info_outline));
  await tester.pumpAndSettle();
}

Future<void> closeInfoButton(WidgetTester tester) async {
  await tester.tap(find.text('Close'));
  await tester.pumpAndSettle();
}

Future<void> tapCreateTimerButton(WidgetTester tester) async {
  print("LOG --- Tapping create timer button");
  await tester.tap(find.byKey(const Key('create-timer')));
  await tester.pumpAndSettle();
}

Future<void> pickTimerType(WidgetTester tester, bool isWorkout) async {
  print("LOG --- Picking timer type: ${isWorkout ? 'Workout' : 'Timer'}");
  await tester.tap(find.byIcon(isWorkout ? Icons.fitness_center : Icons.timer));
  // Wait until the timer name input is present before proceeding
  while (find.byKey(const Key('timer-name')).evaluate().isEmpty) {
    await tester.pump();
  }
  await tester.pump();
}

Future<void> enterTimerName(WidgetTester tester, String name) async {
  print("LOG --- Entering timer name: $name");
  // Try to clear and enter the name until it appears on screen or timeout
  final timeout = Duration(seconds: 10);
  final interval = Duration(milliseconds: 200);
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    // Clear the text box first
    await tester.enterText(find.byKey(const Key('timer-name')), '');
    await tester.pump();

    // Enter the name
    await tester.enterText(find.byKey(const Key('timer-name')), name);
    await tester.pump();

    // Check if the name appears on screen
    if (find.text(name).evaluate().isNotEmpty) {
      break;
    }
    await tester.pump(interval);
  }
}

Future<void> clearTimerName(WidgetTester tester) async {
  await tester.enterText(find.byKey(const Key('timer-name')), '');
  await tester.pumpAndSettle();
}

Future<void> openColorPicker(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('color-picker')));
  await tester.pump();
}

Future<void> pickColor(WidgetTester tester) async {
  await openColorPicker(tester);
  final Size screenSize =
      tester.view.physicalSize / tester.view.devicePixelRatio;
  final Offset center = Offset(screenSize.width / 2, screenSize.height / 2);
  await tester.tapAt(center); // Adjust the offset as needed
  await tester.pump();
}

Future<void> enterInterval(WidgetTester tester, int interval) async {
  await tester.enterText(
    find.byKey(const Key('interval-input')),
    interval.toString(),
  );
  await tester.pump();
}

Future<void> closeKeyboard(WidgetTester tester) async {
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
}

Future<void> tapSubmit(WidgetTester tester) async {
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();
}

Future<void> enterExercise(
  WidgetTester tester,
  int index,
  String exercise,
) async {
  await tester.enterText(find.byKey(Key('exercise-$index')), exercise);
  await tester.pumpAndSettle();
}

Future<void> enterTime(WidgetTester tester, String key, String time) async {
  while (find.byKey(Key(key)).evaluate().isEmpty) {
    await tester.pump();
  }
  await tester.enterText(find.byKey(Key(key)), time);
  await tester.pump();
}

Future<void> tapSoundTab(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.volume_up));
  // Pump until "Work Sound" is found on the screen
  while (find.textContaining('Work Sound').evaluate().isEmpty) {
    await tester.pump();
  }
}

Future<void> tapEditorTab(WidgetTester tester) async {
  await tester.tap(find.textContaining('Editor'));
  // Wait for editor tab to finish loading (no timer-name or work-sound fields present)
  while (find.byKey(const Key('timer-name')).evaluate().isNotEmpty ||
      find.byKey(const Key('work-sound')).evaluate().isNotEmpty) {
    await tester.pump();
  }
  // Wait for loading spinner to disappear
  while (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
    await tester.pump();
  }
  while (find.textContaining('Work').evaluate().isEmpty) {
    await tester.pump();
  }
  // Ensure the editor tab is fully loaded
  await tester.pump();
}

// Future<void> tapAdvancedTile(WidgetTester tester) async {
//   await tester.tap(find.byType(ExpansionTile).first);
//   await tester.pumpAndSettle();
// }

Future<void> enterAdvancedTime(
  WidgetTester tester,
  String getReadySeconds,
  String cooldownSeconds,
  String warmupSeconds,
  String iterations,
  String breakSeconds,
) async {
  final timings = {
    'get ready-seconds': getReadySeconds,
    'cool down-seconds': cooldownSeconds,
    'warm-up-seconds': warmupSeconds,
    'restart-seconds': iterations,
    'break-seconds': breakSeconds,
  };
  for (var key in timings.keys) {
    if (key != 'break-seconds') {
      print("LOG --- Entering advanced time for $key: ${timings[key]}");
      await tester.ensureVisible(find.byKey(Key(key)));
      await tester.enterText(find.byKey(Key(key)), timings[key]!);
    } else if (timings[key] != "") {
      await tester.pump(Duration(seconds: 3));
      await tester.enterText(find.byKey(Key(key)), timings[key]!);
    }
  }
}

Future<void> selectSound(
  WidgetTester tester,
  String key,
  String soundName,
) async {
  print("LOG --- Selecting sound: $soundName");

  final dropdown = find.byKey(Key(key));
  await tester.ensureVisible(dropdown);
  await tester.pump();

  await tester.tap(dropdown);
  await tester.pump(const Duration(seconds: 1)); // let the menu appear

  final dropdownMenuItem = find.descendant(
    of: dropdown,
    matching: find.text(soundName),
  );

  if (dropdownMenuItem.evaluate().isNotEmpty) {
    await tester.tap(dropdownMenuItem.last);
    await tester.pump(Duration(seconds: 1));
    print("LOG --- Successfully selected sound: $soundName");
    return;
  }

  throw Exception('Could not find a tappable "$soundName" item.');
}

Future<void> enterEditorTileText(
  WidgetTester tester,
  String key,
  String text,
) async {
  print("LOG --- Entering text for $key: $text");

  // Try to clear and enter the text until it appears on screen or timeout
  final timeout = Duration(seconds: 10);
  final interval = Duration(milliseconds: 200);
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    // Ensure the text box is visible
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.pump();

    // Clear the text box first
    await tester.enterText(find.byKey(Key(key)), '');
    await tester.pump();

    // Enter the name
    await tester.enterText(find.byKey(Key(key)), text);
    await tester.pump();

    // Check if the text appears on screen
    if (find.text(text).evaluate().isNotEmpty) {
      break;
    }
    await tester.pump(interval);
  }
}

Future<void> tapSaveButton(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('save-timer')));
  // Wait until the 'create-timer' key is found before pumping
  while (find.byKey(const Key('create-timer')).evaluate().isEmpty) {
    await tester.pump();
  }
  await tester.pump();
}

Future<void> openViewTimer(WidgetTester tester, String name) async {
  await waitForText(tester, name);
  await tester.tap(find.text(name).first);
  while (find.text('Start').evaluate().isEmpty) {
    await tester.pump();
  }
}

Future<void> tapStartButton(WidgetTester tester) async {
  await tester.tap(find.text('Start'));
  await tester.pumpAndSettle();
}

Future<void> waitForText(WidgetTester tester, String text) async {
  final timeout = Duration(seconds: 180);
  final interval = Duration(seconds: 1);
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    if (find.textContaining(text).evaluate().isNotEmpty) {
      print("LOG --- Found text '$text', breaking the loop");
      return;
    } else {
      print("LOG --- Text '$text' not found yet");
    }
    await tester.pump(interval);
    print("LOG --- waiting for '$text' to appear");
  }

  throw Exception('Text "$text" not found within $timeout.');
}

Future<void> deleteWorkoutOrTimer(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('Menu')));
  await tester.pump(Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.delete));
  await tester.pump(Duration(seconds: 1));
  await tester.tap(find.text("Delete"));
  await tester.pump(Duration(seconds: 1));
  await tester.pumpAndSettle();
}

Future<void> copyWorkoutOrTimer(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('Menu')));
  await tester.pump(Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.copy));
  await tester.pump(Duration(seconds: 1));
  await tester.pumpAndSettle();
}

Future<void> editWorkoutOrTimer(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.edit));
  await tester.pump(Duration(seconds: 1));
}

Future<void> tapRestart(WidgetTester tester) async {
  await tester.tap(find.text('Restart'));
  await tester.pumpAndSettle();
}

Future<void> tapBackButton(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
}

Future<void> tapAppBarBack(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('run-timer-appbar-back-button')));
  while (find.text('Start').evaluate().isEmpty) {
    await tester.pump();
  }
}

Future<void> tapTimerEndBack(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('timer-end-back')));
  while (find.text('Start').evaluate().isEmpty) {
    await tester.pump();
  }
}

Future<void> tapPauseButton(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.pause));
  await tester.pumpAndSettle();
}

Future<void> tapResumeButton(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.play_arrow));
  await tester.pumpAndSettle();
}

Future<void> tapNextButton(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.skip_next));
  await tester.pumpAndSettle();
}

Future<void> tapMinutesSecondsToggle(WidgetTester tester, bool minutes) async {
  await tester.tap(find.byKey(const Key('timer-display-toggle')));
  await tester.pump();

  while (find.byKey(Key("minutes-option")).evaluate().isEmpty) {
    await tester.pump();
  }

  if (minutes) {
    await tester.tap(find.byKey(Key("minutes-option")));
  } else {
    await tester.tap(find.byKey(Key("seconds-option")));
  }

  while (find.byKey(Key("minutes-option")).evaluate().isNotEmpty) {
    await tester.pump();
  }
}

// Future<void> waitUntilTappable(Finder finder, WidgetTester tester) async {
//   const timeout = Duration(seconds: 5);
//   const interval = Duration(milliseconds: 100);
//   final endTime = DateTime.now().add(timeout);

//   while (DateTime.now().isBefore(endTime)) {
//     await tester.pump(interval);
//     final hitTestable = tester.hitTestOnBinding(finder.evaluate().first.size?.center(Offset.zero)).path;
//     if (hitTestable.isNotEmpty) return;
//   }

//   throw Exception("Widget never became tappable: $finder");
// }
