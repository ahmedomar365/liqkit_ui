import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_editable_text_run.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_separator.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Inline character format applied to a span of text inside
/// [LiqRichEditor].
///
/// Block-level formats (lists, headings, links) are intentionally out
/// of scope for v1.
enum LiqRichFormat {
  /// Renders the span with [FontWeight.w700].
  bold,

  /// Renders the span with [FontStyle.italic].
  italic,

  /// Renders the span with [TextDecoration.underline].
  underline,
}

/// A formatted span `[start, end)` inside a [LiqRichValue]'s plain text.
///
/// Multiple ranges may overlap — each enabled format is its own range.
@immutable
final class LiqRichRange with Diagnosticable {
  /// Creates a formatted range.
  const LiqRichRange({
    required this.start,
    required this.end,
    required this.format,
  }) : assert(start >= 0, 'start must be non-negative'),
       assert(end >= start, 'end must be >= start');

  /// Inclusive start index (UTF-16 code unit offset).
  final int start;

  /// Exclusive end index (UTF-16 code unit offset).
  final int end;

  /// The character format applied to this span.
  final LiqRichFormat format;

  /// Returns a new range with selected fields overridden.
  LiqRichRange copyWith({int? start, int? end, LiqRichFormat? format}) {
    return LiqRichRange(
      start: start ?? this.start,
      end: end ?? this.end,
      format: format ?? this.format,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LiqRichRange &&
        other.start == start &&
        other.end == end &&
        other.format == format;
  }

  @override
  int get hashCode => Object.hash(start, end, format);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('start', start))
      ..add(IntProperty('end', end))
      ..add(EnumProperty<LiqRichFormat>('format', format));
  }
}

/// Immutable value model for [LiqRichEditor].
///
/// Holds the editor's plain [text] plus a list of [ranges] describing
/// which substrings carry which formats.
@immutable
final class LiqRichValue with Diagnosticable {
  /// Creates a rich value.
  const LiqRichValue({this.text = '', this.ranges = const <LiqRichRange>[]});

  /// Plain text. Always identical to what `EditableText` displays.
  final String text;

  /// Ordered list of formatted ranges over [text].
  final List<LiqRichRange> ranges;

  /// Returns a new value with selected fields overridden.
  LiqRichValue copyWith({String? text, List<LiqRichRange>? ranges}) {
    return LiqRichValue(text: text ?? this.text, ranges: ranges ?? this.ranges);
  }

  @override
  bool operator ==(Object other) {
    return other is LiqRichValue &&
        other.text == text &&
        listEquals(other.ranges, ranges);
  }

  @override
  int get hashCode => Object.hash(text, Object.hashAll(ranges));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('textLength', text.length))
      ..add(IntProperty('rangesCount', ranges.length));
  }
}

/// Owns the [LiqRichEditor]'s state — exposes the current [LiqRichValue]
/// and lets callers toggle formats on a [TextSelection].
///
/// Attach the same controller to a [LiqRichEditor] and listen on it to
/// observe changes.
final class LiqRichEditorController extends ChangeNotifier {
  /// Creates a rich-editor controller seeded with [value].
  LiqRichEditorController({LiqRichValue value = const LiqRichValue()})
    : _value = _normalize(value);

  LiqRichValue _value;

  /// The current value.
  LiqRichValue get value => _value;
  set value(LiqRichValue next) {
    final normalized = _normalize(next);
    if (normalized == _value) return;
    _value = normalized;
    notifyListeners();
  }

  /// Toggles [format] on the substring covered by [selection].
  ///
  /// If the entire selection is already covered, the format is removed
  /// (existing ranges are split or shrunk to drop coverage). Otherwise
  /// a new range covering the selection is added and merged with any
  /// adjacent same-format ranges.
  void toggleFormat(LiqRichFormat format, TextSelection selection) {
    if (!selection.isValid || selection.isCollapsed) return;
    final start = selection.start.clamp(0, _value.text.length);
    final end = selection.end.clamp(0, _value.text.length);
    if (end <= start) return;
    final hasIt = _selectionFullyCovers(format, start, end);
    final next =
        hasIt
            ? _removeRange(format, start, end)
            : _addRange(format, start, end);
    value = _value.copyWith(ranges: next);
  }

