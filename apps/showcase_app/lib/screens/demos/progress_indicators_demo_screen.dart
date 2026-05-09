import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class ProgressIndicatorsDemoScreen extends ConsumerWidget {
  const ProgressIndicatorsDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const LiqScaffold(
      appBar: LiqAppBar(title: Text('Progress Indicators')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: ProgressIndicatorsDemoBody(),
      ),
    );
  }
}

/// Body-only widget rendering every progress-indicator variant section.
/// Used standalone via [ProgressIndicatorsDemoScreen] and inside the
/// combined `ActivityIndicatorsAllInOneDemoScreen`.
class ProgressIndicatorsDemoBody extends ConsumerWidget {
  const ProgressIndicatorsDemoBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        _Section(
          title: 'Linear Progress',
          description:
              'Determinate progress bar with optional label, plus an '
              'indeterminate variant (no value).',
          child: ProgressLinearExample(),
        ),
        _Section(
          title: 'Circular Progress',
          description: 'Determinate circular progress at multiple sizes.',
          child: ProgressCircularExample(),
        ),
        _Section(
          title: 'Activity Indicators (Spinners)',
          description:
              'iOS-style spinning activity indicators in every '
              '`LiqSpinnerSize` value.',
          child: ProgressActivityIndicatorsExample(),
        ),
        _Section(
          title: 'Custom-Colored Circular Progress',
          description:
              'Override the track and progress colors directly.',
          child: ProgressCustomColoredCircularExample(),
        ),
        _Section(
          title: 'Loading Overlay',
          description:
              'Spinner + message overlay above some content area.',
          child: ProgressLoadingOverlayExample(),
        ),
        _Section(
          title: 'Progress Cards',
          description:
              'Pre-composed cards combining title, subtitle and progress.',
          child: ProgressCardsExample(),
        ),
        _Section(
          title: 'Skeleton Loaders',
          description:
              'Placeholder shapes shown while real content is loading.',
          child: ProgressSkeletonLoadersExample(),
        ),
      ],
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
