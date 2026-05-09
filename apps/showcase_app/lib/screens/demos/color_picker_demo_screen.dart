import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class ColorPickerDemoScreen extends ConsumerStatefulWidget {
  const ColorPickerDemoScreen({super.key});

  @override
  ConsumerState<ColorPickerDemoScreen> createState() =>
      _ColorPickerDemoScreenState();
}

class _ColorPickerDemoScreenState
    extends ConsumerState<ColorPickerDemoScreen> {
  Color _selectedColor = LiqAppleColors.systemBlue;
  Color _wheelColor = LiqAppleColors.systemPurple;
  Color _sliderColor = LiqAppleColors.systemGreen;
  Color _hexColor = LiqAppleColors.systemOrange;
  Color _modalColor = LiqAppleColors.systemPink;

  static final List<Color> _presetColors = <Color>[
    LiqAppleColors.systemRed,
    LiqAppleColors.systemOrange,
    LiqAppleColors.systemYellow,
    LiqAppleColors.systemGreen,
    LiqAppleColors.systemTeal,
    LiqAppleColors.systemBlue,
    LiqAppleColors.systemIndigo,
    LiqAppleColors.systemPurple,
    LiqAppleColors.systemPink,
    LiqAppleColors.systemGray,
    LiqAppleColors.systemGray2,
    LiqAppleColors.systemGray3,
  ];

  static const List<Color> _recentColors = <Color>[
    Color(0xFF1E88E5),
    Color(0xFF43A047),
    Color(0xFFE53935),
    Color(0xFFFB8C00),
    Color(0xFF8E24AA),
    Color(0xFF00ACC1),
  ];

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Color Pickers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _section(
              title: 'Color Picker Buttons',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: <Widget>[
                      LiqColorChipButton(
                        color: _selectedColor,
                        label: 'Primary',
                        onTap: () => _openModal(
                          'Select Color',
                          _selectedColor,
                          _presetColors,
                          (c) => _selectedColor = c,
                        ),
                      ),
                      LiqColorChipButton(
                        color: _wheelColor,
                        label: 'Secondary',
                        onTap: () => _openModal(
                          'Choose Color',
                          _wheelColor,
                          _recentColors,
                          (c) => _wheelColor = c,
                        ),
                      ),
                      LiqColorChipButton(
                        color: _sliderColor,
                        label: 'Accent',
                        onTap: () => _openModal(
                          'Pick a Color',
                          _sliderColor,
                          _presetColors,
                          (c) => _sliderColor = c,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Different Sizes',
                    style: context.textStyles.footnote.secondary,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      LiqColorChipButton(color: _selectedColor, size: 32),
                      LiqColorChipButton(color: _wheelColor, size: 44),
                      LiqColorChipButton(color: _sliderColor, size: 56),
                      LiqColorChipButton(color: _hexColor, size: 68),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Without Border',
                    style: context.textStyles.footnote.secondary,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      LiqColorChipButton(
                          color: _selectedColor, showBorder: false),
                      LiqColorChipButton(
                          color: _wheelColor, showBorder: false),
                      LiqColorChipButton(
                          color: _sliderColor, showBorder: false),
                    ],
                  ),
                ],
              ),
            ),
            _section(
              title: 'Native Color Picker Button',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  LiqColorPickerButton(
                    color: _hexColor,
                    onPressed: () => _openModal(
                      'Hue Wheel',
                      _hexColor,
                      _presetColors,
                      (c) => _hexColor = c,
                    ),
                  ),
                  LiqColorPickerButton(
                    color: _modalColor,
                    size: LiqColorPickerButtonSize.small,
                    onPressed: () => _openModal(
                      'Compact',
                      _modalColor,
                      _presetColors,
                      (c) => _modalColor = c,
                    ),
                  ),
                ],
              ),
            ),
            _section(
              title: 'Inline Picker',
              child: LiqCard(
                padding: const EdgeInsets.all(20),
                child: LiqColorPicker(
                  color: _modalColor,
                  colors: _presetColors,
                  onChanged: (c) => setState(() => _modalColor = c),
                ),
              ),
            ),
            _section(
              title: 'Color Picker Modal',
              child: Column(
                children: <Widget>[
                  LiqButton(
                    label: 'Open Color Picker Modal',
                    fullWidth: true,
                    onPressed: () => _openModal(
                      'Choose Theme Color',
                      _selectedColor,
                      _presetColors,
                      (c) => _selectedColor = c,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LiqButton(
                    label: 'Open Without Presets',
                    style: LiqButtonStyle.borderedSecondary,
                    fullWidth: true,
                    onPressed: () => _openModal(
                      'Custom Color',
                      _wheelColor,
                      const <Color>[],
                      (c) => _wheelColor = c,
                    ),
                  ),
                ],
              ),
            ),
            _section(
              title: 'Selected Colors',
              child: LiqCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    _colorRow('Primary Color', _selectedColor),
                    const SizedBox(height: 12),
                    _colorRow('Wheel Color', _wheelColor),
                    const SizedBox(height: 12),
                    _colorRow('Slider Color', _sliderColor),
                    const SizedBox(height: 12),
                    _colorRow('Hex Color', _hexColor),
                    const SizedBox(height: 12),
                    _colorRow('Modal Color', _modalColor),
                  ],
                ),
              ),
            ),
            _section(
              title: 'Preset Colors',
              child: LiqCard(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    for (final color in _presetColors)
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedColor = color);
                          LiqToastOverlay.show(
                              context, 'Selected preset color');
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedColor == color
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0x00000000),
                              width: 2,
                            ),
                            boxShadow: <BoxShadow>[
                              if (_selectedColor == color)
                                BoxShadow(
                                  color: color.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openModal(
    String title,
    Color initial,
    List<Color> presets,
    void Function(Color) onPicked,
  ) async {
    final color = await LiqColorPickerModal.show(
      context: context,
      title: title,
      initialColor: initial,
      presetColors: presets.isEmpty ? liqDefaultColorPickerColors : presets,
    );
    if (color != null && mounted) {
      setState(() => onPicked(color));
    }
  }

  Widget _section({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _colorRow(String label, Color color) {
    final argb = color.toARGB32();
    final hexString =
        '#${argb.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();
    final a = (color.a * 255).round();
    final isDark = LiqTheme.of(context).brightness == Brightness.dark;
    return Row(
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? const Color(0x33FFFFFF)
                  : const Color(0x33000000),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: context.textStyles.body.copyWith(
                  fontWeight: LiqAppleTypography.semibold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$hexString • RGB($r, $g, $b, $a)',
                style: context.textStyles.caption1.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
