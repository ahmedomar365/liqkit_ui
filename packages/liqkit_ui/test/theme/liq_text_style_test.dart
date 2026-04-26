import 'dart:ui' show FontWeight;

import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/theme.dart';

void main() {
  test('LiqTextStyle is const-constructible and copies', () {
    const a = LiqTextStyle(
      family: 'SF Pro Text',
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.4,
      heightMultiplier: 1.29,
    );
    final b = a.copyWith(fontSize: 18);
    expect(a.fontSize, 17);
    expect(b.fontSize, 18);
    expect(b.family, a.family);
  });
}
