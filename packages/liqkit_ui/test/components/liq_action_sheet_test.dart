import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/src/components/action_sheets/liq_action_sheet.dart';
import 'package:liqkit_ui/src/components/alerts/liq_alert.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/theme/liq_theme.dart';
import 'package:liqkit_ui/src/theme/liq_theme_data.dart';

Widget _wrap(
  Widget child, {
  MediaQueryData media = const MediaQueryData(),
  LiqThemeData theme = LiqThemeData.light,
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: LiqTheme(
      data: theme,
      child: MediaQuery(data: media, child: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('LiqActionSheet renders title, actions, and cancel', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const LiqActionSheet(
          title: 'Sort by',
          actions: <LiqAlertAction>[
            LiqAlertAction(label: 'Date'),
            LiqAlertAction(label: 'Name'),
            LiqAlertAction(label: 'Size'),
          ],
          cancelAction: LiqAlertAction(label: 'Cancel'),
        ),
      ),
    );
    expect(find.text('Sort by'), findsOneWidget);
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('LiqActionSheet without header renders only actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const LiqActionSheet(
          actions: <LiqAlertAction>[
            LiqAlertAction(
              label: 'Delete',
              style: LiqAlertActionStyle.destructive,
            ),
          ],
        ),
      ),
    );
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('action row scales while pressed', (tester) async {
    await tester.pumpWidget(
      _wrap(
        LiqActionSheet(
          title: 'Share',
          actions: <LiqAlertAction>[
            LiqAlertAction(label: 'Copy Link', onPressed: () {}),
          ],
        ),
      ),
    );

    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Copy Link')),
    );
    await tester.pump();

    expect(
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
      0.985,
    );

    await gesture.up();
    await tester.pump();
    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
  });

  testWidgets('action rows honor reduced motion', (tester) async {
    await tester.pumpWidget(
      _wrap(
        LiqActionSheet(
          actions: <LiqAlertAction>[
            LiqAlertAction(label: 'Copy Link', onPressed: () {}),
          ],
        ),
        media: const MediaQueryData(disableAnimations: true),
      ),
    );

    expect(
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).duration,
      Duration.zero,
    );
    expect(
      tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).duration,
      Duration.zero,
    );
  });

  testWidgets('action sheet resolves dark glass and label colors', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const LiqActionSheet(
          title: 'Share',
          description: 'Choose a destination.',
          actions: <LiqAlertAction>[LiqAlertAction(label: 'Copy Link')],
          cancelAction: LiqAlertAction(label: 'Cancel'),
        ),
        theme: LiqThemeData.dark,
      ),
    );

    expect(find.byType(LiqGlassSurface), findsNWidgets(2));
    expect(
      tester.widget<Text>(find.text('Share')).style?.color,
      const Color(0xFFFFFFFF),
    );
    expect(
      tester.widget<Text>(find.text('Copy Link')).style?.color,
      const Color(0xFFFFFFFF),
    );
    expect(
      tester.widget<Text>(find.text('Cancel')).style?.color,
      const Color(0xFF0088FF),
    );
  });
}
