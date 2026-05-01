import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

void main() {
  group('LiqGlassSurface', () {
    Widget host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    );

    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        host(
          const LiqGlassSurface(
            child: SizedBox(width: 100, height: 100, child: Text('hello')),
          ),
        ),
      );
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('tint=light produces a BackdropFilter in the tree', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const LiqGlassSurface(child: SizedBox(width: 80, height: 80))),
      );
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('tint=dark produces a BackdropFilter in the tree', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const LiqGlassSurface(
            tint: LiqGlassTint.dark,
            child: SizedBox(width: 80, height: 80),
          ),
        ),
      );
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('tint=opaque does NOT produce a BackdropFilter', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const LiqGlassSurface(
            tint: LiqGlassTint.opaque,
            child: SizedBox(width: 80, height: 80),
          ),
        ),
      );
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('elevation=flat produces no outer shadow', (tester) async {
      await tester.pumpWidget(
        host(
          const LiqGlassSurface(
            elevation: LiqGlassElevation.flat,
            child: SizedBox(width: 80, height: 80),
          ),
        ),
      );
      // With no shadow, the surface returns the bare ClipRRect; no
      // outer DecoratedBox is layered for the shadow.
      final ctx = tester.element(find.byType(LiqGlassSurface));
      var foundShadow = false;
      void visit(Element element) {
        final widget = element.widget;
        if (widget is DecoratedBox) {
          final decoration = widget.decoration;
          if (decoration is BoxDecoration && decoration.boxShadow != null) {
            if (decoration.boxShadow!.isNotEmpty) {
              foundShadow = true;
            }
          }
        }
        element.visitChildren(visit);
      }

      ctx.visitChildren(visit);
      expect(foundShadow, isFalse);
    });

    BoxShadow extractFirstShadow(WidgetTester tester) {
      final ctx = tester.element(find.byType(LiqGlassSurface));
      BoxShadow? shadow;
      void visit(Element element) {
        if (shadow != null) return;
        final widget = element.widget;
        if (widget is DecoratedBox) {
          final decoration = widget.decoration;
          if (decoration is BoxDecoration &&
              decoration.boxShadow != null &&
              decoration.boxShadow!.isNotEmpty) {
            shadow = decoration.boxShadow!.first;
            return;
          }
        }
        element.visitChildren(visit);
      }

      ctx.visitChildren(visit);
      expect(
        shadow,
        isNotNull,
        reason: 'expected a BoxShadow somewhere in the subtree',
      );
      return shadow!;
    }

    testWidgets('elevation=modal produces a heavier shadow than floating', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const LiqGlassSurface(child: SizedBox(width: 80, height: 80))),
      );
      final floating = extractFirstShadow(tester);

      await tester.pumpWidget(
        host(
          const LiqGlassSurface(
            elevation: LiqGlassElevation.modal,
            child: SizedBox(width: 80, height: 80),
          ),
        ),
      );
      final modal = extractFirstShadow(tester);

      expect(modal.blurRadius, greaterThan(floating.blurRadius));
      expect(modal.offset.dy, greaterThan(floating.offset.dy));
    });

    testWidgets('custom borderRadius is forwarded to the ClipRRect', (
      tester,
    ) async {
      const customRadius = BorderRadius.all(Radius.circular(28));
      await tester.pumpWidget(
        host(
          const LiqGlassSurface(
            borderRadius: customRadius,
            child: SizedBox(width: 80, height: 80),
          ),
        ),
      );
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, customRadius);
    });
  });
}
