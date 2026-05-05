import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/foundation/liq_separator.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Default iOS saved swatches used by [LiqColorPickerPanel].
const List<Color> liqDefaultColorPickerColors = <Color>[
  Color(0xFF000000),
  Color(0xFF007AFF),
  Color(0xFF34C759),
  Color(0xFFFFCC00),
  Color(0xFFFF3B30),
  Color(0xFF7AC6F5),
  Color(0xFFAF52DE),
  Color(0xFF5856D6),
  Color(0xFFFF2D55),
];

/// Native iOS 26 12-column grid colors captured from the Figma artifact.
const List<Color> liqNativeColorGridColors = <Color>[
  Color(0xFFFEFFFE),
  Color(0xFFEBEBEB),
  Color(0xFFD6D6D6),
  Color(0xFFC2C2C2),
  Color(0xFFADADAD),
  Color(0xFF999999),
  Color(0xFF858585),
  Color(0xFF707070),
  Color(0xFF5C5C5C),
  Color(0xFF474747),
  Color(0xFF333333),
  Color(0xFF000000),
  Color(0xFF00374A),
  Color(0xFF011D57),
  Color(0xFF11053B),
  Color(0xFF2E063D),
  Color(0xFF3C071B),
  Color(0xFF5C0701),
  Color(0xFF5A1C00),
  Color(0xFF583300),
  Color(0xFF563D00),
  Color(0xFF666100),
  Color(0xFF4F5504),
  Color(0xFF263E0F),
  Color(0xFF004D65),
  Color(0xFF012F7B),
  Color(0xFF1A0A52),
  Color(0xFF450D59),
  Color(0xFF551029),
  Color(0xFF831100),
  Color(0xFF7B2900),
  Color(0xFF7A4A00),
  Color(0xFF785800),
  Color(0xFF8D8602),
  Color(0xFF6F760A),
  Color(0xFF38571A),
  Color(0xFF016E8F),
  Color(0xFF0042A9),
  Color(0xFF2C0977),
  Color(0xFF61187C),
  Color(0xFF791A3D),
  Color(0xFFB51A00),
  Color(0xFFAD3E00),
  Color(0xFFA96800),
  Color(0xFFA67B01),
  Color(0xFFC4BC00),
  Color(0xFF9BA50E),
  Color(0xFF4E7A27),
  Color(0xFF008CB4),
  Color(0xFF0056D6),
  Color(0xFF371A94),
  Color(0xFF7A219E),
  Color(0xFF99244F),
  Color(0xFFE22400),
  Color(0xFFDA5100),
  Color(0xFFD38301),
  Color(0xFFD19D01),
  Color(0xFFF5EC00),
  Color(0xFFC3D117),
  Color(0xFF669D34),
  Color(0xFF00A1D8),
  Color(0xFF0061FD),
  Color(0xFF4D22B2),
  Color(0xFF982ABC),
  Color(0xFFB92D5D),
  Color(0xFFFF4015),
  Color(0xFFFF6A00),
  Color(0xFFFFAB01),
  Color(0xFFFCC700),
  Color(0xFFFEFB41),
  Color(0xFFD9EC37),
  Color(0xFF76BB40),
  Color(0xFF01C7FC),
  Color(0xFF3A87FD),
  Color(0xFF5E30EB),
  Color(0xFFBE38F3),
  Color(0xFFE63B7A),
  Color(0xFFFE6250),
  Color(0xFFFE8648),
  Color(0xFFFEB43F),
  Color(0xFFFECB3E),
  Color(0xFFFFF76B),
  Color(0xFFE4EF65),
  Color(0xFF96D35F),
  Color(0xFF52D6FC),
  Color(0xFF74A7FF),
  Color(0xFF864FFD),
  Color(0xFFD357FE),
  Color(0xFFEE719E),
  Color(0xFFFF8C82),
  Color(0xFFFEA57D),
  Color(0xFFFEC777),
  Color(0xFFFED977),
  Color(0xFFFFF994),
  Color(0xFFEAF28F),
  Color(0xFFB1DD8B),
  Color(0xFF93E3FC),
  Color(0xFFA7C6FF),
  Color(0xFFB18CFE),
  Color(0xFFE292FE),
  Color(0xFFF4A4C0),
  Color(0xFFFFB5AF),
  Color(0xFFFFC5AB),
  Color(0xFFFED9A8),
  Color(0xFFFDE4A8),
  Color(0xFFFFFBB9),
  Color(0xFFF1F7B7),
  Color(0xFFCDE8B5),
  Color(0xFFCBF0FF),
  Color(0xFFD2E2FE),
  Color(0xFFD8C9FE),
  Color(0xFFEFCAFE),
  Color(0xFFF9D3E0),
  Color(0xFFFFDAD8),
  Color(0xFFFFE2D6),
  Color(0xFFFEECD4),
  Color(0xFFFEF1D5),
  Color(0xFFFDFBDD),
  Color(0xFFF6FADB),
  Color(0xFFDEEED4),
];

