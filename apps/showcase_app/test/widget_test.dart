import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_liquid_ui_kit/main.dart';

void main() {
  testWidgets('Liquid UI Kit app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: LiquidUIKitApp(),
      ),
    );

    // Verify that the app title is shown
    expect(find.text('Liquid UI Kit'), findsOneWidget);
  });
}
