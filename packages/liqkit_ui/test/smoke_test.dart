import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  test('umbrella exports core types', () {
    expect(LiqThemeData.light.brightness.toString(), contains('light'));
    expect(LiqMaterial.regular.blurRadius, 12);
  });
}