  /// Returns true iff every offset in [selection] is covered by some
  /// range of [format].
  bool selectionHasFormat(LiqRichFormat format, TextSelection selection) {
    if (!selection.isValid || selection.isCollapsed) return false;
    final start = selection.start.clamp(0, _value.text.length);
    final end = selection.end.clamp(0, _value.text.length);
    if (end <= start) return false;
    return _selectionFullyCovers(format, start, end);
  }

  bool _selectionFullyCovers(LiqRichFormat format, int start, int end) {
    final covers =
        _value.ranges
            .where((r) => r.format == format)
            .map((r) => <int>[r.start, r.end])
            .toList();
    if (covers.isEmpty) return false;
    covers.sort((a, b) => a[0].compareTo(b[0]));
    var cursor = start;
    for (final span in covers) {
      if (span[1] <= cursor) continue;
      if (span[0] > cursor) return false;
      cursor = span[1];
      if (cursor >= end) return true;
    }
    return cursor >= end;
  }

  List<LiqRichRange> _addRange(LiqRichFormat format, int start, int end) {
    final result = <LiqRichRange>[];
    var newStart = start;
    var newEnd = end;
    for (final r in _value.ranges) {
      if (r.format != format) {
        result.add(r);
        continue;
      }
      // Same format — merge if overlapping or adjacent.
      if (r.end < newStart || r.start > newEnd) {
        result.add(r);
      } else {
        newStart = newStart < r.start ? newStart : r.start;
        newEnd = newEnd > r.end ? newEnd : r.end;
      }
    }
    result.add(LiqRichRange(start: newStart, end: newEnd, format: format));
    return _sorted(result);
  }

  List<LiqRichRange> _removeRange(LiqRichFormat format, int start, int end) {
    final result = <LiqRichRange>[];
    for (final r in _value.ranges) {
      if (r.format != format) {
        result.add(r);
        continue;
      }
      if (r.end <= start || r.start >= end) {
        // No overlap with the removal window.
        result.add(r);
        continue;
      }
      // Overlap — keep the parts that fall outside [start, end).
      if (r.start < start) {
        result.add(r.copyWith(end: start));
      }
      if (r.end > end) {
        result.add(r.copyWith(start: end));
      }
    }
    return _sorted(result);
  }

  static List<LiqRichRange> _sorted(List<LiqRichRange> ranges) {
    final list = <LiqRichRange>[...ranges]..sort((a, b) {
      final byStart = a.start.compareTo(b.start);
      if (byStart != 0) return byStart;
      return a.format.index.compareTo(b.format.index);
    });
    return List<LiqRichRange>.unmodifiable(list);
  }

  static LiqRichValue _normalize(LiqRichValue v) {
    final length = v.text.length;
    final clipped = <LiqRichRange>[];
    for (final r in v.ranges) {
      final s = r.start.clamp(0, length);
      final e = r.end.clamp(0, length);
      if (e <= s) continue;
      clipped.add(LiqRichRange(start: s, end: e, format: r.format));
    }
    return LiqRichValue(text: v.text, ranges: _sorted(clipped));
  }
}

/// iOS 26 inline rich-text editor.
///
/// Renders a 3-button toolbar (Bold / Italic / Underline) above an
/// editable area. Block formats and links are out of scope for v1.
final class LiqRichEditor extends StatefulWidget {
  /// Creates a rich editor bound to [controller].
  const LiqRichEditor({
    required this.controller,
    this.placeholder = 'Type here…',
    this.minLines = 3,
    this.maxLines = 10,
    super.key,
  });

  /// Controller that owns the editor's value + format ranges.
  final LiqRichEditorController controller;

  /// Placeholder shown when the controller's text is empty.
  final String placeholder;

  /// Minimum number of visible lines for the editable area.
  final int minLines;

  /// Maximum number of visible lines for the editable area.
  final int maxLines;

  /// Outer-surface corner radius.
  static const double surfaceRadius = 12;

  /// Outer-surface border colour.
  static const Color surfaceBorder = Color(0xFFE5E5EA);

  /// Outer-surface border width.
  static const double surfaceBorderWidth = 1;

  /// Outer-surface fill.
  static const Color surfaceBackground = Color(0xFFFFFFFF);

  /// Toolbar-row height.
  static const double toolbarHeight = 44;

  /// Toolbar horizontal padding.
  static const double toolbarHorizontalPadding = 12;

  /// Toolbar bottom-divider colour.
  static const Color toolbarDivider = Color(0x29000000);

  /// Toolbar bottom-divider thickness.
  static const double toolbarDividerThickness = 0.33;

