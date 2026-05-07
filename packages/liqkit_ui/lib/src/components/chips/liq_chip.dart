import 'package:flutter/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 selectable / dismissible tag pill.
///
/// `LiqChip` is an interactive pill used for tag inputs, filter pills,
/// and multi-select facets. It is distinct from `LiqBadge` (read-only
/// counter / status) — chips can be tapped, can render in a selected
/// state, and can carry an inline delete affordance.
///
/// Sourced from the iOS 26 chip spec:
///   - default: 28pt min height, 6pt vertical / 12pt horizontal padding,
///     fully-pill-rounded (radius 14), background #E5E5EA, label
///     #1C1C1E, SF semibold 14pt
///   - selected: background #007AFF, label #FFFFFF
///   - disabled (both `onPressed` and `onDeleted` null): 40% opacity
///   - leading icon: 14×14 matching label color, 4pt right padding to
///     label
///   - delete affordance: 14×14 round button with `LucideIcons.x` 10pt,
///     6pt left padding from label, taps fire `onDeleted` (NOT
///     `onPressed`)
/// The visible pill remains compact; interactive chips expand their
/// overall hit target to 44pt tall.
final class LiqChip extends StatelessWidget {
  /// Creates a chip.
  const LiqChip({
    required this.label,
    this.selected = false,
    this.onPressed,
    this.onDeleted,
    this.icon,
    super.key,
  });

  /// Text rendered inside the pill.
  final String label;

  /// When `true` the chip is rendered in the selected state (filled
  /// accent fill, white text).
  final bool selected;

  /// Tap callback. When `null` and [onDeleted] is also `null` the chip
  /// is non-interactive.
  final VoidCallback? onPressed;

  /// When non-null an "x" delete affordance is shown on the trailing
  /// edge; tapping it fires [onDeleted] (NOT [onPressed]). When `null`
  /// the delete affordance is hidden.
  final VoidCallback? onDeleted;

  /// Optional leading icon. Rendered at 14×14 in the same color as
  /// [label].
  final IconData? icon;

  /// Minimum chip height in logical pixels.
  static const double minHeight = 28;

  /// Minimum tap target height for interactive chips.
  static const double hitHeight = 44;

  /// Vertical padding inside the pill.
  static const double verticalPadding = 6;

  /// Horizontal padding inside the pill.
  static const double horizontalPadding = 12;

  /// Pill corner radius (full-pill).
  static const double radius = 14;

  /// Default (unselected) background color.
  static const Color backgroundColor = Color(0xFFE5E5EA);

  /// Dark-mode unselected background color.
  static const Color backgroundColorDark = Color(0xFF3A3A3C);

  /// Default (unselected) label color.
  static const Color labelColor = Color(0xFF1C1C1E);

  /// Dark-mode unselected label color.
  static const Color labelColorDark = Color(0xFFFFFFFF);

  /// Selected background color (iOS system blue).
  static const Color selectedBackgroundColor = Color(0xFF007AFF);

  /// Selected label color.
  static const Color selectedLabelColor = Color(0xFFFFFFFF);

  /// Opacity used when the chip is disabled.
  static const double disabledOpacity = 0.4;

  /// Leading icon size.
  static const double iconSize = 14;

  /// Padding between leading icon and label.
  static const double iconLabelGap = 4;

  /// Delete affordance side length.
  static const double deleteSize = 14;

  /// `LucideIcons.x` glyph size inside the delete affordance.
  static const double deleteIconSize = 10;

  /// Padding between label and delete affordance.
  static const double deleteLabelGap = 6;

  /// Color transition duration.
  static const Duration animationDuration = LiqMotion.fast;

  /// Label text style.
  static const TextStyle textStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1,
  );

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final isInteractive = onPressed != null || onDeleted != null;
    final background =
        selected
            ? selectedBackgroundColor
            : (isDark ? backgroundColorDark : backgroundColor);
    final foreground =
        selected ? selectedLabelColor : (isDark ? labelColorDark : labelColor);

    final visualChip = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: minHeight),
      child: LiqGlassSurface(
        baseFill: background,
        borderRadius: BorderRadius.circular(radius),
        padding: const EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(
              icon,
              size: iconSize,
              color: foreground,
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(width: iconLabelGap),
          ],
          Flexible(
            child: Text(
              label,
              style: textStyle.copyWith(color: foreground),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
            ),
          ),
          if (onDeleted != null) ...<Widget>[
            const SizedBox(width: deleteLabelGap),
            const SizedBox(width: deleteSize, height: deleteSize),
          ],
        ],
      ),
      ),
    );

    Widget chip = isInteractive
        ? Padding(
            padding: const EdgeInsets.symmetric(
              vertical: (hitHeight - minHeight) / 2,
            ),
            child: visualChip,
          )
        : visualChip;

    if (onDeleted != null) {
      chip = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          chip,
          Positioned(
            top: (hitHeight - deleteSize) / 2,
            right: horizontalPadding,
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: onDeleted,
              child: LiqPointerCursor(
                child: SizedBox.square(
                  dimension: deleteSize,
                  child: Center(
                    child: Icon(
                      LucideIcons.x,
                      size: deleteIconSize,
                      color: foreground,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (onPressed != null) {
      chip = LiqPointerCursor(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: chip,
        ),
      );
    }

    if (!isInteractive) {
      chip = Opacity(opacity: disabledOpacity, child: chip);
    }

    return Semantics(
      button: onPressed != null,
      selected: selected,
      enabled: isInteractive,
      label: label,
      child: chip,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<bool>('selected', selected))
      ..add(DiagnosticsProperty<bool>('hasIcon', icon != null))
      ..add(DiagnosticsProperty<bool>('hasOnPressed', onPressed != null))
      ..add(DiagnosticsProperty<bool>('hasOnDeleted', onDeleted != null));
  }
}

/// Convenience layout for a row of [LiqChip]s that wraps to multiple
/// lines.
///
/// A thin wrapper around [Wrap] with iOS-correct default spacing — 6pt
/// horizontal between chips, 8pt vertical between wrapped rows.
final class LiqChipGroup extends StatelessWidget {
  /// Creates a chip group.
  const LiqChipGroup({
    required this.chips,
    this.spacing = 6,
    this.runSpacing = 8,
    super.key,
  });

  /// The chips to lay out.
  final List<LiqChip> chips;

  /// Horizontal gap between chips on the same row.
  final double spacing;

  /// Vertical gap between wrapped rows.
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: spacing, runSpacing: runSpacing, children: chips);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('chipsCount', chips.length))
      ..add(DoubleProperty('spacing', spacing))
      ..add(DoubleProperty('runSpacing', runSpacing));
  }
}
