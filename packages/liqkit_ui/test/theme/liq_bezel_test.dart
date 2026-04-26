import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/theme.dart';

void main() {
  test('LiqBezel is const-constructible and exposes radii', () {
    const b = LiqBezel(
      cornerRadius: 18,
      innerHighlight: 0.06,
      outerShadowOpacity: 0.18,
    );
    expect(b.cornerRadius, 18);
    expect(b.copyWith(cornerRadius: 22).cornerRadius, 22);
  });
}
