import 'package:flutter/material.dart';
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
  await tester.tap(find.byKey(const Key('create-timer')));
  await tester.pumpAndSettle();
}

Future<void> pickTimerType(WidgetTester tester, bool isWorkout) async {
  await tester.tap(find.byIcon(isWorkout ? Icons.fitness_center : Icons.timer));
  await tester.pumpAndSettle();
}

Future<void> enterTimerName(WidgetTester tester, String name) async {
  // Try to clear and enter the name until it appears on screen or timeout
  final timeout = Duration(seconds: 10);
  final interval = Duration(milliseconds: 200);
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    // Clear the text box first
    await tester.enterText(find.byKey(const Key('timer-name')), '');
    await tester.pumpAndSettle();

    // Enter the name
    await tester.enterText(find.byKey(const Key('timer-name')), name);
    await tester.pumpAndSettle();

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
  await tester.pumpAndSettle();
}

Future<void> pickColor(WidgetTester tester) async {
  await openColorPicker(tester);
  final Size screenSize =
      tester.view.physicalSize / tester.view.devicePixelRatio;
  final Offset center = Offset(screenSize.width / 2, screenSize.height / 2);
  await tester.tapAt(center);
  await tester.pumpAndSettle();
}

Future<void> enterInterval(WidgetTester tester, int interval) async {
  await tester.enterText(
      find.byKey(const Key('interval-input')), interval.toString());
  await tester.pumpAndSettle();
}

Future<void> closeKeyboard(WidgetTester tester) async {
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> tapSubmit(WidgetTester tester) async {
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();
}

Future<void> enterExercise(
    WidgetTester tester, int index, String exercise) async {
  await tester.enterText(find.byKey(Key('exercise-$index')), exercise);
  await tester.pumpAndSettle();
}

Future<void> enterTime(WidgetTester tester, String key, String time) async {
  await tester.enterText(find.byKey(Key(key)), time);
  await tester.pumpAndSettle();
}

Future<void> tapAdvancedTile(WidgetTester tester) async {
  await tester.tap(find.byType(ExpansionTile).first);
  await tester.pumpAndSettle();
}

Future<void> enterAdvancedTime(
    WidgetTester tester,
    String getReadySeconds,
    String cooldownSeconds,
    String warmupSeconds,
    String iterations,
    String breakSeconds) async {
  await tapAdvancedTile(tester);
  final timings = {
    'get-ready-seconds': getReadySeconds,
    'cooldown-seconds': cooldownSeconds,
    'warmup-seconds': warmupSeconds,
    'iterations': iterations,
    'break-seconds': breakSeconds
  };
  for (var key in timings.keys) {
    if (key != 'break-seconds') {
      await tester.enterText(find.byKey(Key(key)), timings[key]!);
    } else if (timings[key] != "") {
      await tester.pump(Duration(seconds: 3));
      await tester.enterText(find.byKey(Key(key)), timings[key]!);
    }
  }
}

Future<void> selectSound(
    WidgetTester tester, String key, String soundName) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
  await tester.tap(find
      .descendant(of: find.byKey(Key(key)), matching: find.text(soundName))
      .last);
  await tester.pumpAndSettle();
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
  await tester.pumpAndSettle();
}

Future<void> tapRestart(WidgetTester tester) async {
  await tester.tap(find.text('Restart'));
  await tester.pumpAndSettle();
}

Future<void> tapBackButton(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
}

Future<void> tapBackText(WidgetTester tester) async {
  await tester.tap(find.text('Back'));
  await tester.pumpAndSettle();
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

Future<void> tapMinutesSecondsToggle(WidgetTester tester) async {
  await tester.tap(find.textContaining("1:42"));
  await tester.pumpAndSettle();
}
