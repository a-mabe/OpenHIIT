import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'functions/functions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('end-to-end test', () {
    testWidgets('timer with exercises and all settings changed',
        (tester) async {
      await loadApp(tester);
      expect(find.text('No saved timers'), findsOneWidget);
      await tapCreateTimerButton(tester);
      await pickTimerType(tester, false);
      await enterTimerName(tester, 'Test Workout');
      await pickColor(tester);
      await enterInterval(tester, 2);
      await enterTime(tester, "work-seconds", "8");
      await enterTime(tester, "rest-seconds", "5");
      await enterAdvancedTime(tester, "7", "8", "8", "1", "5");
      await closeKeyboard(tester);
      await tapSoundTab(tester);
      await selectSound(tester, "work-sound", "None");
      await selectSound(tester, "rest-sound", "None");
      await selectSound(tester, "halfway-sound", "None");
      await selectSound(tester, "countdown-sound", "None");
      await selectSound(tester, "end-sound", "None");
      await tapEditorTab(tester);
      await enterEditorTileText(tester, "editor-3", "Push-ups");
      await enterEditorTileText(tester, "editor-5", "Squats");
      await enterEditorTileText(tester, "editor-7", "Push-ups");
      await enterEditorTileText(tester, "editor-9", "Squats");
      await tapSaveButton(tester);
      await openViewTimer(tester, 'Test Workout');
      await tapStartButton(tester);
      await waitForText(tester, "7");
      await waitForText(tester, "Warmup");
      await waitForText(tester, "1 of 2");
      await tapPauseButton(tester);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      await tapResumeButton(tester);
      expect(find.byIcon(Icons.pause), findsOneWidget);
      await waitForText(tester, "Push-ups");
      await waitForText(tester, "2 of 2");
      await waitForText(tester, "Squats");
      await waitForText(tester, "Break");
      await waitForText(tester, "1 of 2");
      await waitForText(tester, "Push-ups");
      await waitForText(tester, "2 of 2");
      await waitForText(tester, "Squats");
      await waitForText(tester, "Cooldown");
      await waitForText(tester, "Nice job!");
    });

    testWidgets('edit workout and verify pre-filled settings, then change them',
        (tester) async {
      // Assumes previous test created 'Test Workout'
      await loadApp(tester);
      await openViewTimer(tester, 'Test Workout');
      await editWorkoutOrTimer(tester);

      // Check that timer name is pre-filled
      expect(find.text('Test Workout'), findsOneWidget);

      // Check intervals count is pre-filled
      expect(find.widgetWithText(TextFormField, '2'), findsOneWidget);
      await tapSubmit(tester);

      // Check exercises are pre-filled
      expect(find.widgetWithText(TextFormField, 'Push-ups'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Squats'), findsOneWidget);
      await tapSubmit(tester);

      // await tapAdvancedTile(tester);

      // Check times are pre-filled
      expect(find.widgetWithText(TextFormField, '8'),
          findsWidgets); // work-seconds, advanced times
      expect(find.widgetWithText(TextFormField, '5'),
          findsWidgets); // rest-seconds, advanced times
      expect(find.widgetWithText(TextFormField, '7'), findsOneWidget); // warmup
      await tapSubmit(tester);

      // Check sounds are pre-filled as "None"
      expect(find.text('None'), findsNWidgets(10));

      await tapBackButton(tester);
      await tapBackButton(tester);
      await tapBackButton(tester);

      // Now, change the settings slightly
      await clearTimerName(tester);
      await enterTimerName(tester, 'Test Workout Edited');
      await enterInterval(tester, 3);
      await tapSubmit(tester);
      await enterExercise(tester, 2, "Planks");
      await tapSubmit(tester);
      await enterTime(tester, "work-seconds", "10");
      await enterTime(tester, "rest-seconds", "6");
      // await enterAdvancedTime(tester, "8", "9", "10", "2", "6");
      await tapSubmit(tester);
      await selectSound(tester, "work-sound", "Beep");
      await selectSound(tester, "rest-sound", "Beep");
      await selectSound(tester, "halfway-sound", "Beep");
      await selectSound(tester, "countdown-sound", "Beep");
      await selectSound(tester, "end-sound", "Beep");

      // Submit the changes
      await tapSubmit(tester);

      // Verify the workout name is updated in the list
      expect(find.text('Test Workout Edited'), findsOneWidget);

      // Open the edited workout and check new values
      await openViewTimer(tester, 'Test Workout Edited');
      await editWorkoutOrTimer(tester);

      expect(find.text('Test Workout Edited'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '3'), findsOneWidget);
      await tapSubmit(tester);
      expect(find.widgetWithText(TextFormField, 'Push-ups'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Squats'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Planks'), findsOneWidget);
      await tapSubmit(tester);
      // await tapAdvancedTile(tester);
      expect(find.widgetWithText(TextFormField, '10'), findsWidgets);
      expect(find.widgetWithText(TextFormField, '6'), findsWidgets);
      expect(find.widgetWithText(TextFormField, '8'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '9'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '2'), findsOneWidget);
      await tapSubmit(tester);

      // Check sounds are now "Beep"
      expect(find.text('Beep'), findsNWidgets(10));
    });

    testWidgets(
        'edit workout, decrease intervals, and verify pre-filled settings',
        (tester) async {
      // Assumes previous test created 'Test Workout'
      await loadApp(tester);
      await openViewTimer(tester, 'Test Workout Edited');
      await editWorkoutOrTimer(tester);

      expect(find.text('Test Workout Edited'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '3'), findsOneWidget);
      await tapSubmit(tester);
      expect(find.widgetWithText(TextFormField, 'Push-ups'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Squats'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Planks'), findsOneWidget);
      await tapSubmit(tester);
      // await tapAdvancedTile(tester);
      expect(find.widgetWithText(TextFormField, '10'), findsWidgets);
      expect(find.widgetWithText(TextFormField, '6'), findsWidgets);
      expect(find.widgetWithText(TextFormField, '8'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '9'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '2'), findsOneWidget);
      await tapSubmit(tester);

      // Check sounds are "Beep"
      expect(find.text('Beep'), findsNWidgets(10));

      await tapBackButton(tester);
      await tapBackButton(tester);
      await tapBackButton(tester);

      await enterInterval(tester, 1);
      await tapSubmit(tester);
      await tapSubmit(tester);
      // await tapAdvancedTile(tester);
      // await enterAdvancedTime(tester, "8", "9", "10", "2", "0");
      await tapSubmit(tester);
      await tapSubmit(tester);

      await openViewTimer(tester, 'Test Workout Edited');

      // Only "Push-ups" should be present
      expect(find.textContaining('Push-ups'), findsAtLeast(1));
      expect(find.textContaining('Squats'), findsNothing);
      expect(find.textContaining('Planks'), findsNothing);
      expect(find.textContaining('Break'), findsNothing);

      await tapStartButton(tester);
      await waitForText(tester, "Get Ready");
      await waitForText(tester, "1 of 1");
      await waitForText(tester, "Nice job!");
      await tapTimerEndBack(tester);
      await tapBackButton(tester);
      await waitForText(tester, "Test Workout Edited");
    });

    testWidgets(
        'edit workout, decrease intervals, and verify pre-filled settings',
        (tester) async {
      // Assumes previous test created 'Test Workout'
      await loadApp(tester);
      await openViewTimer(tester, 'Test Workout Edited');
      await editWorkoutOrTimer(tester);

      expect(find.text('Test Workout Edited'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '1'), findsOneWidget);
      await tapSubmit(tester);
      expect(find.widgetWithText(TextFormField, 'Push-ups'), findsOneWidget);
      await tapSubmit(tester);
      // await tapAdvancedTile(tester);
      // await enterAdvancedTime(tester, "8", "9", "10", "0", "");
      await tapSubmit(tester);

      // Check sounds are "Beep"
      expect(find.text('Beep'), findsNWidgets(10));

      await tapSubmit(tester);
      await openViewTimer(tester, 'Test Workout Edited');

      // Only "Push-ups" should be present
      expect(find.textContaining('Push-ups'), findsOneWidget);
      expect(find.textContaining('Squats'), findsNothing);
      expect(find.textContaining('Planks'), findsNothing);
      expect(find.textContaining('Break'), findsNothing);

      await tapStartButton(tester);
      await waitForText(tester, "Get Ready");
      await waitForText(tester, "1 of 1");
      await waitForText(tester, "Nice job!");
      await tapTimerEndBack(tester);
      await tapBackButton(tester);
      await waitForText(tester, "Test Workout Edited");
    });
  });
}
