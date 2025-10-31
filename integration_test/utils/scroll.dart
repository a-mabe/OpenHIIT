import 'package:flutter_test/flutter_test.dart';

Future<void> scrollUntilVisible(
    WidgetTester tester, Finder scrollableFinder, Finder itemFinder,
    {double scrollAmount = 300.0,
    int maxScrolls = 10,
    Duration duration = const Duration(milliseconds: 500),
    bool settle = true}) async {
  int scrolls = 0;
  while (scrolls < maxScrolls && tester.any(itemFinder) == false) {
    await tester.drag(scrollableFinder, Offset(0, -scrollAmount));
    if (settle) {
      await tester.pumpAndSettle(duration);
    } else {
      await tester.pump(duration);
    }
    scrolls++;
  }
  if (tester.any(itemFinder) == false) {
    throw Exception('Item not found after $maxScrolls scrolls');
  }
}
