import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// One row inside a [LiqCommandPalette].
///
/// A command is a label + callback, optionally tagged with a leading
/// icon, a trailing keyboard hint, extra fuzzy-search keywords, and a
/// section heading used to group related commands together.
final class LiqCommand with Diagnosticable {
  /// Creates a command palette row.
  const LiqCommand({
    required this.label,
    required this.onSelected,
    this.icon,
    this.shortcut,
    this.keywords = const <String>[],
    this.section,
  });

  /// Visible label for this command.
  final String label;

  /// Invoked when the user selects this command — either by tapping the
  /// row or by pressing Enter while it is the active row.
  final VoidCallback onSelected;

  /// Optional leading icon.
  final IconData? icon;

  /// Short keyboard hint (e.g. `⌘N`) rendered as a trailing pill on the
  /// row.
  final String? shortcut;

  /// Additional terms beyond [label] used by the fuzzy filter.
  final List<String> keywords;

  /// Optional grouping label. Commands sharing a section are rendered
  /// under a single header.
  final String? section;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(StringProperty('section', section, defaultValue: null))
      ..add(StringProperty('shortcut', shortcut, defaultValue: null))
      ..add(IntProperty('keywordsCount', keywords.length));
  }
}

/// iOS 26 Spotlight-style command palette — a large rounded floating
/// panel with a search field on top and a list of matching commands
/// underneath.
///
/// Designed to be presented modally via [LiqCommandPalette.show] over a
/// dimmed scrim, but can also be embedded directly for tests and
/// previews.
final class LiqCommandPalette extends StatefulWidget {
  /// Creates the palette body.
  const LiqCommandPalette({
    required this.commands,
    this.placeholder = 'Type a command…',
    this.maxHeight = 480,
    super.key,
  });

  /// Commands to surface, in display order.
  final List<LiqCommand> commands;

  /// Placeholder text shown in the search field while empty.
  final String placeholder;

  /// Maximum total panel height. The command list takes whatever is
  /// left after the search field height.
  final double maxHeight;

  /// Outer panel maximum width.
  static const double maxWidth = 560;

  /// Outer panel corner radius.
  static const double radius = 34;

  /// Outer panel background fill.
  static const Color backgroundColor = LiqGlassSurface.lightTintBase;

  /// Dark-mode panel background fill.
  static const Color darkBackgroundColor = LiqGlassSurface.darkTintBase;

  /// Light-mode glass rim.
  static const Color rimColor = LiqGlassSurface.lightRimColor;

  /// Dark-mode glass rim.
  static const Color darkRimColor = LiqGlassSurface.darkRimColor;

  /// Light-mode top glass highlight.
  static const Color highlightColor = LiqGlassSurface.lightHighlightStart;

  /// Dark-mode top glass highlight.
  static const Color darkHighlightColor = LiqGlassSurface.darkHighlightStart;

  /// Outer panel drop shadow.
  static const BoxShadow shadow = BoxShadow(
    color: Color(0x33000000),
    offset: Offset(0, 12),
    blurRadius: 32,
  );

  /// Dark-mode panel drop shadow.
  static const BoxShadow darkShadow = BoxShadow(
    color: Color(0x6B000000),
    offset: Offset(0, 18),
    blurRadius: 34,
  );

  /// Search field height.
  static const double searchFieldHeight = 56;

  /// Horizontal padding inside the search field.
  static const double searchFieldHorizontalPadding = 16;

  /// Search-field leading magnifying-glass icon size.
  static const double searchIconSize = 20;

  /// Search-field trailing close-button icon size.
  static const double clearIconSize = 18;

  /// Hairline color used between the search field and the rows, and
  /// between rows themselves.
  static const Color hairlineColor = Color(0x29000000);

  /// Hairline thickness.
  static const double hairlineWidth = 0.33;

  /// Per-row height.
  static const double rowHeight = 44;

  /// Horizontal padding inside a row.
  static const double rowHorizontalPadding = 16;

  /// Row icon size.
  static const double rowIconSize = 18;

  /// Padding between leading icon and label.
  static const double iconLabelGap = 12;

