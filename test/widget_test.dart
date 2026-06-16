import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link_saver/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    expect(find.byType(MainApp), findsOneWidget);
    // Advance time to allow the splash timer to complete and avoid pending timers error
    await tester.pump(const Duration(milliseconds: 2500));
  });
}
