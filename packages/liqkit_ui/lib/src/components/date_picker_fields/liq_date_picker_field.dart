import 'package:flutter/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/components/calendars/liq_calendar.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 date-picker field — a 44pt-tall pill trigger that, when tapped,
/// opens a `LiqCalendar` in a popover beneath the field.
///
/// Distinct from:
///   - `LiqCalendar` (standalone month grid the consumer drops anywhere
///     without surrounding chrome)
///   - `LiqDatePicker` (the wheel-style inline picker exposed via the
///     pickers category)
///
/// `LiqDatePickerField` is the shadcn/ui-style convenience wrapper: a
/// text-field-like trigger paired with a popover-hosted calendar. It is
/// the right pick for forms that want a single-line "pick a date" entry.
///
/// The trigger renders the formatted date when [value] is set, or
/// [placeholder] when it is null. Tapping the trigger opens the popover;
/// selecting a day in the calendar fires [onChanged] and closes the
/// popover. Click outside dismisses without committing.
final class LiqDatePickerField extends StatefulWidget {
  /// Creates a date-picker field.
  const LiqDatePickerField({
    required this.value,
    required this.onChanged,
    this.placeholder = 'Select a date',
    this.firstDate,
    this.lastDate,
    this.format,
    super.key,
  });

  /// Currently selected date, or null if no selection has been made.
  final DateTime? value;

  /// Receives the new date when the user taps a day in the calendar.
  ///
  /// When null, the field is dimmed to 40% opacity and is non-interactive.
  final ValueChanged<DateTime>? onChanged;

  /// Text shown on the trigger when [value] is null.
  final String placeholder;

  /// Optional inclusive lower bound forwarded to the embedded
  /// [LiqCalendar].
  final DateTime? firstDate;

  /// Optional inclusive upper bound forwarded to the embedded
  /// [LiqCalendar].
  final DateTime? lastDate;

  /// Optional formatter for the trigger label.
  ///
  /// Defaults to `MMM d, yyyy` via [_defaultFormat] (e.g. `Apr 30, 2026`).
  final String Function(DateTime)? format;

  /// Trigger height.
  static const double fieldHeight = 44;

  /// Trigger corner radius.
  static const double fieldRadius = 10;

  /// Inactive trigger border thickness.
  static const double inactiveBorderWidth = 1;

  /// Open-state trigger border thickness.
  static const double activeBorderWidth = 1.5;

  /// Inactive trigger border color.
  static const Color inactiveBorderColor = Color(0xFFE5E5EA);

  /// Open-state trigger border color (also the popover border accent).
  static const Color activeBorderColor = Color(0xFF007AFF);

  /// Trigger background color.
  static const Color backgroundColor = Color(0xFFFFFFFF);

  /// Trigger text color when a date is selected.
  static const Color textColor = Color(0xFF1C1C1E);

  /// Placeholder text color.
  static const Color placeholderColor = Color(0xFFC7C7CC);

  /// Trailing chevron color.
  static const Color chevronColor = Color(0xFF8E8E93);

  /// Popover panel corner radius.
  static const double panelRadius = 14;

  /// Popover panel padding.
  static const double panelPadding = 12;

  /// Vertical gap between the field and the popover.
  static const double panelOffset = 4;

  /// Horizontal padding inside the trigger.
  static const double horizontalPadding = 12;

  /// Right-side padding for the trailing chevron.
  static const double chevronRightPadding = 8;

  /// Opacity applied to the trigger when [onChanged] is null.
  static const double disabledOpacity = 0.4;

  /// Popover open/close animation duration.
  static const Duration animationDuration = LiqMotion.fast;

