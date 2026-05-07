import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/checkboxes/liq_checkbox.dart';
import 'package:liqkit_ui/src/components/lists/liq_list.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Row that exposes a checkbox-style multi-select toggle. When
/// [onChanged] is null the row is rendered non-interactive.
final class LiqSelectableListRow extends StatelessWidget with Diagnosticable {
  /// Creates a selectable list row.
  const LiqSelectableListRow({
    required this.title,
    required this.selected,
    this.subtitle,
    this.leading,
    this.onChanged,
    this.contentPadding,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return LiqListRow(
      title: title,
      subtitle: subtitle,
      leading: leading,
      selected: selected,
      contentPadding: contentPadding,
      onTap: onChanged == null ? null : () => onChanged!(!selected),
      trailing: LiqCheckbox(
        value: selected
            ? LiqCheckboxState.checked
            : LiqCheckboxState.unchecked,
        onChanged: onChanged == null
            ? null
            : (state) => onChanged!(state == LiqCheckboxState.checked),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(FlagProperty('selected', value: selected, ifTrue: 'selected'));
  }
}

/// One swipe action revealed beside a [LiqSwipeableListRow].
@immutable
class LiqSwipeAction {
  /// Creates a swipe action.
  const LiqSwipeAction({
    required this.icon,
    required this.onTap,
    this.label,
    this.backgroundColor,
    this.iconColor = const Color(0xFFFFFFFF),
  });

  /// Glyph rendered inside the action tile.
  final IconData icon;

  /// Optional label rendered under the glyph.
  final String? label;

  /// Tap callback.
  final VoidCallback onTap;

  /// Background fill of the action tile.
  final Color? backgroundColor;

  /// Glyph color.
  final Color iconColor;
}

/// List row with reveal-on-swipe leading/trailing action tiles
/// (iOS Mail / Reminders style).
final class LiqSwipeableListRow extends StatefulWidget with Diagnosticable {
  /// Creates a swipeable list row.
  const LiqSwipeableListRow({
    required this.child,
    this.leadingActions = const <LiqSwipeAction>[],
    this.trailingActions = const <LiqSwipeAction>[],
    this.actionExtent = 72,
    super.key,
  });

  final Widget child;
  final List<LiqSwipeAction> leadingActions;
  final List<LiqSwipeAction> trailingActions;
  final double actionExtent;

  @override
  State<LiqSwipeableListRow> createState() => _LiqSwipeableListRowState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('leadingActions', leadingActions.length))
      ..add(IntProperty('trailingActions', trailingActions.length));
  }
}

class _LiqSwipeableListRowState extends State<LiqSwipeableListRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    value: 0,
  );

  double _drag = 0;
  double _maxLeadingExtent = 0;
  double _maxTrailingExtent = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maxLeadingExtent =
        widget.leadingActions.length * widget.actionExtent;
    _maxTrailingExtent =
        widget.trailingActions.length * widget.actionExtent;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _drag += details.primaryDelta ?? 0;
      _drag = _drag.clamp(-_maxTrailingExtent, _maxLeadingExtent);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final threshold = widget.actionExtent / 2;
    if (_drag > threshold || velocity > 800) {
      setState(() => _drag = _maxLeadingExtent);
    } else if (_drag < -threshold || velocity < -800) {
      setState(() => _drag = -_maxTrailingExtent);
    } else {
      setState(() => _drag = 0);
    }
  }

  void _close() => setState(() => _drag = 0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: ClipRect(
        child: Stack(
          children: <Widget>[
            if (_drag > 0)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: _drag,
                child: _ActionRow(
                  actions: widget.leadingActions,
                  alignStart: true,
                  onAfterTap: _close,
                ),
              ),
            if (_drag < 0)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: -_drag,
                child: _ActionRow(
                  actions: widget.trailingActions,
                  alignStart: false,
                  onAfterTap: _close,
                ),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              transform: Matrix4.translationValues(_drag, 0, 0),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.actions,
    required this.alignStart,
    required this.onAfterTap,
  });

  final List<LiqSwipeAction> actions;
  final bool alignStart;
  final VoidCallback onAfterTap;

  @override
  Widget build(BuildContext context) {
    final ordered = alignStart ? actions : actions.reversed.toList();
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          alignStart ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: <Widget>[
        for (final action in ordered)
          _ActionTile(action: action, onAfterTap: onAfterTap),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action, required this.onAfterTap});

  final LiqSwipeAction action;
  final VoidCallback onAfterTap;

  @override
  Widget build(BuildContext context) {
    final bg = action.backgroundColor ?? LiqAppleColors.systemBlue;
    return GestureDetector(
      onTap: () {
        action.onTap();
        onAfterTap();
      },
      child: Container(
        width: 72,
        color: bg,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(action.icon, color: action.iconColor, size: 22),
            if (action.label != null) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                action.label!,
                style: TextStyle(
                  color: action.iconColor,
                  fontSize: 11,
                  fontWeight: LiqAppleTypography.semibold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Section (header + footer + rows) for grouped iOS-style lists.
final class LiqListSection extends StatelessWidget with Diagnosticable {
  /// Creates a list section.
  const LiqListSection({
    required this.children,
    this.header,
    this.footer,
    super.key,
  });

  final String? header;
  final String? footer;
  final List<LiqListRow> children;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final captionStyle = LiqAppleTypography.footnote(brightness).copyWith(
      color: isDark
          ? const Color(0x99EBEBF5)
          : const Color(0x993C3C43),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (header != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
            child: Text(
              header!.toUpperCase(),
              style: captionStyle,
            ),
          ),
        LiqListGroup(rows: children),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            child: Text(footer!, style: captionStyle),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('header', header))
      ..add(StringProperty('footer', footer))
      ..add(IntProperty('rowCount', children.length));
  }
}

/// Grouped list view — vertical stack of [LiqListSection]s.
final class LiqGroupedListView extends StatelessWidget with Diagnosticable {
  /// Creates a grouped list view.
  const LiqGroupedListView({
    required this.sections,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.shrinkWrap = false,
    this.physics,
    super.key,
  });

  final List<LiqListSection> sections;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: sections.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: sections[index],
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('sectionCount', sections.length));
  }
}

/// Expandable list row — tap toggles a children panel below.
final class LiqExpandableListRow extends StatefulWidget with Diagnosticable {
  /// Creates an expandable row.
  const LiqExpandableListRow({
    required this.title,
    required this.children,
    this.subtitle,
    this.leading,
    this.initiallyExpanded = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  State<LiqExpandableListRow> createState() => _LiqExpandableListRowState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(IntProperty('childCount', children.length));
  }
}

class _LiqExpandableListRowState extends State<LiqExpandableListRow>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final chevronColor = isDark
        ? const Color(0x80EBEBF5)
        : const Color(0x803C3C43);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LiqListRow(
          title: widget.title,
          subtitle: widget.subtitle,
          leading: widget.leading,
          onTap: () => setState(() => _expanded = !_expanded),
          trailing: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: _expanded ? 0.25 : 0,
            child: CustomPaint(
              size: const Size(10, 16),
              painter: _ChevronPainter(color: chevronColor),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: _expanded
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.children,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final h = size.height * 0.32;
    final w = size.width * 0.45;
    final path = Path()
      ..moveTo(cx - w / 2, cy - h)
      ..lineTo(cx + w / 2, cy)
      ..lineTo(cx - w / 2, cy + h);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChevronPainter old) => color != old.color;
}
