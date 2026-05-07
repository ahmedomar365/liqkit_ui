import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/cards/liq_card.dart';
import 'package:liqkit_ui/src/components/progress/liq_progress_indicator.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 determinate circular progress indicator.
///
/// Renders a ring with a progress arc. Optionally displays the
/// percentage label centered.
final class LiqCircularProgress extends StatelessWidget with Diagnosticable {
  /// Creates a circular progress indicator.
  const LiqCircularProgress({
    required this.value,
    this.size = 60,
    this.strokeWidth = 6,
    this.progressColor,
    this.backgroundColor,
    this.showPercentage = false,
    super.key,
  })  : assert(value >= 0 && value <= 1, 'value must be in [0, 1]'),
        assert(size > 0, 'size must be > 0'),
        assert(strokeWidth > 0, 'strokeWidth must be > 0');

  final double value;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final fillColor = progressColor ?? LiqAppleColors.systemBlue;
    final trackColor = backgroundColor ??
        (isDark
            ? const Color(0x33EBEBF5)
            : const Color(0x1A3C3C43));
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: Size.square(size),
            painter: _LiqCircularProgressPainter(
              value: value,
              progressColor: fillColor,
              trackColor: trackColor,
              strokeWidth: strokeWidth,
            ),
          ),
          if (showPercentage)
            Text(
              '${(value * 100).round()}%',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                fontWeight: LiqAppleTypography.semibold,
                fontSize: size * 0.22,
                color: isDark
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF000000),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value))
      ..add(DoubleProperty('size', size))
      ..add(DoubleProperty('strokeWidth', strokeWidth));
  }
}

class _LiqCircularProgressPainter extends CustomPainter {
  const _LiqCircularProgressPainter({
    required this.value,
    required this.progressColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double value;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final fillPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);
    if (value > 0) {
      final sweep = 2 * math.pi * value;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweep,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LiqCircularProgressPainter old) {
    return value != old.value ||
        progressColor != old.progressColor ||
        trackColor != old.trackColor ||
        strokeWidth != old.strokeWidth;
  }
}

/// Card with a leading widget, title/subtitle, and an integrated
/// [LiqProgressBar] underneath.
final class LiqProgressCard extends StatelessWidget with Diagnosticable {
  /// Creates a progress card.
  const LiqProgressCard({
    required this.title,
    required this.progress,
    this.subtitle,
    this.leading,
    this.trailing,
    this.progressColor,
    super.key,
  });

  final String title;
  final String? subtitle;
  final double progress;
  final Widget? leading;
  final Widget? trailing;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final titleStyle = LiqAppleTypography.headline(brightness).copyWith(
      fontWeight: LiqAppleTypography.semibold,
    );
    final subtitleStyle =
        LiqAppleTypography.subheadline(brightness).copyWith(
      color: isDark
          ? const Color(0x99EBEBF5)
          : const Color(0x993C3C43),
    );
    return LiqCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (leading != null) ...<Widget>[
                leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(title, style: titleStyle),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: subtitleStyle),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          LiqProgressBar(value: progress, progressColor: progressColor),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(DoubleProperty('progress', progress));
  }
}

/// Overlay that grays out [child] and shows a centered [LiqSpinner] +
/// optional [message] when [isLoading] is true.
final class LiqLoadingOverlay extends StatelessWidget with Diagnosticable {
  /// Creates a loading overlay.
  const LiqLoadingOverlay({
    required this.child,
    required this.isLoading,
    this.message,
    this.dimColor,
    super.key,
  });

  final Widget child;
  final bool isLoading;
  final String? message;
  final Color? dimColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final dim = dimColor ??
        (isDark ? const Color(0x99000000) : const Color(0x66000000));
    final captionStyle = LiqAppleTypography.body(brightness).copyWith(
      color: const Color(0xFFFFFFFF),
    );
    return Stack(
      children: <Widget>[
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: dim,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const LiqSpinner(),
                    if (message != null) ...<Widget>[
                      const SizedBox(height: 12),
                      Text(message!, style: captionStyle),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('isLoading', value: isLoading, ifTrue: 'loading'))
      ..add(StringProperty('message', message));
  }
}

/// Card representing an in-progress download with cancel affordance.
final class LiqDownloadProgress extends StatelessWidget with Diagnosticable {
  /// Creates a download progress card.
  const LiqDownloadProgress({
    required this.fileName,
    required this.progress,
    this.fileSize,
    this.onCancel,
    super.key,
  });

  final String fileName;
  final String? fileSize;
  final double progress;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final titleStyle = LiqAppleTypography.body(brightness).copyWith(
      fontWeight: LiqAppleTypography.semibold,
    );
    final captionStyle = LiqAppleTypography.caption1(brightness).copyWith(
      color: isDark
          ? const Color(0x99EBEBF5)
          : const Color(0x993C3C43),
    );
    return LiqCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(fileName, style: titleStyle),
                    const SizedBox(height: 2),
                    Text(
                      <String>[
                        if (fileSize != null) fileSize!,
                        '${(progress * 100).round()}%',
                      ].join(' · '),
                      style: captionStyle,
                    ),
                  ],
                ),
              ),
              if (onCancel != null)
                GestureDetector(
                  onTap: onCancel,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CustomPaint(
                        painter: _LiqCloseGlyphPainter(
                          color: Color(0xFF8E8E93),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          LiqProgressBar(value: progress),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('fileName', fileName))
      ..add(DoubleProperty('progress', progress));
  }
}

class _LiqCloseGlyphPainter extends CustomPainter {
  const _LiqCloseGlyphPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    final inset = size.width * 0.25;
    canvas.drawLine(
      Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LiqCloseGlyphPainter old) {
    return color != old.color || strokeWidth != old.strokeWidth;
  }
}
