import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/menu/liq_menu.dart';

/// One option in a [LiqDropdownButton].
@immutable
class LiqDropdownItem<T> {
  /// Creates a dropdown item.
  const LiqDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });

  /// The value reported via `onChanged` when this item is selected.
  final T value;

  /// Human-readable label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// When false the option renders disabled and isn't selectable.
  final bool enabled;
}

/// Dropdown selector — tap-to-open menu of [items], reports the selected
/// value via [onChanged].
///
/// Example:
///
/// ```dart
/// LiqDropdownButton<String>(
///   value: country,
///   items: const <LiqDropdownItem<String>>[
///     LiqDropdownItem(value: 'us', label: 'United States'),
///     LiqDropdownItem(value: 'fr', label: 'France'),
///   ],
///   onChanged: (v) => setState(() => country = v),
/// )
/// ```
final class LiqDropdownButton<T> extends StatefulWidget {
  /// Creates a dropdown button.
  const LiqDropdownButton({
    required this.value,
    required this.items,
    required this.onChanged,
    this.placeholder = 'Select…',
    this.style = LiqButtonStyle.borderedSecondary,
    this.size = LiqButtonSize.medium,
    this.fullWidth = false,
    this.menuWidth,
    super.key,
  });

  /// Currently selected value. May be `null` for an empty selection.
  final T? value;

  /// Items the menu will show.
  final List<LiqDropdownItem<T>> items;

  /// Selection callback. When `null` the button renders disabled.
  final ValueChanged<T?>? onChanged;

  /// Placeholder shown when [value] doesn't match any item's `value`.
  final String placeholder;

  /// Visual style of the underlying [LiqButton] surface.
  final LiqButtonStyle style;

  /// Size of the underlying [LiqButton].
  final LiqButtonSize size;

  /// Whether the button stretches to its parent's width.
  final bool fullWidth;

  /// Optional override for the popup menu width. Defaults to the
  /// button's measured width clamped to `[200, 320]`.
  final double? menuWidth;

  @override
  State<LiqDropdownButton<T>> createState() => _LiqDropdownButtonState<T>();
}

class _LiqDropdownButtonState<T> extends State<LiqDropdownButton<T>> {
  final GlobalKey _buttonKey = GlobalKey();

  String _resolveLabel() {
    if (widget.value == null) return widget.placeholder;
    for (final item in widget.items) {
      if (item.value == widget.value) return item.label;
    }
    return widget.placeholder;
  }

  IconData? _resolveLeadingIcon() {
    if (widget.value == null) return null;
    for (final item in widget.items) {
      if (item.value == widget.value) return item.icon;
    }
    return null;
  }

  Future<void> _open() async {
    final ctx = _buttonKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) return;
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final origin =
        box.localToGlobal(Offset.zero, ancestor: overlayBox);
    final width = (widget.menuWidth ?? box.size.width).clamp(200.0, 320.0);
    final position = Offset(origin.dx, origin.dy + box.size.height + 4);

    final children = <Widget>[
      for (final item in widget.items)
        LiqMenuItem(
          label: item.label,
          icon: item.icon == null ? null : Icon(item.icon, size: 18),
          onPressed: !item.enabled
              ? null
              : () {
                  Navigator.of(ctx).pop();
                  widget.onChanged?.call(item.value);
                },
        ),
    ];

