import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// One option in a [LiqCombobox].
///
/// [value] is what the parent receives via `onChanged` when the user
/// selects this row; [label] is what the user sees and what the
/// default filter matches against.
final class LiqComboboxOption<T> with Diagnosticable {
  /// Creates a combobox option.
  const LiqComboboxOption({required this.value, required this.label});

  /// The value emitted via [LiqCombobox.onChanged] when this option is
  /// selected.
  final T value;

  /// The label rendered in the field and the dropdown row.
  final String label;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<T>('value', value))
      ..add(StringProperty('label', label));
  }
}

/// iOS 26 typeahead-filtered dropdown — a text field on top with a
/// filtered options panel beneath.
///
/// Distinct from `LiqPopupButton`, which is a static dropdown of preset
/// options. Here the user types a query, matching options are listed
/// underneath, and tapping a row commits the selection.
///
/// Sourced from `native/components/comboboxes.css` (iOS 26 spec):
///   - field 44pt height, 10pt corner radius, 1pt border #E5E5EA
///   - active border 1.5pt #007AFF
///   - dropdown panel 10pt radius, 4pt offset from field, white
///   - rows 44pt tall with a 12pt horizontal padding
///   - selected row gets a trailing checkmark in #007AFF
final class LiqCombobox<T> extends StatefulWidget {
  /// Creates a combobox.
  const LiqCombobox({
    required this.options,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.filter,
    this.maxOptionsVisible = 6,
    this.onOpenChanged,
    super.key,
  }) : assert(maxOptionsVisible > 0, 'maxOptionsVisible must be positive');

  /// All available options.
  final List<LiqComboboxOption<T>> options;

  /// Currently selected value, or `null` if none.
  ///
  /// The text field displays the matching option's label when [value]
  /// is set; the user can type to replace it.
  final T? value;

  /// Called when the user selects an option from the dropdown. Pass
  /// `null` to clear (typing a non-matching string does NOT call this —
  /// selection is only via tap).
  ///
  /// When `null`, the control is disabled: tapping the field does not
  /// open the dropdown and the field rejects focus.
  final ValueChanged<T?>? onChanged;

  /// Placeholder text shown when no value is selected and the field is
  /// empty.
  final String? placeholder;

  /// Optional custom filter. Receives the user's typed query and an
  /// option, returns `true` if the option should be shown.
  ///
  /// Defaults to a case-insensitive substring match on
  /// [LiqComboboxOption.label].
  final bool Function(String query, LiqComboboxOption<T> option)? filter;

  /// Max rows to show in the dropdown panel before scrolling.
  final int maxOptionsVisible;

  /// Called when the dropdown opens or closes.
  final ValueChanged<bool>? onOpenChanged;

  /// Field height.
  static const double fieldHeight = 44;

  /// Field corner radius.
  static const double fieldRadius = 10;

  /// Inactive border thickness.
  static const double inactiveBorderWidth = 1;

  /// Focused border thickness.
  static const double activeBorderWidth = 1.5;

  /// Inactive border color.
  static const Color inactiveBorderColor = Color(0xFFE5E5EA);

  /// Focused border color (also row checkmark).
  static const Color activeBorderColor = Color(0xFF007AFF);

  /// Field background color.
  static const Color backgroundColor = Color(0xFFFFFFFF);

  /// Primary text color.
  static const Color textColor = Color(0xFF1C1C1E);

  /// Placeholder text color.
  static const Color placeholderColor = Color(0xFFC7C7CC);

  /// Trailing chevron and "no matches" color.
  static const Color chevronColor = Color(0xFF8E8E93);

  /// Pressed-row background color.
  static const Color pressedRowColor = Color(0xFFE5E5EA);

  /// Dropdown shadow.
  static const BoxShadow panelShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  );

  /// Vertical gap between the field and the dropdown panel.
  static const double panelOffset = 4;

  /// Each dropdown row's height.
  static const double rowHeight = 44;

  /// Horizontal padding inside the field and rows.
  static const double horizontalPadding = 12;

  /// Right padding for the trailing chevron.
  static const double chevronRightPadding = 8;

  /// Default text style for the typed value and option rows.
  static const TextStyle textStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  @override
  State<LiqCombobox<T>> createState() => _LiqComboboxState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('optionsCount', options.length))
      ..add(
        StringProperty(
          'valueLabel',
          value == null
              ? null
              : options
                  .where((o) => o.value == value)
                  .map((o) => o.label)
                  .firstOrNull,
          defaultValue: null,
        ),
      )
      ..add(StringProperty('placeholder', placeholder, defaultValue: null))
      ..add(IntProperty('maxOptionsVisible', maxOptionsVisible))
      ..add(
        ObjectFlagProperty<ValueChanged<bool>?>.has(
          'onOpenChanged',
          onOpenChanged,
        ),
      );
  }
}

