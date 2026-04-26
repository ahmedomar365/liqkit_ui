import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/theme.dart';

void main() {
  group('LiqThemeData', () {
    test('light and dark factories produce distinct themes', () {
      const light = LiqThemeData.light;
      const dark = LiqThemeData.dark;
      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
      expect(light, isNot(dark));
    });

    test('copyWith returns a new instance with selected fields replaced', () {
      const base = LiqThemeData.light;
      final tweaked = base.copyWith(quality: LiqQuality.minimal);
      expect(tweaked.quality, LiqQuality.minimal);
      expect(base.quality, isNot(LiqQuality.minimal));
    });

    test('lerp returns the start at t=0 and the end at t=1', () {
      const a = LiqThemeData.light;
      const b = LiqThemeData.dark;
      expect(LiqThemeData.lerp(a, b, 0).brightness, Brightness.light);
      expect(LiqThemeData.lerp(a, b, 1).brightness, Brightness.dark);
    });
  });
}
