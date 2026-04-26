@Tags(<String>['golden'])
library;

import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/foundation.dart';
import 'package:liqkit_ui/theme.dart';

void main() {
  if (!Platform.isMacOS && !Platform.isLinux) {
    return;
  }

  group('LiqGlassSurface goldens', () {
    testWidgets('light', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light.copyWith(quality: LiqQuality.minimal),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 240,
              height: 120,
              child: LiqGlassSurface(
                material: LiqMaterial.solid,
                child: Center(child: Text('liqkit_ui')),
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(LiqGlassSurface),
        matchesGoldenFile('${_platformDir()}/liq_glass_surface_light.png'),
      );
    });

    testWidgets('dark', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark.copyWith(quality: LiqQuality.minimal),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 240,
              height: 120,
              child: LiqGlassSurface(
                material: LiqMaterial.solid,
                child: Center(child: Text('liqkit_ui')),
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(LiqGlassSurface),
        matchesGoldenFile('${_platformDir()}/liq_glass_surface_dark.png'),
      );
    });
  });
}

String _platformDir() {
  if (Platform.isMacOS) return '../../test_goldens/macos';
  if (Platform.isLinux) return '../../test_goldens/linux';
  return '../../test_goldens/macos';
}