/// iOS 26 color picker composed from a hue-ring button and popover palette.
///
/// The picker owns its open/closed interaction while the selected [color] stays
/// controlled by the caller, matching other liqkit_ui input components.
final class LiqColorPicker extends StatefulWidget {
  /// Creates a color picker.
  const LiqColorPicker({
    required this.color,
    required this.onChanged,
    this.colors = liqDefaultColorPickerColors,
    this.buttonSize = LiqColorPickerButtonSize.large,
    this.onOpenChanged,
    super.key,
  });

  /// Currently selected color.
  final Color color;

  /// Called when the user selects a color from the palette.
  final ValueChanged<Color> onChanged;

  /// Palette colors.
  final List<Color> colors;

  /// Button visual size.
  final LiqColorPickerButtonSize buttonSize;

  /// Reports whether the popover is open.
  final ValueChanged<bool>? onOpenChanged;

  @override
  State<LiqColorPicker> createState() => _LiqColorPickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(EnumProperty<LiqColorPickerButtonSize>('buttonSize', buttonSize))
      ..add(ObjectFlagProperty<ValueChanged<Color>>.has('onChanged', onChanged))
      ..add(
        ObjectFlagProperty<ValueChanged<bool>?>.has(
          'onOpenChanged',
          onOpenChanged,
        ),
      );
  }
}

class _LiqColorPickerState extends State<LiqColorPicker> {
  bool _open = false;

  void _setOpen(bool open) {
    if (_open == open) return;
    setState(() => _open = open);
    widget.onOpenChanged?.call(open);
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = context.liqDisableAnimations;
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.hasBoundedHeight;
        final maxPanelHeight =
            hasBoundedHeight
                ? math.max<double>(
                  0,
                  constraints.maxHeight -
                      LiqColorPickerButton.tapTargetSize -
                      10,
                )
                : double.infinity;
        final panel = AnimatedSwitcher(
          duration: context.liqMotionDuration(LiqMotion.fast),
          switchInCurve: LiqMotion.snappy,
          switchOutCurve: LiqMotion.standard,
          transitionBuilder:
              (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.96, end: 1).animate(animation),
                  child: child,
                ),
              ),
          child:
              _open
                  ? Padding(
                    key: const ValueKey<String>('native-panel'),
                    padding: const EdgeInsets.only(top: 10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxPanelHeight),
                      child: SingleChildScrollView(
                        child: LiqColorPickerPanel(
                          color: widget.color,
                          savedColors: widget.colors,
                          onChanged: widget.onChanged,
                          onClose: () => _setOpen(false),
                        ),
                      ),
                    ),
                  )
                  : const SizedBox.shrink(key: ValueKey<String>('empty')),
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LiqColorPickerButton(
              color: widget.color,
              size: widget.buttonSize,
              onPressed: () => _setOpen(!_open),
            ),
            if (disableAnimations)
              panel
            else
              AnimatedSize(
                duration: LiqMotion.normal,
                curve: LiqMotion.snappy,
                alignment: Alignment.topCenter,
                child: panel,
              ),
          ],
        );
      },
    );
  }
}

