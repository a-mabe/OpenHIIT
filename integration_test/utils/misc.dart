import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'screenshot.dart';

Future<void> closeKeyboard(WidgetTester tester, bool settle) async {
  // Tap outside to close the keyboard
  FocusManager.instance.primaryFocus?.unfocus();
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

Future<void> pumpUntilFound(
    WidgetTester tester, Finder finder, Duration timeout, bool settle,
    {String? screenShotName}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(seconds: 1));
    if (finder.evaluate().isNotEmpty) {
      if (screenShotName == null) return;
      await takeScreenShot(
          binding: IntegrationTestWidgetsFlutterBinding.instance,
          tester: tester,
          screenShotName: screenShotName,
          settle: true);
      return;
    } else {
      await tester.pump();
    }
  }
  throw Exception('Timeout: Widget not found within $timeout');
}

Future<void> pumpAndSettleUntilFound(
    WidgetTester tester, Finder finder, Duration timeout,
    {String? screenShotName}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pumpAndSettle();
    if (finder.evaluate().isNotEmpty) {
      if (screenShotName == null) return;
      await takeScreenShot(
          binding: IntegrationTestWidgetsFlutterBinding.instance,
          tester: tester,
          screenShotName: screenShotName,
          settle: true);
      return;
    }
  }
  throw Exception('Timeout: Widget not found within $timeout');
}

Future<void> pumpUntilGone(
    WidgetTester tester, Finder finder, Duration timeout, bool settle,
    {String? screenShotName}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(Duration(seconds: 1));
    if (finder.evaluate().isEmpty) {
      if (screenShotName == null) return;
      await takeScreenShot(
          binding: IntegrationTestWidgetsFlutterBinding.instance,
          tester: tester,
          screenShotName: screenShotName,
          settle: true);
      return;
    }
    await Future.delayed(Duration(milliseconds: 100));
  }
  throw Exception('Timeout: Widget still found after $timeout');
}

Future<void> pumpUntilGoneAndSettle(
    WidgetTester tester, Finder finder, Duration timeout,
    {String? screenShotName}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pumpAndSettle();
    if (finder.evaluate().isEmpty) {
      if (screenShotName == null) return;
      await takeScreenShot(
          binding: IntegrationTestWidgetsFlutterBinding.instance,
          tester: tester,
          screenShotName: screenShotName,
          settle: true);
      return;
    }
    await Future.delayed(Duration(milliseconds: 100));
  }
  throw Exception('Timeout: Widget still found after $timeout');
}

Future<void> pumpForDuration(WidgetTester tester, Duration duration,
    {String? screenShotName, bool settle = false}) async {
  await tester.pump(duration);
  if (screenShotName != null) {
    await takeScreenShot(
        binding: IntegrationTestWidgetsFlutterBinding.instance,
        tester: tester,
        screenShotName: screenShotName,
        settle: settle);
  }
}