  /// Default text style for the trigger label.
  static const TextStyle textStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  static const List<String> _months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Default trigger-label formatter — `MMM d, yyyy`.
  static String _defaultFormat(DateTime d) {
    return '${_months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  State<LiqDatePickerField> createState() => _LiqDatePickerFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('value', value, defaultValue: null))
      ..add(
        FlagProperty(
          'hasValue',
          value: value != null,
          ifTrue: 'hasValue',
          ifFalse: 'noValue',
        ),
      )
      ..add(
        FlagProperty(
          'enabled',
          value: onChanged != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}

class _LiqDatePickerFieldState extends State<LiqDatePickerField> {
  final OverlayPortalController _portalController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  bool _open = false;

  void _toggleOpen() {
    if (widget.onChanged == null) return;
    if (_open) {
      _close();
    } else {
      _openPanel();
    }
  }

  void _openPanel() {
    if (!_portalController.isShowing) {
      _portalController.show();
    }
    setState(() => _open = true);
  }

  void _close() {
    if (_portalController.isShowing) {
      _portalController.hide();
    }
    if (_open) {
      setState(() => _open = false);
    }
  }

  void _handleDateChanged(DateTime date) {
    widget.onChanged?.call(date);
    _close();
  }

  double _fieldWidth() {
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      return renderObject.size.width;
    }
    return 0;
  }

  String _label(DateTime d) {
    final formatter = widget.format ?? LiqDatePickerField._defaultFormat;
    return formatter(d);
  }

  @override
  Widget build(BuildContext context) {
    final palette = _DatePickerFieldPalette.resolve(context);
    final disabled = widget.onChanged == null;
    final value = widget.value;
    final showsPlaceholder = value == null;
    final labelText = showsPlaceholder ? widget.placeholder : _label(value);
    final labelColor = showsPlaceholder ? palette.placeholder : palette.text;
    final borderColor = _open ? palette.activeBorder : palette.inactiveBorder;
    final borderWidth =
        _open
            ? LiqDatePickerField.activeBorderWidth
            : LiqDatePickerField.inactiveBorderWidth;

    final trigger = CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _portalController,
        overlayChildBuilder: _buildOverlay,
        child: Semantics(
          button: true,
          enabled: !disabled,
          value: showsPlaceholder ? null : labelText,
          label: showsPlaceholder ? widget.placeholder : null,
          child: LiqPointerCursor(
            enabled: !disabled,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: disabled ? null : _toggleOpen,
              child: Container(
                height: LiqDatePickerField.fieldHeight,
                decoration: BoxDecoration(
                  color: palette.background,
                  borderRadius: BorderRadius.circular(
                    LiqDatePickerField.fieldRadius,
                  ),
                  border: Border.all(color: borderColor, width: borderWidth),
                ),
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: LiqDatePickerField.horizontalPadding),
                    Expanded(
                      child: Text(
                        labelText,
                        style: LiqDatePickerField.textStyle.copyWith(
                          color: labelColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: LiqDatePickerField.chevronRightPadding,
                        left: 4,
                      ),
                      child: AnimatedRotation(
                        turns: _open ? 0.5 : 0,
                        duration: context.liqMotionDuration(LiqMotion.fast),
                        curve: LiqMotion.standard,
                        child: Icon(
                          LucideIcons.chevronDown,
                          size: 18,
                          color: palette.chevron,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (disabled) {
      return Opacity(
        opacity: LiqDatePickerField.disabledOpacity,
        child: IgnorePointer(child: trigger),
      );
    }
    return trigger;
  }

  Widget _buildOverlay(BuildContext context) {
    final width = _fieldWidth();
    return Stack(
      children: <Widget>[
        // Click-outside dismiss layer.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _close,
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            offset: const Offset(0, LiqDatePickerField.panelOffset),
            child: _AnimatedPanel(
              child: _DatePickerPanel(
                width: width,
                selectedDate: widget.value ?? DateTime.now(),
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onDateChanged: _handleDateChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedPanel extends StatefulWidget {
  const _AnimatedPanel({required this.child});

  final Widget child;

  @override
  State<_AnimatedPanel> createState() => _AnimatedPanelState();
}

class _AnimatedPanelState extends State<_AnimatedPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: LiqDatePickerField.animationDuration,
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: LiqMotion.standard,
    );
    _scale = Tween<double>(begin: 0.95, end: 1).animate(curved);
    _fade = Tween<double>(begin: 0, end: 1).animate(curved);
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = context.liqMotionDuration(LiqMotion.fast);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.scale(
            scale: _scale.value,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _DatePickerPanel extends StatelessWidget {
  const _DatePickerPanel({
    required this.width,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
  });

  final double width;
  final DateTime selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width > 0 ? width : null,
      child: LiqGlassSurface(
        // Opaque path — the calendar inside renders day numbers, and
        // the surrounding trigger pill renders the formatted date right
        // above; the shader path would ghost both into the popover.
        tint: LiqGlassTint.opaque,
        borderRadius: BorderRadius.circular(LiqDatePickerField.panelRadius),
        padding: const EdgeInsets.all(LiqDatePickerField.panelPadding),
        child: LiqCalendar(
          selectedDate: selectedDate,
          firstDate: firstDate,
          lastDate: lastDate,
          onDateChanged: onDateChanged,
        ),
      ),
    );
  }
}

class _DatePickerFieldPalette {
  const _DatePickerFieldPalette({
    required this.background,
    required this.text,
    required this.placeholder,
    required this.chevron,
    required this.inactiveBorder,
    required this.activeBorder,
  });

  factory _DatePickerFieldPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _DatePickerFieldPalette(
        background: LiqDatePickerField.backgroundColor,
        text: LiqDatePickerField.textColor,
        placeholder: LiqDatePickerField.placeholderColor,
        chevron: LiqDatePickerField.chevronColor,
        inactiveBorder: LiqDatePickerField.inactiveBorderColor,
        activeBorder: LiqDatePickerField.activeBorderColor,
      );
    }

    final label = context.liqLabelColor;
    final secondary = context.liqSecondaryLabelColor;
    final surface = context.liqSurfaceColor;
    final accent = context.liqPrimaryColor;
    return _DatePickerFieldPalette(
      background: surface,
      text: label,
      placeholder: secondary.withValues(alpha: 0.48),
      chevron: secondary,
      inactiveBorder: secondary.withValues(alpha: 0.24),
      activeBorder: accent,
    );
  }

  final Color background;
  final Color text;
  final Color placeholder;
  final Color chevron;
  final Color inactiveBorder;
  final Color activeBorder;
}
