import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Immutable hour/minute pair consumed by [LiqTimeField].
///
/// [hour] is in 24-hour form (`0..23`); [minute] is `0..59`.
@immutable
final class LiqTime {
  /// Creates a time. Asserts `0 <= hour < 24` and `0 <= minute < 60`.
  const LiqTime({required this.hour, required this.minute})
    : assert(hour >= 0 && hour < 24, 'hour must be in [0, 24)'),
      assert(minute >= 0 && minute < 60, 'minute must be in [0, 60)');

  /// Creates a [LiqTime] from a [DateTime], extracting only `hour`/`minute`.
  factory LiqTime.fromDateTime(DateTime dateTime) =>
      LiqTime(hour: dateTime.hour, minute: dateTime.minute);

  /// Hour in 24-hour form.
  final int hour;

  /// Minute, `0..59`.
  final int minute;

  /// Returns a [DateTime] on the same calendar day as [base] but with this
  /// instance's [hour] and [minute].
  DateTime toDateTime(DateTime base) =>
      DateTime(base.year, base.month, base.day, hour, minute);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LiqTime && other.hour == hour && other.minute == minute);

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => 'LiqTime($hour:$minute)';
}

/// iOS 26 typeable HH:MM time input.
///
/// Distinct from `LiqTimePicker` (the wheel-style picker). The user types
/// digits directly and the field auto-formats with a colon separator. In
/// 12-hour mode, a small inset segmented AM/PM pill renders to the right
/// of the input and toggles the period.
///
/// Sourced from iOS 26 spec values:
///   - field 44pt height, 10pt corner radius, 1pt border #E5E5EA
///   - active border 1.5pt #007AFF
///   - SF semibold 17pt #1C1C1E, center-aligned
///   - placeholder #C7C7CC
///   - AM/PM segment 28pt tall, SF semibold 13pt, 6pt horizontal padding
///   - segment background #14000000 with 8pt radius; active fills white
final class LiqTimeField extends StatefulWidget {
  /// Creates a time field.
  const LiqTimeField({
    required this.value,
    required this.onChanged,
    this.use24HourFormat = false,
    this.placeholder,
    super.key,
  });

  /// Currently selected time, or null when empty.
  final LiqTime? value;

  /// Receives the parsed time on every valid edit.
  ///
  /// Fires with `null` when the user clears the field. Invalid intermediate
  /// inputs are swallowed and do not fire.
  ///
  /// When null, the field is rendered at 40% opacity and is non-interactive.
  final ValueChanged<LiqTime?>? onChanged;

  /// When true the field accepts/displays 24-hour input (`HH:MM`, `00..23`).
  /// When false (default) it accepts 12-hour input (`H:MM` or `HH:MM`,
  /// `1..12`) with a trailing AM/PM segmented pill.
  final bool use24HourFormat;

  /// Optional placeholder text. Defaults to `HH:MM` (24h) or `HH:MM AM` (12h).
  final String? placeholder;

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

  /// Focused border color.
  static const Color activeBorderColor = Color(0xFF007AFF);

  /// Field background color.
  static const Color backgroundColor = Color(0xFFFFFFFF);

  /// Primary text color.
  static const Color textColor = Color(0xFF1C1C1E);

  /// Placeholder text color.
  static const Color placeholderColor = Color(0xFFC7C7CC);

  /// Inactive AM/PM segment glyph color.
  static const Color segmentInactiveColor = Color(0xFF8E8E93);

  /// AM/PM segment pill background color.
  static const Color segmentBackgroundColor = Color(0x14000000);

  /// AM/PM segment pill corner radius.
  static const double segmentRadius = 8;

  /// AM/PM segment height.
  static const double segmentHeight = 28;

  /// AM/PM segment horizontal padding.
  static const double segmentHorizontalPadding = 6;

  /// Field horizontal padding.
  static const double horizontalPadding = 12;

  /// Opacity applied when [onChanged] is null.
  static const double disabledOpacity = 0.4;

