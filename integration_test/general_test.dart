import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'functions/functions.dart';
import 'functions/general_functions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('end-to-end test', () {
    testWidgets('verify app load', (tester) async {
      await loadApp(tester);
      // await binding.setSurfaceSize(const Size(1080, 2400));
      expect(find.text('No saved timers'), findsOneWidget);
      await tapInfo(tester);
      await closeDialog(tester);
      expect(find.text('About OpenHIIT'), findsNothing);
    });
  });
}
