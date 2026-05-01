import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  test('umbrella reaches every public bootstrap symbol', () {
    expect(LiqColor, isNotNull);
    expect(LiqMaterial, isNotNull);
    expect(LiqBezel, isNotNull);
    expect(LiqTextStyle, isNotNull);
    expect(LiqSemantics, isNotNull);
    expect(LiqQuality.standard, LiqQuality.standard);
    expect(LiqThemeData, isNotNull);
    expect(LiqTheme, isNotNull);
    expect(LiqApp, isNotNull);
    expect(LiqGlassSurface, isNotNull);
    expect(LiqMaterialSurface, isNotNull);
    expect(LiqMotion, isNotNull);
  });
}