class _LiqComboboxState<T> extends State<LiqCombobox<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final OverlayPortalController _portalController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  bool _suppressEmit = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _labelFor(widget.value) ?? '');
    _focusNode = FocusNode(canRequestFocus: widget.onChanged != null)
      ..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant LiqCombobox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onChanged != oldWidget.onChanged) {
      _focusNode.canRequestFocus = widget.onChanged != null;
      if (widget.onChanged == null && _focusNode.hasFocus) {
        _focusNode.unfocus();
      } else if (widget.onChanged == null) {
        _hideDropdown();
      }
    }
    if (widget.value != oldWidget.value) {
      final label = _labelFor(widget.value) ?? '';
      if (_controller.text != label) {
        _suppressEmit = true;
        _controller.value = TextEditingValue(
          text: label,
          selection: TextSelection.collapsed(offset: label.length),
        );
        _suppressEmit = false;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  String? _labelFor(T? value) {
    if (value == null) return null;
    for (final option in widget.options) {
      if (option.value == value) return option.label;
    }
    return null;
  }

  void _showDropdown() {
    if (_portalController.isShowing) return;
    _portalController.show();
    widget.onOpenChanged?.call(true);
  }

  void _hideDropdown() {
    if (!_portalController.isShowing) return;
    _portalController.hide();
    widget.onOpenChanged?.call(false);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _showDropdown();
    } else {
      _hideDropdown();
    }
    setState(() {});
  }

  void _openIfPossible() {
    if (widget.onChanged == null) return;
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    } else if (!_portalController.isShowing) {
      _showDropdown();
      setState(() {});
    }
  }

  void _selectOption(LiqComboboxOption<T> option) {
    _suppressEmit = true;
    _controller.value = TextEditingValue(
      text: option.label,
      selection: TextSelection.collapsed(offset: option.label.length),
    );
    _suppressEmit = false;
    widget.onChanged?.call(option.value);
    _focusNode.unfocus();
  }

  List<LiqComboboxOption<T>> _filteredOptions() {
    final query = _controller.text;
    final selectedLabel = _labelFor(widget.value);
    // When the field shows the selected label verbatim and the user
    // hasn't typed anything new, show the entire option list. This is
    // what users expect when they reopen the dropdown after a previous
    // selection.
    if (query.isEmpty || query == selectedLabel) {
      return widget.options;
    }
    final filter =
        widget.filter ??
        (String q, LiqComboboxOption<T> opt) =>
            opt.label.toLowerCase().contains(q.toLowerCase());
    return widget.options
        .where((option) => filter(query, option))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final palette = _ComboboxPalette.resolve(context);
    final disabled = widget.onChanged == null;
    final hasFocus = _focusNode.hasFocus;
    final borderColor = hasFocus ? palette.activeBorder : palette.border;
    final borderWidth =
        hasFocus
            ? LiqCombobox.activeBorderWidth
            : LiqCombobox.inactiveBorderWidth;
    final isOpen = _portalController.isShowing;

    return Semantics(
      textField: true,
      enabled: !disabled,
      value: _controller.text,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: OverlayPortal(
          controller: _portalController,
          overlayChildBuilder: _buildDropdown,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: disabled ? null : (_) => _openIfPossible(),
            child: Container(
              height: LiqCombobox.fieldHeight,
              decoration: BoxDecoration(
                color: palette.background,
                borderRadius: BorderRadius.circular(LiqCombobox.fieldRadius),
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: LiqCombobox.horizontalPadding),
                  Expanded(
                    child: CupertinoTextField.borderless(
                      controller: _controller,
                      focusNode: _focusNode,
                      readOnly: disabled,
                      enabled: !disabled,
                      padding: EdgeInsets.zero,
                      placeholder: widget.placeholder,
                      placeholderStyle: LiqCombobox.textStyle.copyWith(
                        color: palette.placeholder,
                      ),
                      style: LiqCombobox.textStyle.copyWith(
                        color: palette.text,
                      ),
                      cursorColor: palette.activeBorder,
                      cursorRadius: const Radius.circular(1),
                      onChanged: (_) {
                        if (_suppressEmit) return;
                        if (!_portalController.isShowing) {
                          _showDropdown();
                        }
                        setState(() {});
                      },
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: LiqCombobox.chevronRightPadding,
                      left: 4,
                    ),
                    child: Icon(
                      isOpen
                          ? LucideIcons.chevronUp
                          : LucideIcons.chevronDown,
                      size: 18,
                      color: palette.secondary,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    final filtered = _filteredOptions();
    final rowCount = filtered.isEmpty ? 1 : filtered.length;
    final visibleRows =
        rowCount < widget.maxOptionsVisible
            ? rowCount
            : widget.maxOptionsVisible;
    final panelHeight = visibleRows * LiqCombobox.rowHeight;

    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        targetAnchor: Alignment.bottomLeft,
        offset: const Offset(0, LiqCombobox.panelOffset),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: context.liqMotionDuration(LiqMotion.fast),
          curve: LiqMotion.standard,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.98 + (value * 0.02),
                alignment: Alignment.topCenter,
                child: child,
              ),
            );
          },
          child: _DropdownPanel<T>(
            width: _fieldWidth(),
            height: panelHeight,
            options: filtered,
            selectedValue: widget.value,
            onSelect: _selectOption,
          ),
        ),
      ),
    );
  }

  double _fieldWidth() {
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      return renderObject.size.width;
    }
    return 0;
  }
}

