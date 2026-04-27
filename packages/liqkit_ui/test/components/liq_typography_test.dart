import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

void main() {
  test('liqResolveTextStyle: body @ large', () {
    final s = liqResolveTextStyle(role: LiqTypeRole.body);
    expect(s.fontSize, 17);
    expect(s.fontWeight, FontWeight.w400);
    expect(s.letterSpacing, -0.43);
  });

  test('liqResolveTextStyle: body @ ax2 scales 1.65x', () {
    final s = liqResolveTextStyle(
      role: LiqTypeRole.body,
      scale: LiqDynamicTypeScale.ax2,
    );
    expect(s.fontSize, closeTo(17 * 1.65, 0.001));
    expect(s.letterSpacing, closeTo(-0.43 * 1.65, 0.001));
  });

  test('liqResolveTextStyle: largeTitle uses display 700', () {
    final s = liqResolveTextStyle(role: LiqTypeRole.largeTitle);
    expect(s.fontSize, 34);
    expect(s.fontWeight, FontWeight.w700);
    expect(s.fontFamily, 'SF Pro Display');
  });

  testWidgets('LiqTypeColumn renders header and one sample',
      (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(),
          child: SizedBox(
            width: 200,
            child: LiqTypeColumn(
              header: 'Large',
              scale: LiqDynamicTypeScale.large,
              roles: <LiqTypeRole>[LiqTypeRole.body],
              sampleText: 'Hello',
            ),
          ),
        ),
      ),
    );
    expect(find.text('Large'), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
  });
}
