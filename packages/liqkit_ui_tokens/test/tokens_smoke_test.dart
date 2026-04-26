import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui_tokens/liqkit_ui_tokens.dart';

void main() {
  group('liqkit_ui_tokens canonical', () {
    test('every Figma color path is present in LiqCanonicalColors.all', () {
      // 40 unique colors captured from liqkit's variable-defs.
      expect(LiqCanonicalColors.all, hasLength(40));
    });

    test('LiqCanonicalColors fields resolve per mode', () {
      // Sanity-check a known value: Accents/Blue default = #0091FF.
      expect(
        LiqCanonicalColors.accentsBlue
            .valueIn(LiqColorMode.default_)
            .toARGB32(),
        0xFF0091FF,
      );
      expect(
        LiqCanonicalColors.accentsBlue
            .valueIn(LiqColorMode.increasedContrast)
            .toARGB32(),
        0xFF5CB8FF,
      );
    });

    test('LiqCanonicalTypography is captured (at least one entry)', () {
      expect(LiqCanonicalTypography.all, isNotEmpty);
    });

    test('placeholder schemaVersion stubs are still importable', () {
      expect(LiqFoundationTokens.schemaVersion, isA<int>());
      expect(LiqSemanticTokens.schemaVersion, isA<int>());
      expect(LiqComponentTokens.schemaVersion, isA<int>());
    });
  });
}
