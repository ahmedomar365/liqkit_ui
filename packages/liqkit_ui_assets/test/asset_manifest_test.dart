import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui_assets/liqkit_ui_assets.dart';

void main() {
  test('LiqFontLoader.loadAll completes and is idempotent', () async {
    await LiqFontLoader.loadAll();
    await LiqFontLoader.loadAll();
  });
}