/// Native iOS 26 color picker panel.
///
/// Based on the verified Figma artifact `color-pickers/0-5275`: top toolbar,
/// segmented mode control, 12-column color grid, opacity meter, selected color
/// well, saved swatches, add button, and page control.
final class LiqColorPickerPanel extends StatefulWidget {
  /// Creates a native color picker panel.
  const LiqColorPickerPanel({
    required this.color,
    required this.onChanged,
    this.savedColors = liqDefaultColorPickerColors,
    this.gridColors = liqNativeColorGridColors,
    this.onClose,
    super.key,
  });

  /// Current selected color.
  final Color color;

  /// Called when a color is chosen.
  final ValueChanged<Color> onChanged;

  /// Saved swatches shown under the opacity meter.
  final List<Color> savedColors;

  /// 12-column grid colors.
  final List<Color> gridColors;

  /// Optional close action for popover/sheet presentations.
  final VoidCallback? onClose;

  @override
  State<LiqColorPickerPanel> createState() => _LiqColorPickerPanelState();
}

enum _ColorPickerMode { grid, spectrum, sliders }

const double _nativeColorPickerPanelWidth = 402;
const double _nativeColorPickerPanelMinWidth = 320;

class _LiqColorPickerPanelState extends State<LiqColorPickerPanel> {
  _ColorPickerMode _mode = _ColorPickerMode.grid;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final label = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    final secondary =
        isDark ? const Color(0xB3EBEBF5) : const Color(0xFF727272);
    final gridIndex = widget.gridColors.indexOf(widget.color);
    final savedIndex = widget.savedColors.indexOf(widget.color);
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth =
            constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : _nativeColorPickerPanelWidth;
        final panelWidth = math.min<double>(
          _nativeColorPickerPanelWidth,
          math.max<double>(_nativeColorPickerPanelMinWidth, availableWidth),
        );
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(34)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                width: panelWidth,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? const Color(0xE61C1C1E)
                          : const Color(0xE0F5F5F5),
                  borderRadius: const BorderRadius.all(Radius.circular(34)),
                  border: Border.fromBorderSide(
                    BorderSide(
                      color:
                          isDark ? LiqSeparator.dark : const Color(0xD1D6D9DE),
                    ),
                  ),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x29000000),
                      blurRadius: 40,
                      offset: Offset(0, 18),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _PickerTopBar(
                      labelColor: label,
                      secondaryColor: secondary,
                      onClose: widget.onClose,
                    ),
                    const SizedBox(height: 8),
                    _PickerSegments(
                      mode: _mode,
                      onChanged: (mode) => setState(() => _mode = mode),
                    ),
                    const SizedBox(height: 14),
                    AnimatedSwitcher(
                      duration: context.liqMotionDuration(LiqMotion.fast),
                      switchInCurve: LiqMotion.snappy,
                      switchOutCurve: LiqMotion.standard,
                      child: switch (_mode) {
                        _ColorPickerMode.grid => LiqColorGrid(
                          key: const ValueKey<String>('grid'),
                          colors: widget.gridColors,
                          selectedIndex: gridIndex < 0 ? null : gridIndex,
                          onSelected:
                              (index) =>
                                  widget.onChanged(widget.gridColors[index]),
                        ),
                        _ColorPickerMode.spectrum => _SpectrumPanel(
                          key: const ValueKey<String>('spectrum'),
                          color: widget.color,
                          onChanged: widget.onChanged,
                        ),
                        _ColorPickerMode.sliders => _SliderPanel(
                          key: const ValueKey<String>('sliders'),
                          color: widget.color,
                          onChanged: widget.onChanged,
                          textColor: label,
                        ),
                      },
                    ),
                    _OpacityMeter(color: widget.color, labelColor: label),
                    _SavedSwatches(
                      color: widget.color,
                      colors: widget.savedColors,
                      selectedIndex: savedIndex,
                      onChanged: widget.onChanged,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PickerTopBar extends StatelessWidget {
  const _PickerTopBar({
    required this.labelColor,
    required this.secondaryColor,
    required this.onClose,
  });

  final Color labelColor;
  final Color secondaryColor;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 36,
          height: 5,
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFCCCCCC).withValues(alpha: 0.72),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
        ),
        SizedBox(
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _RoundIconButton(
                    label: 'Pick color',
                    color: secondaryColor,
                    painter: _PipettePainter(secondaryColor),
                    onPressed: () {},
                  ),
                  _RoundIconButton(
                    label: 'Close',
                    color: secondaryColor,
                    painter: _ClosePainter(secondaryColor),
                    onPressed: onClose,
                  ),
                ],
              ),
              Text(
                'Colors',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                  fontSize: 17,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.label,
    required this.color,
    required this.painter,
    this.onPressed,
  });

  final String label;
  final Color color;
  final CustomPainter painter;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: LiqPointerCursor(
        enabled: enabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0x29787880),
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 22,
              height: 22,
              child: CustomPaint(painter: painter),
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerSegments extends StatelessWidget {
  const _PickerSegments({required this.mode, required this.onChanged});

  final _ColorPickerMode mode;
  final ValueChanged<_ColorPickerMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final selectedBackground =
        isDark ? const Color(0xFF636366) : const Color(0xFFFFFFFF);
    final selectedLabel =
        isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    final inactiveLabel =
        isDark ? const Color(0xB2EBEBF5) : const Color(0xFF000000);
    const labels = <_ColorPickerMode, String>{
      _ColorPickerMode.grid: 'Grid',
      _ColorPickerMode.spectrum: 'Spectrum',
      _ColorPickerMode.sliders: 'Sliders',
    };
    return Container(
      height: 32,
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Color(0x1F767680),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Row(
        children:
            labels.entries.map((entry) {
              final selected = entry.key == mode;
              return Expanded(
                child: LiqPointerCursor(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(entry.key),
                    child: AnimatedContainer(
                      duration: context.liqMotionDuration(LiqMotion.fast),
                      curve: LiqMotion.snappy,
                      height: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color:
                            selected
                                ? selectedBackground
                                : const Color(0x00FFFFFF),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        entry.value,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontFamilyFallback: const <String>[
                            'SF Pro',
                            'sans-serif',
                          ],
                          fontSize: 13.333,
                          height: 18 / 13.333,
                          letterSpacing: -0.08,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected ? selectedLabel : inactiveLabel,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _OpacityMeter extends StatelessWidget {
  const _OpacityMeter({required this.color, required this.labelColor});

  final Color color;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final colorStop = color.withValues(alpha: 1);
    return Container(
      margin: const EdgeInsets.only(top: 26),
      padding: const EdgeInsets.only(bottom: 3),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFC6C6C8))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Opacity',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'SF Pro Text',
              fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
              fontSize: 15,
              height: 20 / 15,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 22),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _OpacitySliderPainter(colorStop),
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFFFFF),
                                width: 3,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0x33787878),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    '${(color.a * 100).round()}%',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontFamilyFallback: const <String>[
                        'SF Pro',
                        'sans-serif',
                      ],
                      fontSize: 17,
                      height: 22 / 17,
                      letterSpacing: -0.43,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedSwatches extends StatelessWidget {
  const _SavedSwatches({
    required this.color,
    required this.colors,
    required this.selectedIndex,
    required this.onChanged,
  });

  final Color color;
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    final firstRow = colors.take(5).toList();
    final secondRow = colors.skip(5).take(4).toList();
    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 350;
          final well = compact ? 64.0 : 82.0;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedContainer(
                duration: context.liqMotionDuration(LiqMotion.fast),
                curve: LiqMotion.snappy,
                width: well,
                height: well,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
              ),
              SizedBox(width: compact ? 18 : 30),
              Expanded(
                child: Column(
                  children: <Widget>[
                    _SavedSwatchRow(
                      colors: firstRow,
                      startIndex: 0,
                      selectedIndex: selectedIndex,
                      onChanged: onChanged,
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        for (var i = 0; i < secondRow.length; i++)
                          LiqColorDot(
                            color: secondRow[i],
                            selected: selectedIndex == i + 5,
                            onPressed: () => onChanged(secondRow[i]),
                          ),
                        const _AddSwatchButton(),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const _PageDots(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SavedSwatchRow extends StatelessWidget {
  const _SavedSwatchRow({
    required this.colors,
    required this.startIndex,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<Color> colors;
  final int startIndex;
  final int selectedIndex;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fitsNativeSpacing = constraints.maxWidth >= colors.length * 44;
        final dots = <Widget>[
          for (var i = 0; i < colors.length; i++)
            LiqColorDot(
              color: colors[i],
              selected: selectedIndex == i + startIndex,
              onPressed: () => onChanged(colors[i]),
            ),
        ];
        if (fitsNativeSpacing) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dots,
          );
        }
        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 4,
          runSpacing: 6,
          children: dots,
        );
      },
    );
  }
}

class _AddSwatchButton extends StatelessWidget {
  const _AddSwatchButton();

  @override
  Widget build(BuildContext context) {
    return const LiqPointerCursor(
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0x33787878),
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 30,
              height: 30,
              child: CustomPaint(painter: _PlusPainter()),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF000000),
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 8, height: 8),
          ),
          SizedBox(width: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0x4D000000),
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 8, height: 8),
          ),
        ],
      ),
    );
  }
}

