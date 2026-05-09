/// Canonical progress-indicator variants — single source of truth for
/// the showcase app and the liqkit.com previews.
// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/progress/liq_progress_extras.dart';
import 'package:liqkit_ui/src/components/progress/liq_progress_indicator.dart';
import 'package:liqkit_ui/src/components/skeletons/liq_skeleton.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

/// Determinate progress bar with optional label, plus an indeterminate variant.
final class ProgressLinearExample extends StatefulWidget {
  const ProgressLinearExample({super.key});

  @override
  State<ProgressLinearExample> createState() => _ProgressLinearExampleState();
}

class _ProgressLinearExampleState extends State<ProgressLinearExample> {
  double _value = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        setState(() {
          _value += 0.01;
          if (_value > 1.0) _value = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LiqProgressBar(
          value: _value,
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
        Text('Indeterminate', style: context.textStyles.caption1.secondary),
        const SizedBox(height: 8),
        const LiqProgressBar(),
      ],
    );
  }
}

/// Determinate circular progress at multiple sizes.
final class ProgressCircularExample extends StatefulWidget {
  const ProgressCircularExample({super.key});

  @override
  State<ProgressCircularExample> createState() =>
      _ProgressCircularExampleState();
}

class _ProgressCircularExampleState extends State<ProgressCircularExample> {
  double _value = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        setState(() {
          _value += 0.01;
          if (_value > 1.0) _value = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 32,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            LiqCircularProgress(value: _value, size: 60, strokeWidth: 4),
            const SizedBox(height: 8),
            Text('Small', style: context.textStyles.caption1),
          ],
        ),
        Column(
          children: <Widget>[
            LiqCircularProgress(value: _value, size: 80, strokeWidth: 6),
            const SizedBox(height: 8),
            Text('Medium', style: context.textStyles.caption1),
          ],
        ),
        Column(
          children: <Widget>[
            LiqCircularProgress(
              value: _value,
              size: 120,
              strokeWidth: 8,
              showPercentage: true,
            ),
            const SizedBox(height: 8),
            Text('Large with %', style: context.textStyles.caption1),
          ],
        ),
      ],
    );
  }
}

/// iOS-style spinning activity indicators in every `LiqSpinnerSize` value.
final class ProgressActivityIndicatorsExample extends StatelessWidget {
  const ProgressActivityIndicatorsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
            const LiqSpinner(),
            const SizedBox(height: 8),
            Text('Regular', style: context.textStyles.caption1),
          ],
        ),
      ],
    );
  }
}

/// Override the track and progress colors directly.
final class ProgressCustomColoredCircularExample extends StatefulWidget {
  const ProgressCustomColoredCircularExample({super.key});

  @override
  State<ProgressCustomColoredCircularExample> createState() =>
      _ProgressCustomColoredCircularExampleState();
}

class _ProgressCustomColoredCircularExampleState
    extends State<ProgressCustomColoredCircularExample> {
  double _value = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        setState(() {
          _value += 0.01;
          if (_value > 1.0) _value = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
            value: _value,
            size: 60,
            strokeWidth: 5,
            progressColor: c,
          ),
      ],
    );
  }
}

/// Spinner + message overlay above some content area.
final class ProgressLoadingOverlayExample extends StatelessWidget {
  const ProgressLoadingOverlayExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

/// Pre-composed cards combining title, subtitle and progress.
final class ProgressCardsExample extends StatelessWidget {
  const ProgressCardsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LiqProgressCard(
          title: 'Upload in Progress',
          subtitle: '45 of 100 files',
          progress: 0.45,
          progressColor: context.appleColors.blue,
          leading: Icon(
            LiqMaterialIcons.cloudUpload,
            color: context.appleColors.blue,
          ),
        ),
        const SizedBox(height: 12),
        LiqProgressCard(
          title: 'Processing Images',
          subtitle: 'Almost done',
          progress: 0.85,
          progressColor: context.appleColors.green,
          leading: Icon(LiqIcons.image, color: context.appleColors.green),
        ),
        const SizedBox(height: 12),
        LiqProgressCard(
          title: 'Backup Running',
          subtitle: 'Started 5 minutes ago',
          progress: 0.25,
          progressColor: context.appleColors.orange,
          leading: Icon(
            LiqMaterialIcons.backup,
            color: context.appleColors.orange,
          ),
        ),
        const SizedBox(height: 12),
        const LiqDownloadProgress(
          fileName: 'design-assets.zip',
          fileSize: '125 MB',
          progress: 0.45,
        ),
      ],
    );
  }
}

/// Placeholder shapes shown while real content is loading.
final class ProgressSkeletonLoadersExample extends StatelessWidget {
  const ProgressSkeletonLoadersExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
