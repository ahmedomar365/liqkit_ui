import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Center(child: child),
    ),
  );
}

void main() {
  testWidgets('LiqMaterialChip renders with default style', (tester) async {
    await tester.pumpWidget(_wrap(const LiqMaterialChip()));
    expect(find.byType(LiqMaterialChip), findsOneWidget);
  });

  testWidgets('LiqMaterialChip renders dark variant', (tester) async {
    await tester.pumpWidget(_wrap(
      const LiqMaterialChip(
        style: LiqMaterialStyle.thick,
        brightness: LiqMaterialBrightness.dark,
      ),
    ));
    expect(find.byType(LiqMaterialChip), findsOneWidget);
  });

  testWidgets('LiqMaterialChipCell renders caption', (tester) async {
    await tester.pumpWidget(_wrap(
      const LiqMaterialChipCell(
        caption: 'Regular',
        chip: LiqMaterialChip(),
      ),
    ));
    expect(find.text('Regular'), findsOneWidget);
  });
}
