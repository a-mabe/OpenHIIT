import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhiit/main.dart';

Future<void> loadApp(WidgetTester tester) async {
  await tester.pumpWidget(const WorkoutTimer());
  await tester.pumpAndSettle();
  await tester.pump(Duration(seconds: 2));
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
  await tester.enterText(find.byKey(const Key('timer-name')), name);
  await tester.pumpAndSettle();
}

Future<void> pickColor(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('color-picker')));
  await tester.pumpAndSettle();
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

Future<void> enterAdvancedTime(
    WidgetTester tester,
    String getReadySeconds,
    String cooldownSeconds,
    String warmupSeconds,
    String iterations,
    String breakSeconds) async {
  await tester.tap(find.byType(ExpansionTile).first);
  await tester.pumpAndSettle();
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
    } else {
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

Future<void> deleteWorkoutOrTimer(WidgetTester tester, String name) async {
  await tester.tap(find.byKey(const Key('Menu')));
  await tester.pump(Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.delete));
  await tester.pump(Duration(seconds: 1));
  await tester.tap(find.text("Delete"));
  await tester.pump(Duration(seconds: 1));
  await tester.pumpAndSettle();
}

Future<void> copyWorkoutOrTimer(WidgetTester tester, String name) async {
  await tester.tap(find.byKey(const Key('Menu')));
  await tester.pump(Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.copy));
  await tester.pump(Duration(seconds: 1));
  await tester.pumpAndSettle();
}

Future<void> tapRestart(WidgetTester tester) async {
  await tester.tap(find.text('Restart'));
  await tester.pumpAndSettle();
}
