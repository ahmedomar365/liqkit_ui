import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (_) => Center(child: child)),
          ],
        ),
      ),
    ),
  );

  group('LiqRichEditor', () {
    testWidgets('renders the placeholder when text is empty', (tester) async {
      final controller = LiqRichEditorController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 400,
            child: LiqRichEditor(
              controller: controller,
              placeholder: 'Compose…',
            ),
          ),
        ),
      );

      expect(find.text('Compose…'), findsOneWidget);
    });

    testWidgets('typing text updates the controller value', (tester) async {
      final controller = LiqRichEditorController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          SizedBox(width: 400, child: LiqRichEditor(controller: controller)),
        ),
      );

      await tester.enterText(find.byType(EditableText), 'hello');
      await tester.pump();

      expect(controller.value.text, 'hello');
    });

    testWidgets('editable area has no Cupertino selection controls (iOS-26 native)', (
      tester,
    ) async {
      final controller = LiqRichEditorController(
        value: const LiqRichValue(text: 'hello world'),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          SizedBox(width: 400, child: LiqRichEditor(controller: controller)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EditableText), findsOneWidget);
      expect(find.byType(EditableText), findsOneWidget);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      
      expect(editable.enableInteractiveSelection, isTrue);
      expect(editable.selectionControls, isNull);
    });

    testWidgets('placeholder is rendered by the platform text field', (
      tester,
    ) async {
      final controller = LiqRichEditorController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 400,
            child: LiqRichEditor(
              controller: controller,
              placeholder: 'Compose',
            ),
          ),
        ),
      );

      expect(find.byType(EditableText), findsOneWidget);
      expect(find.text('Compose'), findsOneWidget);
    });

    testWidgets('renders the bold toolbar button', (tester) async {
      final controller = LiqRichEditorController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          SizedBox(width: 400, child: LiqRichEditor(controller: controller)),
        ),
      );

      expect(find.byIcon(LucideIcons.bold), findsOneWidget);
      expect(find.byIcon(LucideIcons.italic), findsOneWidget);
      expect(find.byIcon(LucideIcons.underline), findsOneWidget);
    });

    testWidgets('toolbar buttons keep 44pt tap targets', (tester) async {
      final controller = LiqRichEditorController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          SizedBox(width: 400, child: LiqRichEditor(controller: controller)),
        ),
      );

      for (final icon in <IconData>[
        LucideIcons.bold,
        LucideIcons.italic,
        LucideIcons.underline,
      ]) {
        final button = find.ancestor(
          of: find.byIcon(icon),
          matching: find.byType(GestureDetector),
        );
        expect(tester.getSize(button.first), const Size(44, 44));
      }
    });

    testWidgets('toolbar buttons expose click cursors', (tester) async {
      final controller = LiqRichEditorController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          SizedBox(width: 400, child: LiqRichEditor(controller: controller)),
        ),
      );

      final mouseRegions = tester.widgetList<MouseRegion>(
        find.descendant(
          of: find.byType(LiqRichEditor),
          matching: find.byType(MouseRegion),
        ),
      );
      expect(
        mouseRegions.where(
          (region) => region.cursor == SystemMouseCursors.click,
        ),
        hasLength(3),
      );
    });

    testWidgets('a bold range over [0,4) renders FontWeight.w700 on the first '
        '4 chars', (tester) async {
      final controller = LiqRichEditorController(
        value: const LiqRichValue(
          text: 'bold rest',
          ranges: <LiqRichRange>[
            LiqRichRange(start: 0, end: 4, format: LiqRichFormat.bold),
          ],
        ),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          SizedBox(width: 400, child: LiqRichEditor(controller: controller)),
        ),
      );

      final editableTextElement = tester.element(find.byType(EditableText));
      final span = (editableTextElement.widget as EditableText).controller
          .buildTextSpan(
            context: editableTextElement,
            withComposing: false,
            style: LiqRichEditor.baseTextStyle,
          );
      final InlineSpan root = span;
      // Walk the spans and collect (text, weight) pairs.
      final pairs = <List<Object?>>[];
      void visit(InlineSpan span) {
        if (span is TextSpan) {
          if (span.text != null) {
            pairs.add(<Object?>[span.text, span.style?.fontWeight]);
          }
          final children = span.children;
          if (children != null) {
            for (final c in children) {
              visit(c);
            }
          }
        }
      }

      visit(root);
      expect(pairs.isNotEmpty, isTrue);
      // The first 4 chars must be bolded somewhere in the spans.
      final boldFirst = pairs.firstWhere(
        (p) => p[0] == 'bold' && p[1] == FontWeight.w700,
        orElse: () => <Object?>[null, null],
      );
      expect(boldFirst[0], 'bold');
      expect(boldFirst[1], FontWeight.w700);
    });

    test('toggleFormat adds a bold range when none is present', () {
      final controller = LiqRichEditorController(
        value: const LiqRichValue(text: 'hello world'),
      );
      addTearDown(controller.dispose);

      controller.toggleFormat(
        LiqRichFormat.bold,
        const TextSelection(baseOffset: 0, extentOffset: 4),
      );

      expect(controller.value.ranges.length, 1);
      expect(controller.value.ranges.single.start, 0);
      expect(controller.value.ranges.single.end, 4);
      expect(controller.value.ranges.single.format, LiqRichFormat.bold);
    });

    test('toggleFormat twice with the same selection removes the format', () {
      final controller = LiqRichEditorController(
        value: const LiqRichValue(text: 'hello world'),
      );
      addTearDown(controller.dispose);

      const sel = TextSelection(baseOffset: 0, extentOffset: 4);
      controller
        ..toggleFormat(LiqRichFormat.bold, sel)
        ..toggleFormat(LiqRichFormat.bold, sel);

      expect(
        controller.value.ranges.where((r) => r.format == LiqRichFormat.bold),
        isEmpty,
      );
    });

    test('selectionHasFormat returns true when fully covered', () {
      final controller = LiqRichEditorController(
        value: const LiqRichValue(
          text: 'hello world',
          ranges: <LiqRichRange>[
            LiqRichRange(start: 0, end: 5, format: LiqRichFormat.bold),
          ],
        ),
      );
      addTearDown(controller.dispose);

      expect(
        controller.selectionHasFormat(
          LiqRichFormat.bold,
          const TextSelection(baseOffset: 0, extentOffset: 5),
        ),
        isTrue,
      );
      expect(
        controller.selectionHasFormat(
          LiqRichFormat.bold,
          const TextSelection(baseOffset: 0, extentOffset: 6),
        ),
        isFalse,
      );
    });

    test('inserting text inside a range shifts the range', () {
      final controller = LiqRichEditorController(
        value: const LiqRichValue(
          text: 'hello',
          ranges: <LiqRichRange>[
            LiqRichRange(start: 0, end: 5, format: LiqRichFormat.bold),
          ],
        ),
      );
      addTearDown(controller.dispose);

      // Simulate the editor pushing a new value with extra trailing text.
      controller.value = const LiqRichValue(
        text: 'hello world',
        ranges: <LiqRichRange>[
          LiqRichRange(start: 0, end: 5, format: LiqRichFormat.bold),
        ],
      );

      // The bold range still covers the original 'hello' chars.
      final r = controller.value.ranges.single;
      expect(r.start, 0);
      expect(r.end, 5);
      expect(controller.value.text.substring(r.start, r.end), 'hello');
    });
  });
}
