import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:liqkit_ui/src/components/buttons/liq_icon_button.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 navigation bar.
///
/// Material-free [PreferredSizeWidget] that fits inside `LiqScaffold`'s
/// `appBar` slot. Mirrors the most-used parts of Material's `AppBar` API
/// (`title`, `leading`, `actions`, `centerTitle`) but renders via a
/// translucent [LiqGlassSurface] and HIG typography.
final class LiqAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a navigation bar.
  const LiqAppBar({
    this.title,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions = const <Widget>[],
    this.centerTitle = true,
    this.toolbarHeight = 44,
    this.titleSpacing = 8,
    this.tint = LiqGlassTint.light,
    this.backgroundColor,
    this.bottom,
    this.bottomHeight = 0,
    super.key,
  });

  /// Centered (or leading) title widget. Most consumers pass a `Text`.
  final Widget? title;

  /// Optional leading widget — typically a back button or menu trigger.
  /// When null and [automaticallyImplyLeading] is true, a back-arrow
  /// is rendered if the enclosing [Navigator] can pop.
  final Widget? leading;

  /// When [leading] is null and the enclosing [Navigator] can pop,
  /// render a back-arrow leading button. Defaults to true.
  final bool automaticallyImplyLeading;

  /// Trailing action widgets, laid out in a row at the right edge.
  final List<Widget> actions;

  /// When true (default), the title sits in the visual center.
  final bool centerTitle;

  /// Toolbar content height in logical pixels (default 44 — Apple HIG
  /// minimum tap-target).
  final double toolbarHeight;

  /// Padding between leading/title.
  final double titleSpacing;

  /// Glass tint preset (light by default).
  final LiqGlassTint tint;

  /// Optional explicit background override. When non-null, the glass
  /// blur is replaced with this solid color.
  final Color? backgroundColor;

  /// Optional widget shown below the toolbar (search bar, segmented
  /// control). Counted toward [preferredSize].
  final Widget? bottom;

  /// Height of [bottom] in logical pixels.
  final double bottomHeight;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight + bottomHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final labelColor = isDark ? LiqAppleColors.labelDark : LiqAppleColors.label;
    final titleStyle = LiqAppleTypography.headline(
      isDark ? Brightness.dark : Brightness.light,
    ).copyWith(color: labelColor);

    Widget? effectiveLeading = leading;
    if (effectiveLeading == null &&
        automaticallyImplyLeading &&
        Navigator.canPop(context)) {
      // iOS native nav back: just a chevron in tint, no gray pill chrome.
      // Keep the 44pt hit target for HIG accessibility.
      effectiveLeading = LiqIconButton(
        icon: LucideIcons.chevronLeft,
        style: LiqIconButtonStyle.borderless,
        iconSize: 24,
        onPressed: () => Navigator.maybePop(context),
        semanticLabel: 'Back',
      );
    }

    final Widget toolbar = SizedBox(
      height: toolbarHeight,
      child: Row(
        children: <Widget>[
          if (effectiveLeading != null) ...<Widget>[
            SizedBox(width: titleSpacing),
            effectiveLeading,
          ],
          if (centerTitle) ...<Widget>[
            Expanded(
              child: title == null
                  ? const SizedBox.shrink()
                  : Center(
                      child: DefaultTextStyle.merge(
                        style: titleStyle,
                        child: title!,
                      ),
                    ),
            ),
          ] else ...<Widget>[
            SizedBox(width: titleSpacing),
            if (title != null)
              Expanded(
                child: DefaultTextStyle.merge(
                  style: titleStyle,
                  child: title!,
                ),
              )
            else
              const Spacer(),
          ],
          for (final a in actions) ...<Widget>[
            const SizedBox(width: 4),
            a,
          ],
          SizedBox(width: titleSpacing),
        ],
      ),
    );

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        toolbar,
        if (bottom != null) SizedBox(height: bottomHeight, child: bottom),
      ],
    );

    if (backgroundColor != null) {
      return SizedBox(
        height: preferredSize.height,
        child: ColoredBox(color: backgroundColor!, child: body),
      );
    }

    return SizedBox(
      height: preferredSize.height,
      child: LiqGlassSurface(
        tint: tint,
        borderRadius: BorderRadius.zero,
        child: body,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqGlassTint>('tint', tint))
      ..add(DoubleProperty('toolbarHeight', toolbarHeight))
      ..add(DoubleProperty('bottomHeight', bottomHeight, defaultValue: 0))
      ..add(
        FlagProperty(
          'centerTitle',
          value: centerTitle,
          ifTrue: 'center',
          ifFalse: 'leading',
        ),
      );
  }
}
