import 'package:docs_snippets/src/height_post.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The reporter wraps its child in `Padding(symmetric vertical: 24)` so the
  // reported height includes 48px of breathing room around the snippet.
  const verticalPadding = 48;

  testWidgets('LiqHeightReporter publishes the laid-out height once', (
    tester,
  ) async {
    final reports = <int>[];
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: LiqHeightReporter(
          publish: reports.add,
          child: const SizedBox(height: 120, width: 200),
        ),
      ),
    );
    await tester.pump();
    expect(reports, equals(<int>[120 + verticalPadding]));
  });

  testWidgets('LiqHeightReporter republishes on size change', (tester) async {
    final reports = <int>[];
    final controller = ValueNotifier<double>(80);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: LiqHeightReporter(
          publish: reports.add,
          child: ValueListenableBuilder<double>(
            valueListenable: controller,
            builder: (_, h, _) => SizedBox(height: h, width: 200),
          ),
        ),
      ),
    );
    await tester.pump();
    controller.value = 200;
    await tester.pump();
    expect(
      reports,
      equals(<int>[80 + verticalPadding, 200 + verticalPadding]),
    );
  });
}
