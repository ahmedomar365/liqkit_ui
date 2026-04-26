import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/theme.dart';

void main() {
  group('LiqMaterial', () {
    test('is const-constructible with finite fields', () {
      // Build a fresh LiqMaterial (not the canonical .regular) so we
      // exercise the const constructor in test directly.
      const m = LiqMaterial(
        blurRadius: 11,
        tint: LiqColor(light: Color(0x22ABCDEF), dark: Color(0x22FEDCBA)),
        vibrancy: <double>[
          1, 0, 0, 0, 0, //
          0, 1, 0, 0, 0, //
          0, 0, 1, 0, 0, //
          0, 0, 0, 1, 0, //
        ],
      );
      expect(m.blurRadius, 11);
      expect(m.vibrancy.length, 20);
    });

    test('predefined variants are accessible as static const', () {
      expect(LiqMaterial.regular.blurRadius, greaterThan(0));
      expect(LiqMaterial.solid.blurRadius, 0);
    });

    test('blurRadius > 18 throws an assertion in debug', () {
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

    test('every predefined variant has a length-20 vibrancy', () {
      for (final m in <LiqMaterial>[
        LiqMaterial.regular,
        LiqMaterial.ultraThin,
        LiqMaterial.thin,
        LiqMaterial.thick,
        LiqMaterial.chrome,
        LiqMaterial.solid,
      ]) {
        expect(m.debugAssertVibrancy(), isTrue);
      }
    });
  });
}
