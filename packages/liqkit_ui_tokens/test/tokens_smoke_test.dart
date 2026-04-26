import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui_tokens/liqkit_ui_tokens.dart';

void main() {
  group('liqkit_ui_tokens smoke', () {
    test('foundation tokens compile and expose schemaVersion', () {
      expect(LiqFoundationTokens.schemaVersion, isA<int>());
    });

    test('semantic tokens compile and expose schemaVersion', () {
      expect(LiqSemanticTokens.schemaVersion, isA<int>());
    });

    test('component tokens compile and expose schemaVersion', () {
      expect(LiqComponentTokens.schemaVersion, isA<int>());
    });
  });
}
