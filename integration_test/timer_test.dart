import 'package:flutter_test/flutter_test.dart';
import 'package:openhiit/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      // Load app widget.
      await tester.pumpWidget(const WorkoutTimer());

      // Wait for the text to appear.
      await tester.pumpAndSettle(const Duration(seconds: 15));

      // Verify the counter starts at 0.
      expect(find.text('No saved timers'), findsOneWidget);
    });
  });
}
