import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: Center(child: child),
);

void main() {
  group('LiqLabel', () {
    testWidgets('renders the supplied text', (tester) async {
      await tester.pumpWidget(_wrap(const LiqLabel(text: 'Email')));
      expect(find.textContaining('Email'), findsOneWidget);
    });

    testWidgets('required appends a red asterisk', (tester) async {
      await tester.pumpWidget(
        _wrap(const LiqLabel(text: 'Email', required: true)),
      );
      // Text.rich produces a single Text whose plain text concatenates
      // every span; the asterisk shows up as " *" suffix.
      expect(find.textContaining('Email *'), findsOneWidget);

      final text = tester.widget<Text>(find.textContaining('Email *'));
      final span = text.textSpan! as TextSpan;
      // Find the required asterisk span and verify its color.
      TextSpan? asterisk;
      span.visitChildren((InlineSpan s) {
        if (s is TextSpan && s.text == LiqLabel.requiredSuffix) {
          asterisk = s;
        }
        return true;
      });
      expect(asterisk, isNotNull);
      expect(asterisk!.style?.color, LiqLabel.requiredColor);
    });

    testWidgets('optional appends muted "(optional)" suffix', (tester) async {
      await tester.pumpWidget(
        _wrap(const LiqLabel(text: 'Phone', optional: true)),
      );

      expect(find.textContaining('Phone (optional)'), findsOneWidget);

      final text = tester.widget<Text>(find.textContaining('Phone (optional)'));
      final span = text.textSpan! as TextSpan;
      TextSpan? optional;
      span.visitChildren((InlineSpan s) {
        if (s is TextSpan && s.text == LiqLabel.optionalSuffix) {
          optional = s;
        }
        return true;
      });
      expect(optional, isNotNull);
      expect(optional!.style?.color, LiqLabel.optionalSuffixStyle.color);
      expect(
        optional!.style?.fontWeight,
        LiqLabel.optionalSuffixStyle.fontWeight,
      );
    });

    test('asserts required and optional are mutually exclusive', () {
      expect(
        () => LiqLabel(text: 'X', required: true, optional: true),
        throwsAssertionError,
      );
    });
  });

  group('LiqFormField', () {
    testWidgets('composes label + child + helperText', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 320,
            child: LiqFormField(
              label: 'Email',
              helperText: 'We never share your email.',
              child: SizedBox(
                height: 44,
                child: ColoredBox(color: Color(0xFFEEEEEE)),
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('Email'), findsOneWidget);
      expect(find.text('We never share your email.'), findsOneWidget);
    });

    testWidgets('errorText hides helperText and renders in red', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 320,
            child: LiqFormField(
              label: 'Email',
              helperText: 'We never share your email.',
              errorText: 'Invalid email.',
              child: SizedBox(
                height: 44,
                child: ColoredBox(color: Color(0xFFEEEEEE)),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Invalid email.'), findsOneWidget);
      expect(find.text('We never share your email.'), findsNothing);

      final errorText = tester.widget<Text>(find.text('Invalid email.'));
      expect(errorText.style?.color, LiqFormField.errorTextStyle.color);
    });
  });
}