  /// Toolbar button square size.
  static const double buttonSize = 32;

  /// Minimum toolbar button tap target.
  static const double buttonTapTargetSize = 44;

  /// Toolbar button corner radius.
  static const double buttonRadius = 8;

  /// Toolbar button background when the format is active on the
  /// current selection.
  static const Color buttonActiveBackground = Color(0xFFE5E5EA);

  /// Glyph size on each toolbar button.
  static const double buttonIconSize = 16;

  /// Glyph colour on each toolbar button.
  static const Color buttonIconColor = Color(0xFF1C1C1E);

  /// Horizontal gap between toolbar buttons.
  static const double buttonGap = 8;

  /// Padding around the editable area.
  static const double editorPadding = 12;

  /// Editable-area text colour.
  static const Color textColor = Color(0xFF1C1C1E);

  /// Editable-area cursor colour.
  static const Color cursorColor = Color(0xFF007AFF);

  /// Editable-area selection highlight.
  static const Color selectionColor = Color(0x33007AFF);

  /// Placeholder colour when the editor is empty.
  static const Color placeholderColor = Color(0xFFC7C7CC);

  /// Editor font size.
  static const double fontSize = 15;

  static const String _fontFamily = 'SF Pro Text';
  static const List<String> _fontFamilyFallback = <String>[
    'SF Pro',
    'sans-serif',
  ];

  /// Base text style for the editable area — exposed for tests.
  static const TextStyle baseTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: fontSize,
    height: 1.35,
    color: textColor,
  );

  /// Placeholder text style — exposed for tests.
  static const TextStyle placeholderTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: fontSize,
    height: 1.35,
    color: placeholderColor,
  );

  @override
  State<LiqRichEditor> createState() => _LiqRichEditorState();
}

class _LiqRichEditorState extends State<LiqRichEditor> {
  late final _RichTextEditingController _editingController;
  late final FocusNode _focusNode;
  bool _suppressTextSync = false;

  @override
  void initState() {
    super.initState();
    _editingController =
        _RichTextEditingController(state: () => this)
          ..text = widget.controller.value.text
          ..addListener(_handleEditingControllerChanged);
    _focusNode = FocusNode();
    widget.controller.addListener(_handleRichControllerChanged);
  }

  @override
  void didUpdateWidget(LiqRichEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller.removeListener(_handleRichControllerChanged);
      widget.controller.addListener(_handleRichControllerChanged);
      _suppressTextSync = true;
      _editingController.text = widget.controller.value.text;
      _suppressTextSync = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleRichControllerChanged);
    _editingController
      ..removeListener(_handleEditingControllerChanged)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleRichControllerChanged() {
    final richText = widget.controller.value.text;
    if (_editingController.text != richText) {
      _suppressTextSync = true;
      final selection = _editingController.selection;
      _editingController.value = TextEditingValue(
        text: richText,
        selection:
            selection.isValid && selection.end <= richText.length
                ? selection
                : TextSelection.collapsed(offset: richText.length),
      );
      _suppressTextSync = false;
    } else {
      // Force a TextSpan rebuild when only ranges changed.
      setState(() {});
    }
  }

  void _handleEditingControllerChanged() {
    if (_suppressTextSync) {
      setState(() {});
      return;
    }
    final newText = _editingController.text;
    final oldText = widget.controller.value.text;
    if (newText == oldText) {
      // Selection-only change — just rebuild for active-state highlights.
      setState(() {});
      return;
    }
    final shifted = _shiftRanges(
      widget.controller.value.ranges,
      oldText,
      newText,
    );
    widget.controller.value = LiqRichValue(text: newText, ranges: shifted);
  }

