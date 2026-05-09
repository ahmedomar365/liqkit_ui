import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class PageControlDemoScreen extends ConsumerStatefulWidget {
  const PageControlDemoScreen({super.key});

  @override
  ConsumerState<PageControlDemoScreen> createState() =>
      _PageControlDemoScreenState();
}

class _PageControlDemoScreenState
    extends ConsumerState<PageControlDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Page Controls')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'PageView with Dots',
              description:
                  'Swipe or tap dots to change page. Standard iOS-style dots indicator.',
              child: PageControlDotsExample(),
            ),
            _Section(
              title: 'Progress Indicator',
              description:
                  'Linear progress bar driven by current page.',
              child: PageControlProgressExample(),
            ),
            _Section(
              title: 'Numbered Indicator',
              description: 'Each page is shown as a numbered chip.',
              child: PageControlNumberedExample(),
            ),
            _Section(
              title: 'Custom Sized & Outlined',
              description: 'Animated indicator that grows for the active page.',
              child: PageControlSizedOutlinedExample(),
            ),
            _Section(
              title: 'Scrolling (Compact for Many Pages)',
              description:
                  'Use maxVisible to keep the indicator compact when there are many pages.',
              child: PageControlScrollingExample(),
            ),
            _Section(
              title: 'Custom Colors',
              description: 'Pick custom active/inactive dot colors.',
              child: PageControlCustomColorsExample(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(description!, style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
