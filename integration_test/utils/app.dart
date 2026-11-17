import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhiit/core/db/database.dart';
import 'package:openhiit/core/providers/theme_provider/theme_provider.dart';
import 'package:openhiit/features/whats_new/ui/whats_new_items.dart';
import 'package:openhiit/features/whats_new/utils/whats_new_service.dart';
import 'package:openhiit/main.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'pump_and_settle.dart';

/// Resets persisted state, starts the app, and waits for the home screen.
///
/// Every test starts from the same state as a fresh install, so results
/// don't depend on which tests ran before on the same device.
Future<void> launchApp(WidgetTester tester) async {
  await resetAppState();
  await tester.pumpWidget(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: const WorkoutTimer(),
    ),
  );
  await waitForHomeLoaded(tester);
}

/// Deletes the timer database and clears preferences. It also marks the
/// "What's new" dialog as seen, because the dialog appears after an
/// asynchronous preferences lookup and could otherwise pop up over the screen
/// partway through a test.
Future<void> resetAppState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await WhatsNewService.markShown(WhatsNewData.version);

  final dbPath = join(await getDatabasesPath(), DatabaseManager.databaseName);
  await databaseFactory.deleteDatabase(dbPath);
}

/// Waits until the home screen has finished loading timers and its "New"
/// button can be tapped.
///
/// Home reloads its list every time a route pops, showing a spinner in the
/// meantime, so call this after any navigation back to home.
Future<void> waitForHomeLoaded(WidgetTester tester) async {
  await waitUntil(
    tester,
    () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
    description: 'home screen to finish loading timers',
    timeout: const Duration(seconds: 30),
  );
  await waitForTappable(tester, find.byKey(const ValueKey('new-timer')));
}
