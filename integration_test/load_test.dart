import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils/app.dart';
import 'utils/screenshot.dart';
import 'utils/tap_buttons.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app_loads_no_saved_timers', (WidgetTester tester) async {
    await launchApp(tester);

    // Tap "Got it!" to dismiss the welcome screen.
    await tapGotItButton(tester, binding);

    // Take initial screenshot to confirm the home screen is loaded.
    await takeScreenShot(
      binding: binding,
      tester: tester,
      screenShotName: '1_load_no-saved-timers',
      settle: true,
    );

    // Expect "No saved timers" to be visible.
    expect(find.textContaining("No saved timers"), findsOneWidget,
        reason: 'Expected message not found on home screen');
  });
}
