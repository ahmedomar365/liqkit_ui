import 'package:flutter/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 single-region collapsible.
///
/// `LiqCollapsible` shows a tappable header with a trailing chevron above
/// an optional body region. Tapping the header toggles the body open or
/// closed; the chevron rotates 90° clockwise on expand. This is the
/// standard "Show more / Show less" or single-question FAQ primitive.
///
/// Distinct from `LiqAccordion`, which manages a list of
/// `LiqAccordionItem` rows inside a shared rounded surface.
/// `LiqCollapsible` does not draw its own outer border or background —
/// the consumer wraps it in whatever surface they want (or none).
///
/// Pass [initiallyExpanded] to control the first-paint state. The widget
/// owns the open/closed state internally; subscribe to [onChanged] to
/// react to user toggles.
final class LiqCollapsible extends StatefulWidget {
  /// Creates a collapsible region.
  const LiqCollapsible({
    required this.header,
    required this.child,
    this.initiallyExpanded = false,
    this.onChanged,
    super.key,
  });

  /// Header rendered above the body. The header is wrapped in a
  /// 12pt-vertical / 16pt-horizontal padding and made fully tappable;
  /// tapping toggles the expansion. The header does not receive the
  /// expansion state — pass a `Builder` (or roll your own
  /// `StatefulWidget`) if you need a header that reflects the open
  /// state itself (e.g. flipping a custom chevron).
  final Widget header;

  /// The collapsible content. Rendered when expanded, animated in/out
  /// with `AnimatedSize`.
  final Widget child;

  /// Whether the body is expanded on first build. Defaults to `false`.
  final bool initiallyExpanded;

  /// Called with the new expansion state when the user toggles the
  /// header.
  final ValueChanged<bool>? onChanged;

  /// Trailing-chevron color (SF iOS tertiary label).
  static const Color chevronColor = Color(0xFF8E8E93);

  /// Trailing-chevron color in dark theme.
  static const Color darkChevronColor = Color(0xB2EBEBF5);

  /// Trailing-chevron square size in logical px.
  static const double chevronSize = 13;

  /// Header vertical padding in logical px.
  static const double headerVPad = 12;

  /// Header horizontal padding in logical px.
  static const double headerHPad = 16;

  /// Duration of the chevron rotation animation.
  static const Duration rotateDuration = LiqMotion.fast;

  /// Duration of the body expand/collapse animation.
  static const Duration expandDuration = LiqMotion.normal;

  /// Curve used for both the chevron rotation and body resize.
  static const Curve curve = LiqMotion.standard;

  @override
  State<LiqCollapsible> createState() => _LiqCollapsibleState();
}

class _LiqCollapsibleState extends State<LiqCollapsible> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _toggle() {
    final next = !_expanded;
    setState(() {
      _expanded = next;
    });
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = context.liqBrightness;
    final chevronColor =
        brightness == Brightness.dark
            ? LiqCollapsible.darkChevronColor
            : LiqCollapsible.chevronColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LiqPointerCursor(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LiqCollapsible.headerHPad,
                vertical: LiqCollapsible.headerVPad,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: widget.header),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    duration: LiqCollapsible.rotateDuration,
                    curve: LiqCollapsible.curve,
                    turns: _expanded ? 0.25 : 0,
                    child: Icon(
                      LucideIcons.chevronRight,
                      size: LiqCollapsible.chevronSize,
                      color: chevronColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: LiqCollapsible.expandDuration,
          curve: LiqCollapsible.curve,
          alignment: Alignment.topCenter,
          child:
              _expanded
                  ? SizedBox(width: double.infinity, child: widget.child)
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('expanded', _expanded));
  }
}
