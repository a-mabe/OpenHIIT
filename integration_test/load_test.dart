import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openhiit/main.dart';
import 'utils/screenshot.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app_loads_no_saved_timers', (WidgetTester tester) async {
    await tester.pumpWidget(WorkoutTimer());
    await tester.pumpAndSettle();

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
