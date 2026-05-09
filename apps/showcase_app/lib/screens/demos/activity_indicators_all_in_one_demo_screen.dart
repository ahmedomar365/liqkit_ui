import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import 'activity_view_demo_screen.dart';
import 'progress_indicators_demo_screen.dart';

/// Combined "Activity Indicators" catalog page — every variant from
/// `ActivityViewDemoBody` and `ProgressIndicatorsDemoBody` rendered in
/// one scroll under group headers.
class ActivityIndicatorsAllInOneDemoScreen extends ConsumerWidget {
  const ActivityIndicatorsAllInOneDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Activity Indicators')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _GroupHeader(
              title: 'Activity Views',
              description:
                  'Share sheets and activity-style overlays — for picking '
                  'a destination app or surface to share content with.',
            ),
            const ActivityViewDemoBody(),
            _GroupHeader(
              title: 'Progress Indicators',
              description:
                  'Linear progress bars, circular progress rings, '
                  'spinners, loading overlays, progress cards, and '
                  'skeleton loaders.',
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ProgressIndicatorsDemoBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title1.copyWith(
              fontWeight: LiqAppleTypography.bold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              description!,
              style: context.textStyles.subheadline.secondary,
            ),
          ],
        ],
      ),
    );
  }
}