class _DropdownPanel<T> extends StatelessWidget {
  const _DropdownPanel({
    required this.width,
    required this.height,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
  });

  final double width;
  final double height;
  final List<LiqComboboxOption<T>> options;
  final T? selectedValue;
  final ValueChanged<LiqComboboxOption<T>> onSelect;

  @override
  Widget build(BuildContext context) {
    return TextFieldTapRegion(
      child: SizedBox(
        width: width,
        height: height,
        child: LiqGlassSurface(
          borderRadius: BorderRadius.circular(LiqCombobox.fieldRadius),
          tint: context.liqIsDark ? LiqGlassTint.dark : LiqGlassTint.light,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(LiqCombobox.fieldRadius),
            child:
                options.isEmpty
                    ? const _EmptyRow()
                    : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        return _OptionRow<T>(
                          option: option,
                          selected: option.value == selectedValue,
                          onTap: () => onSelect(option),
                        );
                      },
                    ),
          ),
        ),
      ),
    );
  }
}

class _OptionRow<T> extends StatefulWidget {
  const _OptionRow({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final LiqComboboxOption<T> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_OptionRow<T>> createState() => _OptionRowState<T>();
}

class _OptionRowState<T> extends State<_OptionRow<T>> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = _ComboboxPalette.resolve(context);
    return LiqPointerCursor(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: Container(
          height: LiqCombobox.rowHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: LiqCombobox.horizontalPadding,
          ),
          color: _pressed ? palette.pressedRow : null,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.option.label,
                  style: LiqCombobox.textStyle.copyWith(color: palette.text),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                ),
              ),
              if (widget.selected)
                Icon(
                  LucideIcons.check,
                  size: 18,
                  color: palette.activeBorder,
                  textDirection: TextDirection.ltr,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  const _EmptyRow();

  @override
  Widget build(BuildContext context) {
    final palette = _ComboboxPalette.resolve(context);
    return Container(
      height: LiqCombobox.rowHeight,
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.symmetric(
        horizontal: LiqCombobox.horizontalPadding,
      ),
      child: Text(
        'No matches',
        style: TextStyle(
          fontFamily: 'SF Pro Text',
          fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: palette.secondary,
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

final class _ComboboxPalette {
  const _ComboboxPalette({
    required this.background,
    required this.text,
    required this.placeholder,
    required this.secondary,
    required this.border,
    required this.activeBorder,
    required this.pressedRow,
  });

  factory _ComboboxPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _ComboboxPalette(
        background: LiqCombobox.backgroundColor,
        text: LiqCombobox.textColor,
        placeholder: LiqCombobox.placeholderColor,
        secondary: LiqCombobox.chevronColor,
        border: LiqCombobox.inactiveBorderColor,
        activeBorder: LiqCombobox.activeBorderColor,
        pressedRow: LiqCombobox.pressedRowColor,
      );
    }

    final secondary = context.liqSecondaryLabelColor;
    return _ComboboxPalette(
      background: context.liqSurfaceColor,
      text: context.liqLabelColor,
      placeholder: secondary.withValues(alpha: 0.48),
      secondary: secondary,
      border: secondary.withValues(alpha: 0.24),
      activeBorder: context.liqPrimaryColor,
      pressedRow: secondary.withValues(alpha: 0.14),
    );
  }

  final Color background;
  final Color text;
  final Color placeholder;
  final Color secondary;
  final Color border;
  final Color activeBorder;
  final Color pressedRow;
}