  List<LiqRichRange> _shiftRanges(
    List<LiqRichRange> ranges,
    String oldText,
    String newText,
  ) {
    if (ranges.isEmpty) return ranges;
    // Compute a single (commonStart, oldEnd, newEnd) edit window.
    final oldLen = oldText.length;
    final newLen = newText.length;
    var commonStart = 0;
    final minLen = oldLen < newLen ? oldLen : newLen;
    while (commonStart < minLen &&
        oldText.codeUnitAt(commonStart) == newText.codeUnitAt(commonStart)) {
      commonStart += 1;
    }
    var commonEndOld = oldLen;
    var commonEndNew = newLen;
    while (commonEndOld > commonStart &&
        commonEndNew > commonStart &&
        oldText.codeUnitAt(commonEndOld - 1) ==
            newText.codeUnitAt(commonEndNew - 1)) {
      commonEndOld -= 1;
      commonEndNew -= 1;
    }
    final removedLen = commonEndOld - commonStart;
    final insertedLen = commonEndNew - commonStart;
    final delta = insertedLen - removedLen;
    if (delta == 0 && removedLen == 0) return ranges;

    final result = <LiqRichRange>[];
    for (final r in ranges) {
      // Delete window fully consumes the range.
      if (commonStart <= r.start && commonEndOld >= r.end && removedLen > 0) {
        // Range entirely removed: drop it and re-add insertion-shift
        // skipped — so just shift if range starts at the deletion edge.
        // The clean approach: keep no part.
        continue;
      }

      var s = r.start;
      var e = r.end;

      // Adjust start.
      if (s >= commonEndOld) {
        s += delta;
      } else if (s > commonStart) {
        // Inside the edit window — collapse to commonStart.
        s = commonStart;
      }

      // Adjust end.
      if (e > commonEndOld) {
        e += delta;
      } else if (e > commonStart) {
        // Inside the edit window — clip to commonStart + insertedLen.
        e = commonStart + insertedLen;
      }

      // Clamp to new bounds.
      if (s < 0) s = 0;
      if (e > newLen) e = newLen;
      if (e <= s) continue;
      result.add(LiqRichRange(start: s, end: e, format: r.format));
    }
    return result;
  }

  bool _isFormatActive(LiqRichFormat format) {
    final sel = _editingController.selection;
    return widget.controller.selectionHasFormat(format, sel);
  }

  void _toggleFormat(LiqRichFormat format) {
    final sel = _editingController.selection;
    if (!sel.isValid || sel.isCollapsed) return;
    widget.controller.toggleFormat(format, sel);
  }

