import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/foundation.dart';
import 'package:liqkit_ui/theme.dart';

void main() {
  group('LiqGlassSurface', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: LiqGlassSurface(
              material: LiqMaterial.regular,
              child: SizedBox(width: 100, height: 100, child: Text('hi')),
            ),
          ),
        ),
      );
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('respects LiqQuality.minimal by skipping the BackdropFilter', (
      tester,
    ) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light.copyWith(quality: LiqQuality.minimal),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: LiqGlassSurface(
              material: LiqMaterial.solid,
              child: SizedBox(width: 32, height: 32),
            ),
          ),
        ),
      );
      expect(find.byType(BackdropFilter), findsNothing);
    });

    test('LiqMaterial blurRadius outside [0, 18] cannot be constructed', () {
      expect(
        () => LiqMaterial(
          blurRadius: 99,
          tint: const LiqColor(
            light: Color(0x00000000),
            dark: Color(0x00000000),
          ),
          vibrancy: LiqMaterial.identityVibrancy,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
