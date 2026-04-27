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
  testWidgets('LiqContextMenuPreview renders default placeholder',
      (tester) async {
    await tester.pumpWidget(
      _wrap(const LiqContextMenuPreview(size: Size(200, 200))),
    );
    expect(find.text('Content area'), findsOneWidget);
  });

  testWidgets('LiqContextMenu composes preview + menu', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqContextMenu(
          preview: LiqContextMenuPreview(size: Size(180, 180)),
          menu: LiqMenu(
            children: <Widget>[LiqMenuItem(label: 'Action')],
          ),
        ),
      ),
    );
    expect(find.text('Content area'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
  });

  testWidgets('LiqMenuItem renders subtitle when provided', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqMenu(
          children: <Widget>[
            LiqMenuItem(
              label: 'Schedule Send',
              subtitle: 'Tomorrow at 9 AM',
            ),
          ],
        ),
      ),
    );
    expect(find.text('Schedule Send'), findsOneWidget);
    expect(find.text('Tomorrow at 9 AM'), findsOneWidget);
  });
}