  @override
  Widget build(BuildContext context) {
    final palette =
        context.liqIsDark
            ? const _RichEditorPalette.dark()
            : const _RichEditorPalette.light();
    return LiqGlassSurface(
      baseFill: palette.surfaceBackground,
      rimColor: palette.surfaceBorder,
      borderRadius: const BorderRadius.all(
        Radius.circular(LiqRichEditor.surfaceRadius),
      ),
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[_buildToolbar(palette), _buildEditableArea(palette)],
      ),
    );
  }

  Widget _buildToolbar(_RichEditorPalette palette) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: palette.toolbarDivider,
            width: LiqRichEditor.toolbarDividerThickness,
          ),
        ),
      ),
      child: SizedBox(
        height: LiqRichEditor.toolbarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LiqRichEditor.toolbarHorizontalPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _ToolbarButton(
                semanticLabel: 'Bold',
                icon: LucideIcons.bold,
                isActive: _isFormatActive(LiqRichFormat.bold),
                palette: palette,
                onPressed: () => _toggleFormat(LiqRichFormat.bold),
              ),
              const SizedBox(width: LiqRichEditor.buttonGap),
              _ToolbarButton(
                semanticLabel: 'Italic',
                icon: LucideIcons.italic,
                isActive: _isFormatActive(LiqRichFormat.italic),
                palette: palette,
                onPressed: () => _toggleFormat(LiqRichFormat.italic),
              ),
              const SizedBox(width: LiqRichEditor.buttonGap),
              _ToolbarButton(
                semanticLabel: 'Underline',
                icon: LucideIcons.underline,
                isActive: _isFormatActive(LiqRichFormat.underline),
                palette: palette,
                onPressed: () => _toggleFormat(LiqRichFormat.underline),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableArea(_RichEditorPalette palette) {
    final baseStyle = LiqRichEditor.baseTextStyle.copyWith(color: palette.text);
    return Padding(
      padding: const EdgeInsets.all(LiqRichEditor.editorPadding),
      child: LiqEditableTextRun(
        controller: _editingController,
        focusNode: _focusNode,
        placeholder: widget.placeholder,
        placeholderStyle: LiqRichEditor.placeholderTextStyle.copyWith(
          color: palette.placeholder,
        ),
        style: baseStyle,
        cursorColor: LiqRichEditor.cursorColor,
        backgroundCursorColor: palette.placeholder,
        cursorRadius: const Radius.circular(1),
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('textLength', widget.controller.value.text.length))
      ..add(IntProperty('rangesCount', widget.controller.value.ranges.length))
      ..add(StringProperty('placeholder', widget.placeholder));
  }
}

final class _RichEditorPalette {
  const _RichEditorPalette({
    required this.surfaceBorder,
    required this.surfaceBackground,
    required this.toolbarDivider,
    required this.buttonActiveBackground,
    required this.buttonIcon,
    required this.text,
    required this.placeholder,
  });

  const _RichEditorPalette.light()
    : surfaceBorder = LiqRichEditor.surfaceBorder,
      surfaceBackground = LiqRichEditor.surfaceBackground,
      toolbarDivider = LiqRichEditor.toolbarDivider,
      buttonActiveBackground = LiqRichEditor.buttonActiveBackground,
      buttonIcon = LiqRichEditor.buttonIconColor,
      text = LiqRichEditor.textColor,
      placeholder = LiqRichEditor.placeholderColor;

  const _RichEditorPalette.dark()
    : surfaceBorder = LiqSeparator.dark,
      surfaceBackground = const Color(0x1FFFFFFF),
      toolbarDivider = LiqSeparator.dark,
      buttonActiveBackground = const Color(0x29FFFFFF),
      buttonIcon = const Color(0xFFF5F5F7),
      text = const Color(0xFFF5F5F7),
      placeholder = const Color(0xFF8E8E93);

  final Color surfaceBorder;
  final Color surfaceBackground;
  final Color toolbarDivider;
  final Color buttonActiveBackground;
  final Color buttonIcon;
  final Color text;
  final Color placeholder;
}

class _RichTextEditingController extends TextEditingController {
  _RichTextEditingController({required this.state});

  final _LiqRichEditorState Function() state;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final s = state();
    final ranges = s.widget.controller.value.ranges;
    final base = style ?? LiqRichEditor.baseTextStyle;
    if (text.isEmpty) {
      return TextSpan(text: '', style: base);
    }
    return TextSpan(style: base, children: _buildSpans(text, ranges, base));
  }
}

List<InlineSpan> _buildSpans(
  String text,
  List<LiqRichRange> ranges,
  TextStyle base,
) {
  if (ranges.isEmpty) {
    return <InlineSpan>[TextSpan(text: text, style: base)];
  }
  // Build a list of "boundaries" where formatting changes.
  final boundaries = <int>{0, text.length};
  for (final r in ranges) {
    boundaries
      ..add(r.start.clamp(0, text.length))
      ..add(r.end.clamp(0, text.length));
  }
  final sortedBoundaries = boundaries.toList()..sort();
  final spans = <InlineSpan>[];
  for (var i = 0; i < sortedBoundaries.length - 1; i++) {
    final start = sortedBoundaries[i];
    final end = sortedBoundaries[i + 1];
    if (end <= start) continue;
    final activeFormats = <LiqRichFormat>{};
    for (final r in ranges) {
      if (r.start <= start && r.end >= end) {
        activeFormats.add(r.format);
      }
    }
    spans.add(
      TextSpan(
        text: text.substring(start, end),
        style: _styleFor(base, activeFormats),
      ),
    );
  }
  return spans;
}

TextStyle _styleFor(TextStyle base, Set<LiqRichFormat> formats) {
  var style = base;
  if (formats.contains(LiqRichFormat.bold)) {
    style = style.copyWith(fontWeight: FontWeight.w700);
  }
  if (formats.contains(LiqRichFormat.italic)) {
    style = style.copyWith(fontStyle: FontStyle.italic);
  }
  if (formats.contains(LiqRichFormat.underline)) {
    style = style.copyWith(decoration: TextDecoration.underline);
  }
  return style;
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.semanticLabel,
    required this.icon,
    required this.isActive,
    required this.palette,
    required this.onPressed,
  });

  final String semanticLabel;
  final IconData icon;
  final bool isActive;
  final _RichEditorPalette palette;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      selected: isActive,
      child: LiqPointerCursor(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: SizedBox(
            width: LiqRichEditor.buttonTapTargetSize,
            height: LiqRichEditor.buttonTapTargetSize,
            child: Center(
              child: Container(
                width: LiqRichEditor.buttonSize,
                height: LiqRichEditor.buttonSize,
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? palette.buttonActiveBackground
                          : const Color(0x00000000),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(LiqRichEditor.buttonRadius),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: LiqRichEditor.buttonIconSize,
                  color: palette.buttonIcon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
