import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('LiqAvatar', () {
    testWidgets('renders initials when image is null', (tester) async {
      await tester.pumpWidget(wrap(const LiqAvatar(initials: 'JD')));
      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('initials clamp to first 2 characters from a full name', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const LiqAvatar(initials: 'John Doe')));
      expect(find.text('JD'), findsOneWidget);
      expect(find.text('John Doe'), findsNothing);
    });

    test('background hash is deterministic for the same initials', () {
      final a = LiqAvatar.paletteColorFor('JD');
      final b = LiqAvatar.paletteColorFor('JD');
      expect(a, equals(b));
      // Sanity: pulled from the published palette.
      expect(LiqAvatar.palette.contains(a), isTrue);
    });

    testWidgets('measures the canonical diameter for each size', (
      tester,
    ) async {
      Future<Size> measure(LiqAvatarSize size) async {
        await tester.pumpWidget(
          wrap(
            Align(
              alignment: Alignment.topLeft,
              child: LiqAvatar(initials: 'AA', size: size),
            ),
          ),
        );
        return tester.getSize(find.byType(LiqAvatar));
      }

      expect(
        await measure(LiqAvatarSize.small),
        const Size(LiqAvatar.diameterSmall, LiqAvatar.diameterSmall),
      );
      expect(
        await measure(LiqAvatarSize.medium),
        const Size(LiqAvatar.diameterMedium, LiqAvatar.diameterMedium),
      );
      expect(
        await measure(LiqAvatarSize.large),
        const Size(LiqAvatar.diameterLarge, LiqAvatar.diameterLarge),
      );
    });
  });

  group('LiqAvatarGroup', () {
    testWidgets('with 5 avatars and maxVisible=3 renders 3 avatars + +2 pill', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Align(
            alignment: Alignment.topLeft,
            child: LiqAvatarGroup(
              avatars: <LiqAvatar>[
                LiqAvatar(initials: 'AA'),
                LiqAvatar(initials: 'BB'),
                LiqAvatar(initials: 'CC'),
                LiqAvatar(initials: 'DD'),
                LiqAvatar(initials: 'EE'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(LiqAvatar), findsNWidgets(3));
      expect(find.text('AA'), findsOneWidget);
      expect(find.text('BB'), findsOneWidget);
      expect(find.text('CC'), findsOneWidget);
      expect(find.text('DD'), findsNothing);
      expect(find.text('EE'), findsNothing);
      expect(find.text('+2'), findsOneWidget);
    });
  });
}