  /// Default text style for the typed value.
  static const TextStyle textStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  /// Text style for the AM/PM segment label.
  static const TextStyle segmentTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  /// Shadow on the active AM/PM segment cell.
  static const BoxShadow activeSegmentShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4,
    offset: Offset(0, 1),
  );

  @override
  State<LiqTimeField> createState() => _LiqTimeFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<LiqTime?>('value', value, defaultValue: null))
      ..add(
        FlagProperty(
          'use24HourFormat',
          value: use24HourFormat,
          ifTrue: '24h',
          ifFalse: '12h',
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

/// AM/PM period for the 12-hour mode segment.
enum _Period { am, pm }

class _LiqTimeFieldState extends State<LiqTimeField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _suppressEmit = false;
  late _Period _period;

  @override
  void initState() {
    super.initState();
    _period = _periodFor(widget.value);
    _controller = TextEditingController(text: _formatValue(widget.value));
    _controller.addListener(_handleControllerChange);
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant LiqTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value ||
        widget.use24HourFormat != oldWidget.use24HourFormat) {
      final formatted = _formatValue(widget.value);
      if (formatted != _controller.text) {
        _suppressEmit = true;
        _controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
        _suppressEmit = false;
      }
      final next = _periodFor(widget.value);
      if (next != _period) {
        _period = next;
      }
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleControllerChange)
      ..dispose();
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  _Period _periodFor(LiqTime? time) {
    if (time == null) return _Period.am;
    return time.hour < 12 ? _Period.am : _Period.pm;
  }

  String _formatValue(LiqTime? time) {
    if (time == null) return '';
    if (widget.use24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
    }
    final h12 = _to12(time.hour);
    return '$h12:${time.minute.toString().padLeft(2, '0')}';
  }

  static int _to12(int hour24) {
    final mod = hour24 % 12;
    return mod == 0 ? 12 : mod;
  }

  void _handleFocusChange() => setState(() {});

  void _handleControllerChange() {
    if (_suppressEmit) return;
    final raw = _controller.text;

    // Auto-insert colon after the first two digits when missing.
    if (raw.length >= 3 && !raw.contains(':')) {
      final reshaped = '${raw.substring(0, 2)}:${raw.substring(2)}';
      _suppressEmit = true;
      _controller.value = TextEditingValue(
        text: reshaped,
        selection: TextSelection.collapsed(offset: reshaped.length),
      );
      _suppressEmit = false;
      // Fall through and parse the reshaped text immediately so a single
      // bulk `enterText('1432')` still emits onChanged.
      final parsed = _parse(reshaped);
      if (parsed != null) widget.onChanged?.call(parsed);
      return;
    }

    if (raw.isEmpty) {
      widget.onChanged?.call(null);
      return;
    }

    final parsed = _parse(raw);
    if (parsed == null) return;
    widget.onChanged?.call(parsed);
  }

  /// Parses [text] into a [LiqTime] in 24-hour form. Returns null when
  /// the text is incomplete or invalid for the current mode.
  LiqTime? _parse(String text) {
    final colonIdx = text.indexOf(':');
    if (colonIdx < 0) return null;
    final hStr = text.substring(0, colonIdx);
    final mStr = text.substring(colonIdx + 1);
    if (hStr.isEmpty || mStr.isEmpty) return null;
    final h = int.tryParse(hStr);
    final m = int.tryParse(mStr);
    if (h == null || m == null) return null;
    if (m < 0 || m >= 60) return null;
    if (widget.use24HourFormat) {
      if (h < 0 || h >= 24) return null;
      return LiqTime(hour: h, minute: m);
    }
    if (h < 1 || h > 12) return null;
    final base = h % 12;
    final hour24 = _period == _Period.pm ? base + 12 : base;
    return LiqTime(hour: hour24, minute: m);
  }

  void _togglePeriod() {
    if (widget.onChanged == null) return;
    final next = _period == _Period.am ? _Period.pm : _Period.am;
    setState(() => _period = next);
    final v = widget.value;
    if (v == null) return;
    final shifted =
        next == _Period.pm
            ? (v.hour < 12 ? LiqTime(hour: v.hour + 12, minute: v.minute) : v)
            : (v.hour >= 12 ? LiqTime(hour: v.hour - 12, minute: v.minute) : v);
    if (shifted != v) {
      widget.onChanged?.call(shifted);
    }
  }

  String get _placeholder {
    if (widget.placeholder != null) return widget.placeholder!;
    return widget.use24HourFormat ? 'HH:MM' : 'HH:MM AM';
  }

  @override
  Widget build(BuildContext context) {
    final palette = _TimeFieldPalette.resolve(context);
    final disabled = widget.onChanged == null;
    final hasFocus = _focusNode.hasFocus;
    final borderColor = hasFocus ? palette.activeBorder : palette.border;

    final inputFormatters = <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp('[0-9:]')),
      LengthLimitingTextInputFormatter(5),
    ];

    final field = SizedBox(
      height: LiqTimeField.fieldHeight,
      child: LiqGlassSurface(
        baseFill: palette.background,
        rimColor: borderColor,
        borderRadius: BorderRadius.circular(LiqTimeField.fieldRadius),
        padding: const EdgeInsets.symmetric(
          horizontal: LiqTimeField.horizontalPadding,
        ),
        child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: disabled ? null : (_) => _focusNode.requestFocus(),
        child: Row(
          children: <Widget>[
            Expanded(
              child: CupertinoTextField.borderless(
                controller: _controller,
                focusNode: _focusNode,
                padding: EdgeInsets.zero,
                placeholder: _placeholder,
                placeholderStyle: LiqTimeField.textStyle.copyWith(
                  color: palette.placeholder,
                ),
                style: LiqTimeField.textStyle.copyWith(color: palette.text),
                cursorColor: palette.activeBorder,
                cursorRadius: const Radius.circular(1),
                keyboardType: TextInputType.datetime,
                inputFormatters: inputFormatters,
                textAlign: TextAlign.center,
                enableSuggestions: false,
                autocorrect: false,
              ),
            ),
            if (!widget.use24HourFormat) ...<Widget>[
              const SizedBox(width: 8),
              _PeriodSegment(period: _period, onToggle: _togglePeriod),
            ],
          ],
        ),
      ),
      ),
    );

    final wrapped = Semantics(
      textField: true,
      enabled: !disabled,
      value: _controller.text,
      child: field,
    );

    if (disabled) {
      return Opacity(
        opacity: LiqTimeField.disabledOpacity,
        child: IgnorePointer(child: wrapped),
      );
    }
    return wrapped;
  }
}