  /// Active-row background fill.
  static const Color activeRowBackgroundColor = Color(0xFFE5E5EA);

  /// Section header minimum height.
  static const double sectionHeaderMinHeight = 32;

  /// Empty-state vertical padding.
  static const double emptyStateVerticalPadding = 32;

  /// Animation duration for the show/hide transition.
  static const Duration animationDuration = LiqMotion.fast;

  /// Animation curve for the show/hide transition.
  static const Curve animationCurve = LiqMotion.standard;

  /// Default scrim color used by [LiqCommandPalette.show].
  static const Color defaultScrimColor = Color(0x66000000);

  /// Top padding used when [show] aligns the palette near the top edge,
  /// Spotlight-style.
  static const double topAlignmentPadding = 64;

  /// Primary label color (rows, search-field input).
  static const Color labelColor = Color(0xFF1C1C1E);

  /// Tertiary text color (placeholder, hints, empty state).
  static const Color tertiaryColor = Color(0xFF8E8E93);

  /// Shortcut pill background.
  static const Color shortcutBackgroundColor = Color(0xFFE5E5EA);

  /// Shortcut pill corner radius.
  static const double shortcutRadius = 4;

  /// Search-field input text style.
  static const TextStyle searchTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: labelColor,
  );

  /// Row label text style.
  static const TextStyle labelStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: labelColor,
  );

  /// Section header text style.
  static const TextStyle sectionHeaderStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: tertiaryColor,
    letterSpacing: 0.5,
  );

  /// Trailing shortcut pill text style.
  static const TextStyle shortcutStyle = TextStyle(
    fontFamily: 'SF Mono',
    fontFamilyFallback: <String>['Menlo', 'monospace'],
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: tertiaryColor,
  );

  /// Empty-state text style.
  static const TextStyle emptyStateStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: tertiaryColor,
  );

  /// Imperative helper — shows the palette over the nearest [Overlay],
  /// dims the background with [scrimColor], and dismisses on Escape or
  /// scrim tap. The returned [Future] completes once the palette has
  /// finished its dismiss animation.
  static Future<void> show({
    required BuildContext context,
    required List<LiqCommand> commands,
    String placeholder = 'Type a command…',
    Color scrimColor = defaultScrimColor,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = _LiqCommandPaletteEntry(
      overlay: overlay,
      commands: commands,
      placeholder: placeholder,
      scrimColor: scrimColor,
    );
    return entry.run();
  }

  @override
  State<LiqCommandPalette> createState() => _LiqCommandPaletteState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('commandsCount', commands.length))
      ..add(StringProperty('placeholder', placeholder))
      ..add(DoubleProperty('maxHeight', maxHeight));
  }
}