class _SpectrumPanel extends StatelessWidget {
  const _SpectrumPanel({
    required this.color,
    required this.onChanged,
    super.key,
  });

  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    return LiqPointerCursor(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) => _select(details.localPosition, context),
        onHorizontalDragUpdate:
            (details) => _select(details.localPosition, context),
        onVerticalDragUpdate:
            (details) => _select(details.localPosition, context),
        child: SizedBox(
          height: 300,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            child: CustomPaint(
              painter: _SpectrumPainter(),
              child: Center(
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: const Color(0xFFFFFFFF),
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _select(Offset position, BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || box.size.isEmpty) return;
    final h = (position.dx / box.size.width).clamp(0.0, 1.0);
    final s = (position.dy / box.size.height).clamp(0.0, 1.0);
    onChanged(HSLColor.fromAHSL(1, h * 360, 1, 1 - s * 0.9).toColor());
  }
}

class _SliderPanel extends StatelessWidget {
  const _SliderPanel({
    required this.color,
    required this.onChanged,
    required this.textColor,
    super.key,
  });

  final Color color;
  final ValueChanged<Color> onChanged;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _ColorSliderRow(
            label: 'Red',
            value: color.r,
            gradientColors: const <Color>[Color(0xFF000000), Color(0xFFFF3B30)],
            textColor: textColor,
            onChanged:
                (v) => onChanged(color.withValues(red: v.clamp(0.0, 1.0))),
          ),
          _ColorSliderRow(
            label: 'Green',
            value: color.g,
            gradientColors: const <Color>[Color(0xFF000000), Color(0xFF34C759)],
            textColor: textColor,
            onChanged:
                (v) => onChanged(color.withValues(green: v.clamp(0.0, 1.0))),
          ),
          _ColorSliderRow(
            label: 'Blue',
            value: color.b,
            gradientColors: const <Color>[Color(0xFF000000), Color(0xFF007AFF)],
            textColor: textColor,
            onChanged:
                (v) => onChanged(color.withValues(blue: v.clamp(0.0, 1.0))),
          ),
        ],
      ),
    );
  }
}

