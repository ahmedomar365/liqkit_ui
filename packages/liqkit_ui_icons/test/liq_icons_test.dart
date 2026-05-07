import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

void main() {
  test('LiqIcons exposes a non-empty curated set', () {
    expect(LiqIcons.search, isNotNull);
    expect(LiqIcons.check, isNotNull);
    expect(LiqIcons.menu, isNotNull);
    expect(LiqIcons.trash, isNotNull);
    expect(LiqIcons.user, isNotNull);
  });
}
