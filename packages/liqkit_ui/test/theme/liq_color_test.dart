import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/theme.dart';

void main() {
  group('LiqColor', () {
    test('is const-constructible and exposes light/dark via resolve()', () {
      const c = LiqColor(light: Color(0xFFAA0011), dark: Color(0xFF11AA00));
      expect(c.resolve(Brightness.light), const Color(0xFFAA0011));
      expect(c.resolve(Brightness.dark), const Color(0xFF11AA00));
    });

    test('equality and hashCode follow value semantics', () {
      const a = LiqColor(light: Color(0xFFFFFFFF), dark: Color(0xFF000000));
      const b = LiqColor(light: Color(0xFFFFFFFF), dark: Color(0xFF000000));
      const c = LiqColor(light: Color(0xFFFFFFFE), dark: Color(0xFF000000));
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
    });

    test('debugFillProperties names both colors', () {
      const c = LiqColor(light: Color(0xFFFFFFFF), dark: Color(0xFF000000));
      final builder = DiagnosticPropertiesBuilder();
      c.debugFillProperties(builder);
      final names = builder.properties.map((p) => p.name).toSet();
      expect(names, containsAll(<String>{'light', 'dark'}));
    });
  });
}
