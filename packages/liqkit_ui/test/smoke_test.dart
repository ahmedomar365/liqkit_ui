import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  test('liqkit_ui umbrella imports and exposes the bootstrap marker', () {
    expect(liqkitUiBootstrapMarker, 'liqkit_ui-bootstrap');
  });
}