class _PeriodSegment extends StatelessWidget {
  const _PeriodSegment({required this.period, required this.onToggle});

  final _Period period;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final palette = _TimeFieldPalette.resolve(context);
    return SizedBox(
      height: LiqTimeField.fieldHeight,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: Center(
              child: SizedBox(
                width: 2 *
                    ((LiqTimeField.segmentHorizontalPadding * 2) +
                        _periodCellLabelWidth),
                height: LiqTimeField.segmentHeight,
                child: LiqGlassSurface(
                  baseFill: palette.segmentBackground,
                  borderRadius: BorderRadius.circular(
                    LiqTimeField.segmentRadius,
                  ),
                  padding: EdgeInsets.zero,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _PeriodCell(
                label: 'AM',
                isActive: period == _Period.am,
                onTap: period == _Period.am ? null : onToggle,
                palette: palette,
              ),
              _PeriodCell(
                label: 'PM',
                isActive: period == _Period.pm,
                onTap: period == _Period.pm ? null : onToggle,
                palette: palette,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodCell extends StatelessWidget {
  const _PeriodCell({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.palette,
  });

  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  final _TimeFieldPalette palette;

  @override
  Widget build(BuildContext context) {
    return LiqPointerCursor(
      enabled: onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: LiqTimeField.fieldHeight,
          width:
              (LiqTimeField.segmentHorizontalPadding * 2) +
              _periodCellLabelWidth,
          child: Center(
            child: Container(
              height: LiqTimeField.segmentHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    isActive
                        ? palette.segmentActiveBackground
                        : const Color(0x00000000),
                borderRadius: BorderRadius.circular(LiqTimeField.segmentRadius),
                boxShadow:
                    isActive
                        ? const <BoxShadow>[LiqTimeField.activeSegmentShadow]
                        : null,
              ),
              child: Text(
                label,
                style: LiqTimeField.segmentTextStyle.copyWith(
                  color: isActive ? palette.text : palette.segmentInactive,
                ),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const double _periodCellLabelWidth = 22;

final class _TimeFieldPalette {
  const _TimeFieldPalette({
    required this.background,
    required this.text,
    required this.placeholder,
    required this.border,
    required this.activeBorder,
    required this.segmentBackground,
    required this.segmentActiveBackground,
    required this.segmentInactive,
  });

  factory _TimeFieldPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _TimeFieldPalette(
        background: LiqTimeField.backgroundColor,
        text: LiqTimeField.textColor,
        placeholder: LiqTimeField.placeholderColor,
        border: LiqTimeField.inactiveBorderColor,
        activeBorder: LiqTimeField.activeBorderColor,
        segmentBackground: LiqTimeField.segmentBackgroundColor,
        segmentActiveBackground: LiqTimeField.backgroundColor,
        segmentInactive: LiqTimeField.segmentInactiveColor,
      );
    }

    final secondary = context.liqSecondaryLabelColor;
    return _TimeFieldPalette(
      background: context.liqSurfaceColor,
      text: context.liqLabelColor,
      placeholder: secondary.withValues(alpha: 0.48),
      border: secondary.withValues(alpha: 0.24),
      activeBorder: context.liqPrimaryColor,
      segmentBackground: secondary.withValues(alpha: 0.16),
      segmentActiveBackground:
          context.liqIsDark ? const Color(0xFF1C1C1E) : context.liqSurfaceColor,
      segmentInactive: secondary,
    );
  }

  final Color background;
  final Color text;
  final Color placeholder;
  final Color border;
  final Color activeBorder;
  final Color segmentBackground;
  final Color segmentActiveBackground;
  final Color segmentInactive;
}
