import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  testWidgets('LiqApp installs LiqTheme and resolves system brightness',
      (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    LiqThemeData? captured;
    await tester.pumpWidget(
      LiqApp(
        light: LiqThemeData.light,
        dark: LiqThemeData.dark,
        home: Builder(
          builder: (context) {
            captured = LiqTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(captured, LiqThemeData.dark);
  });
}