    await LiqMenu.showPopup<void>(
      context: ctx,
      children: children,
      position: position,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onChanged == null || widget.items.isEmpty;
    return LiqButton(
      key: _buttonKey,
      label: _resolveLabel(),
      style: widget.style,
      size: widget.size,
      fullWidth: widget.fullWidth,
      leadingIcon: _resolveLeadingIcon(),
      trailingIcon: _ChevronDown.iconData,
      onPressed: disabled ? null : _open,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('itemCount', widget.items.length))
      ..add(StringProperty('placeholder', widget.placeholder))
      ..add(EnumProperty<LiqButtonStyle>('style', widget.style))
      ..add(EnumProperty<LiqButtonSize>('size', widget.size))
      ..add(
        FlagProperty(
          'enabled',
          value: widget.onChanged != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}

/// Pull-down button — title + subtitle + chevron, opens a menu of
/// arbitrary items on tap.
///
/// Use this when the menu items are *actions* (not value selection).
/// For value selection, prefer [LiqDropdownButton].
final class LiqPullDownButton extends StatefulWidget {
  /// Creates a pull-down button.
  const LiqPullDownButton({
    required this.title,
    required this.items,
    this.subtitle,
    this.leadingIcon,
    this.style = LiqButtonStyle.borderedSecondary,
    this.size = LiqButtonSize.medium,
    this.fullWidth = false,
    this.menuWidth,
    this.enabled = true,
    super.key,
  });

  /// Button title.
  final String title;

  /// Optional subtitle (rendered as small text under [title]). Note that
  /// [LiqButton] only renders a single label line; this widget renders
  /// `'$title · $subtitle'` when subtitle is non-null.
  final String? subtitle;

  /// Items shown in the pop-up menu when tapped.
  final List<LiqMenuItem> items;

  /// Optional leading icon.
  final IconData? leadingIcon;

  /// Visual style.
  final LiqButtonStyle style;

  /// Size axis.
  final LiqButtonSize size;

  /// Whether the button stretches to its parent's width.
  final bool fullWidth;

  /// Optional override for the popup menu width.
  final double? menuWidth;

  /// When false the button renders disabled.
  final bool enabled;

  @override
  State<LiqPullDownButton> createState() => _LiqPullDownButtonState();
}

class _LiqPullDownButtonState extends State<LiqPullDownButton> {
  final GlobalKey _buttonKey = GlobalKey();

  Future<void> _open() async {
    final ctx = _buttonKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) return;
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final origin =
        box.localToGlobal(Offset.zero, ancestor: overlayBox);
    final width = (widget.menuWidth ?? box.size.width).clamp(200.0, 320.0);
    final position = Offset(origin.dx, origin.dy + box.size.height + 4);

    await LiqMenu.showPopup<void>(
      context: ctx,
      children: List<Widget>.from(widget.items),
      position: position,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.subtitle == null
        ? widget.title
        : '${widget.title} · ${widget.subtitle}';
    final disabled = !widget.enabled || widget.items.isEmpty;
    return LiqButton(
      key: _buttonKey,
      label: label,
      style: widget.style,
      size: widget.size,
      fullWidth: widget.fullWidth,
      leadingIcon: widget.leadingIcon,
      trailingIcon: _ChevronDown.iconData,
      onPressed: disabled ? null : _open,
    );
  }
}

/// Split button — primary [LiqButton] action + secondary chevron that
/// opens an action menu.
final class LiqSplitButton extends StatefulWidget {
  /// Creates a split button.
  const LiqSplitButton({
    required this.label,
    required this.menuItems,
    this.onPressed,
    this.leadingIcon,
    this.style = LiqButtonStyle.borderedProminent,
    this.size = LiqButtonSize.medium,
    this.menuWidth,
    super.key,
  });

  /// Primary action label.
  final String label;

  /// Primary action callback. When `null` the main half is disabled
  /// while the menu half remains active (assuming [menuItems] is
  /// non-empty).
  final VoidCallback? onPressed;

  /// Optional leading icon for the primary button.
  final IconData? leadingIcon;

  /// Items shown in the pop-up menu when the chevron is tapped.
  final List<LiqMenuItem> menuItems;

  /// Visual style applied to both halves.
  final LiqButtonStyle style;

  /// Size axis applied to both halves.
  final LiqButtonSize size;

  /// Optional override for the popup menu width.
  final double? menuWidth;

  @override
  State<LiqSplitButton> createState() => _LiqSplitButtonState();
}

class _LiqSplitButtonState extends State<LiqSplitButton> {
  final GlobalKey _menuKey = GlobalKey();

  Future<void> _open() async {
    final ctx = _menuKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) return;
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final origin =
        box.localToGlobal(Offset.zero, ancestor: overlayBox);
    final width = widget.menuWidth ?? 240.0;
    final position = Offset(
      origin.dx + box.size.width - width,
      origin.dy + box.size.height + 4,
    );
    await LiqMenu.showPopup<void>(
      context: ctx,
      children: List<Widget>.from(widget.menuItems),
      position: position,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        LiqButton(
          label: widget.label,
          leadingIcon: widget.leadingIcon,
          style: widget.style,
          size: widget.size,
          onPressed: widget.onPressed,
        ),
        const SizedBox(width: 4),
        LiqButton(
          key: _menuKey,
          label: '',
          trailingIcon: _ChevronDown.iconData,
          style: widget.style,
          size: widget.size,
          onPressed: widget.menuItems.isEmpty ? null : _open,
        ),
      ],
    );
  }
}

/// Internal sentinel for a chevron-down glyph drawn via
/// `IconData(0)`. Consumers can pass `LiqIcons.down` from
/// `liqkit_ui_icons` for a real glyph; the dummy keeps the public
/// surface dependency-free.
class _ChevronDown {
  static const IconData iconData = IconData(0xE5CF, fontFamily: 'MaterialIcons');
}
