import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/src/foundation/liq_typography.dart';

void main() {
  group('LiqFontFamily.forSize', () {
    test('< 20pt returns SF Pro Text', () {
      expect(LiqFontFamily.forSize(8), 'SF Pro Text');
      expect(LiqFontFamily.forSize(13), 'SF Pro Text');
      expect(LiqFontFamily.forSize(15), 'SF Pro Text');
      expect(LiqFontFamily.forSize(17), 'SF Pro Text');
      expect(LiqFontFamily.forSize(19.99), 'SF Pro Text');
    });
    test('>= 20pt returns SF Pro Display', () {
      expect(LiqFontFamily.forSize(20), 'SF Pro Display');
      expect(LiqFontFamily.forSize(22), 'SF Pro Display');
      expect(LiqFontFamily.forSize(28), 'SF Pro Display');
      expect(LiqFontFamily.forSize(48), 'SF Pro Display');
    });
    test('fallback chain is non-empty', () {
      expect(LiqFontFamily.fallback, isNotEmpty);
    });
  });
}
