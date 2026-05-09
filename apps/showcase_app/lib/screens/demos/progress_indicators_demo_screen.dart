import 'dart:async';

import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
class ProgressIndicatorsDemoBody extends ConsumerStatefulWidget {
  const ProgressIndicatorsDemoBody({super.key});

  @override
  ConsumerState<ProgressIndicatorsDemoBody> createState() =>
      _ProgressIndicatorsDemoBodyState();
}

class _ProgressIndicatorsDemoBodyState
    extends ConsumerState<ProgressIndicatorsDemoBody> {
  double _progressValue = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        setState(() {
          _progressValue += 0.01;
          if (_progressValue > 1.0) _progressValue = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Linear Progress',
              description:
                  'Determinate progress bar with optional label, plus an '
                  'indeterminate variant (no value).',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LiqProgressBar(
                    value: _progressValue,
                    showLabel: true,
                    label: 'Downloading...',
                  ),
                  const SizedBox(height: 16),
                  const LiqProgressBar(value: 0.3),
                  const SizedBox(height: 12),
                  const LiqProgressBar(value: 0.5),
                  const SizedBox(height: 12),
                  const LiqProgressBar(value: 0.9),
                  const SizedBox(height: 12),
                  const LiqProgressBar(value: 1.0),
                  const SizedBox(height: 16),
                  Text('Indeterminate',
                      style: context.textStyles.caption1.secondary),
                  const SizedBox(height: 8),
                  const LiqProgressBar(),
                ],
              ),
            ),
            _Section(
              title: 'Circular Progress',
              description: 'Determinate circular progress at multiple sizes.',
              child: Wrap(
                spacing: 32,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      LiqCircularProgress(
                        value: _progressValue,
                        size: 60,
                        strokeWidth: 4,
                      ),
                      const SizedBox(height: 8),
                      Text('Small', style: context.textStyles.caption1),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      LiqCircularProgress(
                        value: _progressValue,
                        size: 80,
                        strokeWidth: 6,
                      ),
                      const SizedBox(height: 8),
                      Text('Medium', style: context.textStyles.caption1),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      LiqCircularProgress(
                        value: _progressValue,
                        size: 120,
                        strokeWidth: 8,
                        showPercentage: true,
                      ),
                      const SizedBox(height: 8),
                      Text('Large with %', style: context.textStyles.caption1),
                    ],
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Activity Indicators (Spinners)',
              description:
                  'iOS-style spinning activity indicators in every '
                  '`LiqSpinnerSize` value.',
              child: Wrap(
                spacing: 32,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const LiqSpinner(size: LiqSpinnerSize.small),
                      const SizedBox(height: 8),
                      Text('Small', style: context.textStyles.caption1),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const LiqSpinner(size: LiqSpinnerSize.regular),
                      const SizedBox(height: 8),
                      Text('Regular', style: context.textStyles.caption1),
                    ],
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Custom-Colored Circular Progress',
              description:
                  'Override the track and progress colors directly.',
              child: Wrap(
                spacing: 24,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  for (final c in <Color>[
                    context.appleColors.blue,
                    context.appleColors.green,
                    context.appleColors.orange,
                    context.appleColors.red,
                    context.appleColors.purple,
                  ])
                    LiqCircularProgress(
                      value: _progressValue,
                      size: 60,
                      strokeWidth: 5,
                      progressColor: c,
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Loading Overlay',
              description:
                  'Spinner + message overlay above some content area.',
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: context.appleColors.separator),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LiqLoadingOverlay(
                    isLoading: true,
                    message: 'Processing...',
                    child: Center(
                      child: Text(
                        'Content behind overlay',
                        style: context.textStyles.body,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _Section(
              title: 'Progress Cards',
              description: 'Pre-composed cards combining title, subtitle and progress.',
              child: Column(
                children: <Widget>[
                  LiqProgressCard(
                    title: 'Upload in Progress',
                    subtitle: '45 of 100 files',
                    progress: 0.45,
                    progressColor: context.appleColors.blue,
                    leading: Icon(LiqMaterialIcons.cloudUpload,
                        color: context.appleColors.blue),
                  ),
                  const SizedBox(height: 12),
                  LiqProgressCard(
                    title: 'Processing Images',
                    subtitle: 'Almost done',
                    progress: 0.85,
                    progressColor: context.appleColors.green,
                    leading:
                        Icon(LiqIcons.image, color: context.appleColors.green),
                  ),
                  const SizedBox(height: 12),
                  LiqProgressCard(
                    title: 'Backup Running',
                    subtitle: 'Started 5 minutes ago',
                    progress: 0.25,
                    progressColor: context.appleColors.orange,
                    leading: Icon(LiqMaterialIcons.backup,
                        color: context.appleColors.orange),
                  ),
                  const SizedBox(height: 12),
                  const LiqDownloadProgress(
                    fileName: 'design-assets.zip',
                    fileSize: '125 MB',
                    progress: 0.45,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Skeleton Loaders',
              description:
                  'Placeholder shapes shown while real content is loading.',
              child: Column(
                children: <Widget>[
                  Row(
                    children: const <Widget>[
                      LiqSkeleton(
                        width: 60,
                        height: 60,
                        shape: LiqSkeletonShape.circle,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            LiqSkeleton(width: 200, height: 16),
                            SizedBox(height: 8),
                            LiqSkeleton(width: 150, height: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const LiqSkeleton(
                    width: double.infinity,
                    height: 200,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  const SizedBox(height: 24),
                  for (var i = 0; i < 3; i++) ...<Widget>[
                    const Row(
                      children: <Widget>[
                        LiqSkeleton(
                          width: 48,
                          height: 48,
                          shape: LiqSkeletonShape.circle,
                        ),
                        SizedBox(width: 12),
                        Expanded(child: LiqSkeletonText(lines: 2)),
                      ],
                    ),
                    if (i < 2) const SizedBox(height: 16),
                  ],
                ],
              ),
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