class _ColorSliderRow extends StatelessWidget {
  const _ColorSliderRow({
    required this.label,
    required this.value,
    required this.gradientColors,
    required this.textColor,
    required this.onChanged,
  });

  final String label;
  final double value;
  final List<Color> gradientColors;
  final Color textColor;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 58,
            child: Text(
              label,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            child: LiqPointerCursor(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => _select(context, details.localPosition),
                onHorizontalDragUpdate:
                    (details) => _select(context, details.localPosition),
                child: Container(
                  height: 32,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    gradient: LinearGradient(colors: gradientColors),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: Color(0x22000000), blurRadius: 4),
                          ],
                        ),
                        child: SizedBox(width: 28, height: 28),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _select(BuildContext context, Offset position) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || box.size.width == 0) return;
    onChanged(position.dx / box.size.width);
  }
}

class _OpacitySliderPainter extends CustomPainter {
  const _OpacitySliderPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const cell = 14.0;
    final checkerPaint = Paint();
    for (var y = 0.0; y < size.height; y += cell) {
      for (var x = 0.0; x < size.width; x += cell) {
        final dark = ((x / cell).floor() + (y / cell).floor()).isEven;
        checkerPaint.color =
            dark ? const Color(0xFF121212) : const Color(0xFFF7F7F7);
        canvas.drawRect(Rect.fromLTWH(x, y, cell, cell), checkerPaint);
      }
    }
    final gradient =
        Paint()
          ..shader = LinearGradient(
            colors: <Color>[color.withValues(alpha: 0), color],
            stops: const <double>[0.12, 0.88],
          ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, gradient);
  }

  @override
  bool shouldRepaint(covariant _OpacitySliderPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SpectrumPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final hue =
        Paint()
          ..shader = const LinearGradient(
            colors: <Color>[
              Color(0xFFFF3B30),
              Color(0xFFFF9500),
              Color(0xFFFFCC00),
              Color(0xFF34C759),
              Color(0xFF00C7BE),
              Color(0xFF007AFF),
              Color(0xFF5856D6),
              Color(0xFFAF52DE),
              Color(0xFFFF2D55),
            ],
          ).createShader(rect);
    canvas.drawRect(rect, hue);
    final white =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0x00FFFFFF), Color(0xFFFFFFFF)],
          ).createShader(rect);
    canvas.drawRect(rect, white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PipettePainter extends CustomPainter {
  const _PipettePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
    canvas
      ..drawLine(
        Offset(size.width * 0.72, size.height * 0.18),
        Offset(size.width * 0.22, size.height * 0.68),
        paint,
      )
      ..drawLine(
        Offset(size.width * 0.34, size.height * 0.82),
        Offset(size.width * 0.18, size.height * 0.66),
        paint,
      )
      ..drawCircle(Offset(size.width * 0.69, size.height * 0.22), 3, paint);
  }

  @override
  bool shouldRepaint(covariant _PipettePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ClosePainter extends CustomPainter {
  const _ClosePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(
        Offset(size.width * 0.28, size.height * 0.28),
        Offset(size.width * 0.72, size.height * 0.72),
        paint,
      )
      ..drawLine(
        Offset(size.width * 0.72, size.height * 0.28),
        Offset(size.width * 0.28, size.height * 0.72),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant _ClosePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _PlusPainter extends CustomPainter {
  const _PlusPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF000000)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(
        Offset(size.width * 0.32, size.height * 0.5),
        Offset(size.width * 0.68, size.height * 0.5),
        paint,
      )
      ..drawLine(
        Offset(size.width * 0.5, size.height * 0.32),
        Offset(size.width * 0.5, size.height * 0.68),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// iOS 26 color-picker button — conic-gradient ring with an inset swatch.
///
/// Sourced from `native/components/color-pickers.css`
/// (`.ios26-colorpickers-picker-button`). Renders a 36 or 28pt circle with
/// a hue conic gradient and the chosen [color] inset 5pt.
final class LiqColorPickerButton extends StatefulWidget {
  /// Creates a color-picker button.
  const LiqColorPickerButton({
    required this.color,
    this.onPressed,
    this.size = LiqColorPickerButtonSize.large,
    super.key,
  });

  /// Currently chosen color (rendered inset).
  final Color color;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Visual size.
  final LiqColorPickerButtonSize size;

  /// Minimum tap target size.
  static const double tapTargetSize = 44;

  @override
  State<LiqColorPickerButton> createState() => _LiqColorPickerButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(EnumProperty<LiqColorPickerButtonSize>('size', size))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }
}

class _LiqColorPickerButtonState extends State<LiqColorPickerButton> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final dim = widget.size == LiqColorPickerButtonSize.large ? 36.0 : 28.0;
    final inner = widget.size == LiqColorPickerButtonSize.large ? 26.0 : 18.0;
    final disabled = widget.onPressed == null;
    return Semantics(
      button: true,
      enabled: !disabled,
      label: 'Color',
      child: LiqPointerCursor(
        enabled: !disabled,
        child: Listener(
          onPointerDown: disabled ? null : (_) => _setPressed(true),
          onPointerUp: disabled ? null : (_) => _setPressed(false),
          onPointerCancel: disabled ? null : (_) => _setPressed(false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onPressed,
            child: SizedBox(
              width: LiqColorPickerButton.tapTargetSize,
              height: LiqColorPickerButton.tapTargetSize,
              child: Center(
                child: AnimatedScale(
                  scale: _pressed ? 0.9 : 1,
                  duration: context.liqMotionDuration(LiqMotion.fast),
                  curve: LiqMotion.snappy,
                  child: SizedBox(
                    width: dim,
                    height: dim,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: dim,
                          height: dim,
                          child: CustomPaint(painter: _ColorWheelPainter()),
                        ),
                        AnimatedContainer(
                          duration: context.liqMotionDuration(LiqMotion.fast),
                          curve: LiqMotion.snappy,
                          width: inner,
                          height: inner,
                          decoration: BoxDecoration(
                            color: widget.color,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: const Color(0x33000000),
                                blurRadius: _pressed ? 2 : 5,
                                offset: Offset(0, _pressed ? 1 : 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Visual size for [LiqColorPickerButton].
enum LiqColorPickerButtonSize {
  /// 36pt outer / 26pt inset.
  large,

  /// 28pt outer / 18pt inset.
  small,
}

class _ColorWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint =
        Paint()
          ..shader = const SweepGradient(
            startAngle: 1.5708,
            endAngle: 1.5708 + 6.2832,
            colors: <Color>[
              Color(0xFFE7E040),
              Color(0xFFEEAA3C),
              Color(0xFFE8403B),
              Color(0xFFB33ED5),
              Color(0xFF694AE8),
              Color(0xFF3CCAE7),
              Color(0xFF3CE885),
              Color(0xFF89E743),
              Color(0xFFE7E040),
            ],
          ).createShader(rect);
    canvas.drawCircle(rect.center, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 30pt circular color dot — used in palettes with an optional selection ring.
final class LiqColorDot extends StatefulWidget {
  /// Creates a color dot.
  const LiqColorDot({
    required this.color,
    this.selected = false,
    this.onPressed,
    super.key,
  });

  /// Fill color.
  final Color color;

  /// When true, draws a 2pt white selection ring inside the dot.
  final bool selected;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Minimum tap target size.
  static const double tapTargetSize = 44;

  @override
  State<LiqColorDot> createState() => _LiqColorDotState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(FlagProperty('selected', value: selected, ifTrue: 'selected'))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }
}

class _LiqColorDotState extends State<LiqColorDot> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    return Semantics(
      button: !disabled,
      selected: widget.selected,
      child: LiqPointerCursor(
        enabled: !disabled,
        child: Listener(
          onPointerDown: disabled ? null : (_) => _setPressed(true),
          onPointerUp: disabled ? null : (_) => _setPressed(false),
          onPointerCancel: disabled ? null : (_) => _setPressed(false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onPressed,
            child: SizedBox(
              width: LiqColorDot.tapTargetSize,
              height: LiqColorDot.tapTargetSize,
              child: Center(
                child: AnimatedScale(
                  scale: _pressed ? 0.9 : 1,
                  duration: context.liqMotionDuration(LiqMotion.fast),
                  curve: LiqMotion.snappy,
                  child: AnimatedContainer(
                    duration: context.liqMotionDuration(LiqMotion.fast),
                    curve: LiqMotion.snappy,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0x24000000),
                          blurRadius: _pressed ? 2 : 5,
                          offset: Offset(0, _pressed ? 1 : 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child:
                        widget.selected
                            ? AnimatedContainer(
                              duration: context.liqMotionDuration(
                                LiqMotion.fast,
                              ),
                              curve: LiqMotion.snappy,
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFFFFFF),
                                  width: 2,
                                ),
                              ),
                            )
                            : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared palette surface used by color picker examples and popovers.
final class LiqColorPalette extends StatelessWidget {
  /// Creates a color palette.
  const LiqColorPalette({
    required this.colors,
    this.selectedIndex,
    this.onSelected,
    this.columns = 6,
    super.key,
  });

  /// Palette colors.
  final List<Color> colors;

  /// Currently selected index.
  final int? selectedIndex;

  /// Called when a color is selected.
  final ValueChanged<int>? onSelected;

  /// Number of columns.
  final int columns;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        border: Border.fromBorderSide(
          BorderSide(
            color: isDark ? LiqSeparator.dark : const Color(0x1F000000),
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: isDark ? const Color(0x66000000) : const Color(0x1F000000),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: LiqColorGrid(
          colors: colors,
          selectedIndex: selectedIndex,
          onSelected: onSelected,
          columns: columns,
          swatchHeight: 34,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('selectedIndex', selectedIndex))
      ..add(IntProperty('columns', columns))
      ..add(
        ObjectFlagProperty<ValueChanged<int>?>.has('onSelected', onSelected),
      );
  }
}

class _ColorGridSwatch extends StatefulWidget {
  const _ColorGridSwatch({
    required this.color,
    required this.selected,
    required this.onPressed,
  });

  final Color color;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  State<_ColorGridSwatch> createState() => _ColorGridSwatchState();
}

class _ColorGridSwatchState extends State<_ColorGridSwatch> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    return LiqPointerCursor(
      enabled: !disabled,
      child: Listener(
        onPointerDown: disabled ? null : (_) => _setPressed(true),
        onPointerUp: disabled ? null : (_) => _setPressed(false),
        onPointerCancel: disabled ? null : (_) => _setPressed(false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: _pressed ? 0.94 : 1,
            duration: context.liqMotionDuration(LiqMotion.fast),
            curve: LiqMotion.snappy,
            child: Stack(
              children: <Widget>[
                Positioned.fill(child: ColoredBox(color: widget.color)),
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: context.liqMotionDuration(LiqMotion.fast),
                    curve: LiqMotion.snappy,
                    margin: EdgeInsets.all(widget.selected ? 3 : 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            widget.selected
                                ? const Color(0xFFFFFFFF)
                                : const Color(0x00FFFFFF),
                        width: widget.selected ? 3 : 0,
                      ),
                      boxShadow:
                          widget.selected
                              ? const <BoxShadow>[
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 4,
                                ),
                              ]
                              : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 12-column grid of color swatches with selection highlight.
///
/// Sourced from `native/components/color-pickers.css`
/// (`.ios26-colorpickers-grid` + `.ios26-colorpickers-grid-swatch`).
final class LiqColorGrid extends StatelessWidget {
  /// Creates a swatch grid.
  const LiqColorGrid({
    required this.colors,
    this.selectedIndex,
    this.onSelected,
    this.columns = 12,
    this.swatchHeight = 30,
    super.key,
  });

  /// Colors flowing left-to-right, top-to-bottom.
  final List<Color> colors;

  /// Index in [colors] highlighted with the selection ring.
  final int? selectedIndex;

  /// Callback when a swatch is tapped.
  final ValueChanged<int>? onSelected;

  /// Number of columns. Defaults to 12.
  final int columns;

  /// Height of each swatch row.
  final double swatchHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth / columns;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (var r = 0; r * columns < colors.length; r++)
                Row(
                  children: <Widget>[
                    for (var c = 0; c < columns; c++)
                      if (r * columns + c < colors.length)
                        SizedBox(
                          width: w,
                          height: swatchHeight,
                          child: _ColorGridSwatch(
                            color: colors[r * columns + c],
                            selected: selectedIndex == r * columns + c,
                            onPressed:
                                onSelected == null
                                    ? null
                                    : () => onSelected!(r * columns + c),
                          ),
                        )
                      else
                        SizedBox(width: w, height: swatchHeight),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
