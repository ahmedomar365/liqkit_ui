import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/progress/liq_progress_indicator.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Tonal style for [LiqSystemAlert].
enum LiqSystemAlertStyle { normal, success, warning, error }

/// Action button rendered alongside the alert message.
@immutable
class LiqSystemAlertAction {
  /// Creates an alert action.
  const LiqSystemAlertAction({required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;
}

/// Top-of-screen system alert banner — leading icon + title + message
/// + optional actions + optional dismiss affordance. Styled like
/// iOS' "Connecting…" / "Update Available" system banners.
final class LiqSystemAlert extends StatelessWidget with Diagnosticable {
  /// Creates a system alert.
  const LiqSystemAlert({
    required this.title,
    this.message,
    this.icon,
    this.style = LiqSystemAlertStyle.normal,
    this.actions = const <LiqSystemAlertAction>[],
    this.dismissible = true,
    this.onDismiss,
    super.key,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final LiqSystemAlertStyle style;
  final List<LiqSystemAlertAction> actions;
  final bool dismissible;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final accent = switch (style) {
      LiqSystemAlertStyle.success => LiqAppleColors.systemGreen,
      LiqSystemAlertStyle.warning => LiqAppleColors.systemOrange,
      LiqSystemAlertStyle.error => LiqAppleColors.systemRed,
      LiqSystemAlertStyle.normal => LiqAppleColors.systemBlue,
    };
    final titleStyle = LiqAppleTypography.body(brightness).copyWith(
      fontWeight: LiqAppleTypography.semibold,
    );
    final messageStyle = LiqAppleTypography.subheadline(brightness).copyWith(
      color: isDark
          ? const Color(0x99EBEBF5)
          : const Color(0x993C3C43),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: LiqGlassSurface(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 18, color: accent),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(title, style: titleStyle),
                  if (message != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(message!, style: messageStyle),
                  ],
                  if (actions.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: <Widget>[
                        for (final action in actions)
                          GestureDetector(
                            onTap: action.onPressed,
                            child: Text(
                              action.title,
                              style: titleStyle.copyWith(color: accent),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (dismissible)
              GestureDetector(
                onTap: onDismiss,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CustomPaint(
                      painter: _CrossPainter(
                        color: messageStyle.color ?? accent,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(EnumProperty<LiqSystemAlertStyle>('style', style));
  }
}

class _CrossPainter extends CustomPainter {
  const _CrossPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final inset = size.width * 0.28;
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
  bool shouldRepaint(covariant _CrossPainter old) => color != old.color;
}

/// Full-screen modal overlay with a centered glass card containing a
/// LiqSpinner + optional message. Useful for "Loading…" blockers.
final class LiqSystemOverlay extends StatelessWidget with Diagnosticable {
  /// Creates a system overlay.
  const LiqSystemOverlay({
    required this.isVisible,
    this.message,
    this.dismissible = false,
    this.onDismiss,
    super.key,
  });

  final bool isVisible;
  final String? message;
  final bool dismissible;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    return GestureDetector(
      onTap: dismissible ? onDismiss : null,
      child: Container(
        color: const Color(0x66000000),
        alignment: Alignment.center,
        child: LiqGlassSurface(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const LiqSpinner(),
              if (message != null) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  message!,
                  style: LiqAppleTypography.subheadline(brightness),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('isVisible',
        value: isVisible, ifTrue: 'visible'));
  }
}

/// Single tile in a [LiqControlCenter]. Tap toggles `isActive`,
/// rendering a tinted background using `activeColor` when on.
final class LiqControlCenterTile extends StatelessWidget with Diagnosticable {
  /// Creates a control-center tile.
  const LiqControlCenterTile({
    required this.icon,
    required this.label,
    required this.isActive,
    this.activeColor,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final accent = activeColor ?? LiqAppleColors.systemBlue;
    final inactiveBg = isDark
        ? const Color(0x33EBEBF5)
        : const Color(0x1A3C3C43);
    final fg = isActive ? const Color(0xFFFFFFFF) : accent;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isActive ? accent : inactiveBg,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: fg, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(FlagProperty('isActive', value: isActive, ifTrue: 'active'));
  }
}

/// Grid of [LiqControlCenterTile] sections, separated by 12pt gaps.
/// Mirrors iOS Control Center's layout where a section is a Wrap of
/// 4-up tiles.
final class LiqControlCenter extends StatelessWidget with Diagnosticable {
  /// Creates a control center.
  const LiqControlCenter({
    required this.sections,
    super.key,
  });

  final List<List<LiqControlCenterTile>> sections;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var s = 0; s < sections.length; s++) ...<Widget>[
          if (s > 0) const SizedBox(height: 12),
          LiqGlassSurface(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: sections[s],
            ),
          ),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('sections', sections.length));
  }
}

/// One quick action button for [LiqQuickActionsRow].
@immutable
class LiqQuickAction {
  /// Creates a quick action.
  const LiqQuickAction({
    required this.icon,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
}

/// Row (or column) of small circular icon buttons. Mirrors the
/// "Quick Actions" tray on the iOS lock screen.
final class LiqQuickActionsRow extends StatelessWidget with Diagnosticable {
  /// Creates a quick actions row.
  const LiqQuickActionsRow({
    required this.actions,
    this.direction = Axis.horizontal,
    this.spacing = 16,
    super.key,
  });

  final List<LiqQuickAction> actions;
  final Axis direction;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      for (var i = 0; i < actions.length; i++) ...<Widget>[
        if (i > 0)
          SizedBox(
            width: direction == Axis.horizontal ? spacing : 0,
            height: direction == Axis.vertical ? spacing : 0,
          ),
        _QuickActionTile(action: actions[i]),
      ],
    ];
    return direction == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: children)
        : Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('actionCount', actions.length));
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final LiqQuickAction action;

  @override
  Widget build(BuildContext context) {
    final color = action.color ?? LiqAppleColors.systemBlue;
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(action.icon, color: color, size: 24),
      ),
    );
  }
}
