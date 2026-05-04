import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(data: const MediaQueryData(), child: Center(child: child)),
);

bool _isOtpBox(Widget w) {
  if (w is! Container) return false;
  final dec = w.decoration;
  if (dec is! BoxDecoration) return false;
  final br = dec.borderRadius;
  if (br is! BorderRadius) return false;
  return br.topLeft.x == LiqOtpInput.boxRadius;
}

bool _isObscureDot(Widget w) {
  if (w is! Container) return false;
  final dec = w.decoration;
  if (dec is! BoxDecoration) return false;
  return dec.shape == BoxShape.circle && dec.color == LiqOtpInput.textColor;
}

bool _isDarkObscureDot(Widget w) {
  if (w is! Container) return false;
  final dec = w.decoration;
  if (dec is! BoxDecoration) return false;
  return dec.shape == BoxShape.circle && dec.color == const Color(0xFFFFFFFF);
}

Finder _otpBoxesIn(Type root) => find.descendant(
  of: find.byType(root),
  matching: find.byWidgetPredicate(_isOtpBox),
);

Finder _digitText(String d) => find.descendant(
  of: find.byWidgetPredicate(_isOtpBox),
  matching: find.text(d),
);

void main() {
  group('LiqOtpInput', () {
    testWidgets('renders the default 6 boxes', (tester) async {
      await tester.pumpWidget(_wrap(LiqOtpInput(value: '', onChanged: (_) {})));
      await tester.pumpAndSettle();
      expect(_otpBoxesIn(LiqOtpInput), findsNWidgets(6));
    });

    testWidgets('length=4 renders 4 boxes', (tester) async {
      await tester.pumpWidget(
        _wrap(LiqOtpInput(value: '', length: 4, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();
      expect(_otpBoxesIn(LiqOtpInput), findsNWidgets(4));
    });

    testWidgets('typing/pasting fires onChanged with the new value', (
      tester,
    ) async {
      String? received;
      await tester.pumpWidget(
        _wrap(LiqOtpInput(value: '', onChanged: (v) => received = v)),
      );
      await tester.pumpAndSettle();

      // Simulate paste by entering the full string into the hidden
      // EditableText.
      await tester.enterText(find.byType(EditableText), '123456');
      await tester.pumpAndSettle();

      expect(received, '123456');
      // All six digits render in their boxes (excluding the hidden
      // EditableText, which also contains the text).
      for (final d in <String>['1', '2', '3', '4', '5', '6']) {
        expect(_digitText(d), findsOneWidget);
      }
    });

    testWidgets('typing one digit fires onChanged with that digit', (
      tester,
    ) async {
      String? received;
      await tester.pumpWidget(
        _wrap(LiqOtpInput(value: '', onChanged: (v) => received = v)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), '7');
      await tester.pumpAndSettle();

      expect(received, '7');
      expect(_digitText('7'), findsOneWidget);
    });

    testWidgets('deleting the last digit fires onChanged with shorter value', (
      tester,
    ) async {
      String? received;
      await tester.pumpWidget(
        _wrap(LiqOtpInput(value: '', onChanged: (v) => received = v)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), '1234');
      await tester.pumpAndSettle();
      expect(received, '1234');

      await tester.enterText(find.byType(EditableText), '123');
      await tester.pumpAndSettle();
      expect(received, '123');
    });

    testWidgets('obscure renders dots instead of digit text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqOtpInput(value: '', length: 4, obscure: true, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), '1234');
      await tester.pumpAndSettle();

      // No digit glyph rendered inside any box.
      for (final d in <String>['1', '2', '3', '4']) {
        expect(_digitText(d), findsNothing);
      }

      // Four 12x12 circular obscure dots.
      expect(
        find.descendant(
          of: find.byType(LiqOtpInput),
          matching: find.byWidgetPredicate(_isObscureDot),
        ),
        findsNWidgets(4),
      );
    });

    testWidgets('uses dark theme colors for boxes and digits', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(
            LiqOtpInput(value: '1234', length: 4, onChanged: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final boxDecorations =
          tester
              .widgetList<Container>(_otpBoxesIn(LiqOtpInput))
              .map((container) => container.decoration)
              .whereType<BoxDecoration>();
      expect(
        boxDecorations.every(
          (decoration) => decoration.color == const Color(0xFF000000),
        ),
        isTrue,
      );

      final digit = tester.widget<Text>(_digitText('1'));
      expect(digit.style?.color, const Color(0xFFFFFFFF));
    });

    testWidgets('uses dark theme color for obscure dots', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(
            LiqOtpInput(
              value: '1234',
              length: 4,
              obscure: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(LiqOtpInput),
          matching: find.byWidgetPredicate(_isDarkObscureDot),
        ),
        findsNWidgets(4),
      );
    });

    test('throws AssertionError when length is below the minimum', () {
      expect(
        () => LiqOtpInput(value: '', length: 1, onChanged: (_) {}),
        throwsAssertionError,
      );
    });

    test('throws AssertionError when length is above the maximum', () {
      expect(
        () => LiqOtpInput(value: '', length: 13, onChanged: (_) {}),
        throwsAssertionError,
      );
    });
  });
}