class _LiqCommandPaletteState extends State<LiqCommandPalette> {
  late final TextEditingController _controller;
  late final FocusNode _searchFocusNode;
  late final FocusNode _keyFocusNode;
  String _query = '';
  int _activeIndex = 0;
  late List<LiqCommand> _filtered;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleTextChanged);
    _searchFocusNode = FocusNode(debugLabel: 'LiqCommandPalette.search');
    _keyFocusNode = FocusNode(debugLabel: 'LiqCommandPalette.keys');
    _filtered = List<LiqCommand>.unmodifiable(widget.commands);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void didUpdateWidget(covariant LiqCommandPalette oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.commands, widget.commands)) {
      _filtered = _runFilter(_query, widget.commands);
      _activeIndex =
          _filtered.isEmpty ? 0 : _activeIndex.clamp(0, _filtered.length - 1);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleTextChanged)
      ..dispose();
    _searchFocusNode.dispose();
    _keyFocusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final next = _controller.text;
    if (next == _query) return;
    setState(() {
      _query = next;
      _filtered = _runFilter(_query, widget.commands);
      _activeIndex = 0;
    });
  }

  static List<LiqCommand> _runFilter(String query, List<LiqCommand> all) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return List<LiqCommand>.unmodifiable(all);
    }
    return all
        .where((LiqCommand cmd) {
          final haystack =
              '${cmd.label} ${cmd.keywords.join(' ')}'.toLowerCase();
          return haystack.contains(trimmed);
        })
        .toList(growable: false);
  }

  void _clearQuery() {
    _controller.clear();
    _searchFocusNode.requestFocus();
  }

  void _moveActive(int delta) {
    if (_filtered.isEmpty) return;
    setState(() {
      _activeIndex = (_activeIndex + delta) % _filtered.length;
      if (_activeIndex < 0) _activeIndex += _filtered.length;
    });
  }

  void _activateCurrent() {
    if (_filtered.isEmpty) return;
    final idx = _activeIndex.clamp(0, _filtered.length - 1);
    _filtered[idx].onSelected();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _moveActive(1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _moveActive(-1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _activateCurrent();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final palette = _CommandPalettePalette.resolve(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: LiqCommandPalette.maxWidth,
        maxHeight: widget.maxHeight,
      ),
      child: LiqGlassSurface(
        tint: context.liqIsDark ? LiqGlassTint.dark : LiqGlassTint.light,
        elevation: LiqGlassElevation.modal,
        borderRadius: const BorderRadius.all(
          Radius.circular(LiqCommandPalette.radius),
        ),
        blurSigma: 20,
        shadows:
            context.liqIsDark
                ? const <BoxShadow>[LiqCommandPalette.darkShadow]
                : const <BoxShadow>[LiqCommandPalette.shadow],
        child: Focus(
          focusNode: _keyFocusNode,
          onKeyEvent: _onKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _SearchField(
                controller: _controller,
                focusNode: _searchFocusNode,
                placeholder: widget.placeholder,
                palette: palette,
                showClear: _query.isNotEmpty,
                onClear: _clearQuery,
              ),
              _Hairline(palette: palette),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: (widget.maxHeight -
                            LiqCommandPalette.searchFieldHeight)
                        .clamp(0.0, double.infinity),
                  ),
                  child: _Results(
                    filtered: _filtered,
                    activeIndex: _activeIndex,
                    palette: palette,
                    onTap: (LiqCommand cmd, int index) {
                      setState(() => _activeIndex = index);
                      cmd.onSelected();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hairline extends StatelessWidget {
  const _Hairline({required this.palette});

  final _CommandPalettePalette palette;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: LiqCommandPalette.hairlineWidth,
      child: ColoredBox(color: palette.hairline),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.palette,
    required this.showClear,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final _CommandPalettePalette palette;
  final bool showClear;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: LiqCommandPalette.searchFieldHeight,
      child: Row(
        children: <Widget>[
          const SizedBox(width: LiqCommandPalette.searchFieldHorizontalPadding),
          Icon(
            Icons.search,
            size: LiqCommandPalette.searchIconSize,
            color: palette.tertiary,
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CupertinoTextField.borderless(
              controller: controller,
              focusNode: focusNode,
              padding: EdgeInsets.zero,
              placeholder: placeholder,
              placeholderStyle: LiqCommandPalette.searchTextStyle.copyWith(
                color: palette.tertiary,
              ),
              style: LiqCommandPalette.searchTextStyle.copyWith(
                color: palette.label,
              ),
              cursorColor: palette.label,
              cursorRadius: const Radius.circular(1),
              enableSuggestions: false,
              autocorrect: false,
            ),
          ),
          if (showClear) ...<Widget>[
            const SizedBox(width: 8),
            LiqPointerCursor(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClear,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.close,
                    size: LiqCommandPalette.clearIconSize,
                    color: palette.tertiary,
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(width: LiqCommandPalette.searchFieldHorizontalPadding),
        ],
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.filtered,
    required this.activeIndex,
    required this.palette,
    required this.onTap,
  });

  final List<LiqCommand> filtered;
  final int activeIndex;
  final _CommandPalettePalette palette;
  final void Function(LiqCommand command, int index) onTap;

  @override
  Widget build(BuildContext context) {
    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: LiqCommandPalette.emptyStateVerticalPadding,
        ),
        child: Center(
          child: Text(
            'No commands found',
            style: LiqCommandPalette.emptyStateStyle.copyWith(
              color: palette.tertiary,
            ),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          ),
        ),
      );
    }

    final entries = <_RenderEntry>[];
    String? lastSection;
    for (var i = 0; i < filtered.length; i++) {
      final cmd = filtered[i];
      if (cmd.section != null && cmd.section != lastSection) {
        entries.add(
          _RenderEntry.section(cmd.section!, isFirst: lastSection == null),
        );
        lastSection = cmd.section;
      } else if (cmd.section == null) {
        lastSection = null;
      }
      entries.add(_RenderEntry.command(cmd, i));
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int i) {
        final entry = entries[i];
        if (entry.isSection) {
          return _SectionHeader(label: entry.sectionLabel!, palette: palette);
        }
        final showDivider = i > 0 && !entries[i - 1].isSection;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (showDivider) _Hairline(palette: palette),
            _CommandRow(
              command: entry.command!,
              active: entry.commandIndex == activeIndex,
              palette: palette,
              onTap: () => onTap(entry.command!, entry.commandIndex!),
            ),
          ],
        );
      },
    );
  }
}

class _RenderEntry {
  _RenderEntry.section(String label, {required bool isFirst})
    : isSection = true,
      sectionLabel = label,
      sectionIsFirst = isFirst,
      command = null,
      commandIndex = null;

  _RenderEntry.command(LiqCommand cmd, int index)
    : isSection = false,
      sectionLabel = null,
      sectionIsFirst = false,
      command = cmd,
      commandIndex = index;

  final bool isSection;
  final String? sectionLabel;
  final bool sectionIsFirst;
  final LiqCommand? command;
  final int? commandIndex;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.palette});

  final String label;
  final _CommandPalettePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: LiqCommandPalette.sectionHeaderMinHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: LiqCommandPalette.rowHorizontalPadding,
      ),
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        label.toUpperCase(),
        style: LiqCommandPalette.sectionHeaderStyle.copyWith(
          color: palette.tertiary,
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

class _CommandRow extends StatelessWidget {
  const _CommandRow({
    required this.command,
    required this.active,
    required this.palette,
    required this.onTap,
  });

  final LiqCommand command;
  final bool active;
  final _CommandPalettePalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: command.label,
      child: LiqPointerCursor(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            height: LiqCommandPalette.rowHeight,
            color: active ? palette.activeRowBackground : null,
            padding: const EdgeInsets.symmetric(
              horizontal: LiqCommandPalette.rowHorizontalPadding,
            ),
            child: Row(
              children: <Widget>[
                if (command.icon != null) ...<Widget>[
                  Icon(
                    command.icon,
                    size: LiqCommandPalette.rowIconSize,
                    color: palette.label,
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(width: LiqCommandPalette.iconLabelGap),
                ],
                Expanded(
                  child: Text(
                    command.label,
                    style: LiqCommandPalette.labelStyle.copyWith(
                      color: palette.label,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                  ),
                ),
                if (command.shortcut != null) ...<Widget>[
                  const SizedBox(width: 8),
                  _ShortcutPill(text: command.shortcut!, palette: palette),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortcutPill extends StatelessWidget {
  const _ShortcutPill({required this.text, required this.palette});

  final String text;
  final _CommandPalettePalette palette;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.shortcutBackground,
        borderRadius: BorderRadius.circular(LiqCommandPalette.shortcutRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          text,
          style: LiqCommandPalette.shortcutStyle.copyWith(
            color: palette.tertiary,
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}

final class _CommandPalettePalette {
  const _CommandPalettePalette({
    required this.label,
    required this.tertiary,
    required this.hairline,
    required this.activeRowBackground,
    required this.shortcutBackground,
  });

  factory _CommandPalettePalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _CommandPalettePalette(
        label: LiqCommandPalette.labelColor,
        tertiary: LiqCommandPalette.tertiaryColor,
        hairline: LiqCommandPalette.hairlineColor,
        activeRowBackground: LiqCommandPalette.activeRowBackgroundColor,
        shortcutBackground: LiqCommandPalette.shortcutBackgroundColor,
      );
    }

    final secondary = context.liqSecondaryLabelColor;
    return _CommandPalettePalette(
      label: context.liqLabelColor,
      tertiary: secondary,
      hairline: secondary.withValues(alpha: 0.18),
      activeRowBackground: secondary.withValues(alpha: 0.14),
      shortcutBackground: secondary.withValues(alpha: 0.16),
    );
  }

  final Color label;
  final Color tertiary;
  final Color hairline;
  final Color activeRowBackground;
  final Color shortcutBackground;
}

class _LiqCommandPaletteEntry {
  _LiqCommandPaletteEntry({
    required this.overlay,
    required this.commands,
    required this.placeholder,
    required this.scrimColor,
  });

  final OverlayState overlay;
  final List<LiqCommand> commands;
  final String placeholder;
  final Color scrimColor;

  OverlayEntry? _entry;
  _LiqCommandPaletteBodyState? _state;
  final Completer<void> _done = Completer<void>();
  bool _dismissed = false;

  Future<void> run() {
    final wrapped = <LiqCommand>[
      for (final cmd in commands)
        LiqCommand(
          label: cmd.label,
          icon: cmd.icon,
          shortcut: cmd.shortcut,
          keywords: cmd.keywords,
          section: cmd.section,
          onSelected: () {
            cmd.onSelected();
            unawaited(dismiss());
          },
        ),
    ];

    final entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return _LiqCommandPaletteBody(
          commands: wrapped,
          placeholder: placeholder,
          scrimColor: scrimColor,
          onAttach: (state) => _state = state,
          onScrimTap: dismiss,
          onDismissed: () {
            if (!_done.isCompleted) {
              _done.complete();
            }
            _entry?.remove();
            _entry = null;
          },
        );
      },
    );
    _entry = entry;
    overlay.insert(entry);
    return _done.future;
  }

  Future<void> dismiss() async {
    if (_dismissed) return _done.future;
    _dismissed = true;
    final state = _state;
    if (state == null) {
      _entry?.remove();
      _entry = null;
      if (!_done.isCompleted) {
        _done.complete();
      }
      return;
    }
    await state.dismiss();
  }
}

class _LiqCommandPaletteBody extends StatefulWidget {
  const _LiqCommandPaletteBody({
    required this.commands,
    required this.placeholder,
    required this.scrimColor,
    required this.onAttach,
    required this.onScrimTap,
    required this.onDismissed,
  });

  final List<LiqCommand> commands;
  final String placeholder;
  final Color scrimColor;
  final void Function(_LiqCommandPaletteBodyState state) onAttach;
  final VoidCallback onScrimTap;
  final VoidCallback onDismissed;

  @override
  State<_LiqCommandPaletteBody> createState() => _LiqCommandPaletteBodyState();
}

class _LiqCommandPaletteBodyState extends State<_LiqCommandPaletteBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final FocusNode _focusNode = FocusNode(
    debugLabel: 'LiqCommandPalette.overlay',
  );
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: LiqCommandPalette.animationDuration,
    );
    widget.onAttach(this);
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    if (_dismissing) return;
    _dismissing = true;
    if (!mounted) {
      widget.onDismissed();
      return;
    }
    await _controller.reverse();
    if (!mounted) {
      widget.onDismissed();
      return;
    }
    widget.onDismissed();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      unawaited(dismiss());
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _handleScrimTap() {
    widget.onScrimTap();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: LiqCommandPalette.animationCurve,
      reverseCurve: LiqCommandPalette.animationCurve,
    );
    final scale = Tween<double>(begin: 0.95, end: 1).animate(curved);

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: AnimatedBuilder(
        animation: curved,
        builder: (BuildContext context, Widget? _) {
          final t = curved.value.clamp(0.0, 1.0);
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _handleScrimTap,
                  child: ColoredBox(
                    color: widget.scrimColor.withValues(
                      alpha: widget.scrimColor.a * t,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: LiqCommandPalette.topAlignmentPadding,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: t,
                    child: Transform.scale(
                      scale: scale.value,
                      child: LiqCommandPalette(
                        commands: widget.commands,
                        placeholder: widget.placeholder,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
