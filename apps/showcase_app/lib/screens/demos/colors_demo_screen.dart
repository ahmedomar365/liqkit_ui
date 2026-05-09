import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class ColorsDemoScreen extends ConsumerStatefulWidget {
  const ColorsDemoScreen({super.key});

  @override
  ConsumerState<ColorsDemoScreen> createState() => _ColorsDemoScreenState();
}

class _ColorsDemoScreenState extends ConsumerState<ColorsDemoScreen> {
  String _selectedCategory = 'System';

  static const List<String> _categories = <String>[
    'System',
    'Grays',
    'Labels',
    'Fills',
    'Backgrounds',
    'UI Colors',
  ];

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Colors System')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: LiqSegmentedControl<String>(
              value: _selectedCategory,
              segments: _categories
                  .map(
                    (c) => (value: c, label: c),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedCategory = value),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildColorSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSection() {
    switch (_selectedCategory) {
      case 'System':
        return _buildSystemColors();
      case 'Grays':
        return _buildGrayColors();
      case 'Labels':
        return _buildLabelColors();
      case 'Fills':
        return _buildFillColors();
      case 'Backgrounds':
        return _buildBackgroundColors();
      case 'UI Colors':
        return _buildUIColors();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSystemColors() {
    final palette = context.appleColors;
    final systemColors = <_ColorEntry>[
      _ColorEntry('Red', palette.red, LiqAppleColors.systemRed,
          LiqAppleColors.systemRedDark),
      _ColorEntry('Orange', palette.orange, LiqAppleColors.systemOrange,
          LiqAppleColors.systemOrangeDark),
      _ColorEntry('Yellow', palette.yellow, LiqAppleColors.systemYellow,
          LiqAppleColors.systemYellowDark),
      _ColorEntry('Green', palette.green, LiqAppleColors.systemGreen,
          LiqAppleColors.systemGreenDark),
      _ColorEntry('Mint', palette.mint, LiqAppleColors.systemMint,
          LiqAppleColors.systemMintDark),
      _ColorEntry('Teal', palette.teal, LiqAppleColors.systemTeal,
          LiqAppleColors.systemTealDark),
      _ColorEntry('Cyan', palette.cyan, LiqAppleColors.systemCyan,
          LiqAppleColors.systemCyanDark),
      _ColorEntry('Blue', palette.blue, LiqAppleColors.systemBlue,
          LiqAppleColors.systemBlueDark),
      _ColorEntry('Indigo', palette.indigo, LiqAppleColors.systemIndigo,
          LiqAppleColors.systemIndigoDark),
      _ColorEntry('Purple', palette.purple, LiqAppleColors.systemPurple,
          LiqAppleColors.systemPurpleDark),
      _ColorEntry('Pink', palette.pink, LiqAppleColors.systemPink,
          LiqAppleColors.systemPinkDark),
      _ColorEntry('Brown', palette.brown, LiqAppleColors.systemBrown,
          LiqAppleColors.systemBrownDark),
    ];

    final accessibleColors = <_ColorEntry>[
      _ColorEntry.accessible('Red Accessible', LiqAppleColors.systemRedAccessible,
          LiqAppleColors.systemRedAccessibleDark, context),
      _ColorEntry.accessible(
          'Orange Accessible',
          LiqAppleColors.systemOrangeAccessible,
          LiqAppleColors.systemOrangeAccessibleDark,
          context),
      _ColorEntry.accessible(
          'Yellow Accessible',
          LiqAppleColors.systemYellowAccessible,
          LiqAppleColors.systemYellowAccessibleDark,
          context),
      _ColorEntry.accessible(
          'Green Accessible',
          LiqAppleColors.systemGreenAccessible,
          LiqAppleColors.systemGreenAccessibleDark,
          context),
      _ColorEntry.accessible(
          'Blue Accessible',
          LiqAppleColors.systemBlueAccessible,
          LiqAppleColors.systemBlueAccessibleDark,
          context),
      _ColorEntry.accessible(
          'Purple Accessible',
          LiqAppleColors.systemPurpleAccessible,
          LiqAppleColors.systemPurpleAccessibleDark,
          context),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle('System Colors'),
        _ColorGrid(systemColors),
        const SizedBox(height: 32),
        _SectionTitle('Accessible System Colors'),
        _ColorGrid(accessibleColors),
      ],
    );
  }

  Widget _buildGrayColors() {
    final palette = context.appleColors;
    final grayColors = <_ColorEntry>[
      _ColorEntry('Gray', palette.gray, LiqAppleColors.systemGray,
          LiqAppleColors.systemGrayDark),
      _ColorEntry('Gray 2', palette.gray2, LiqAppleColors.systemGray2,
          LiqAppleColors.systemGray2Dark),
      _ColorEntry('Gray 3', palette.gray3, LiqAppleColors.systemGray3,
          LiqAppleColors.systemGray3Dark),
      _ColorEntry('Gray 4', palette.gray4, LiqAppleColors.systemGray4,
          LiqAppleColors.systemGray4Dark),
      _ColorEntry('Gray 5', palette.gray5, LiqAppleColors.systemGray5,
          LiqAppleColors.systemGray5Dark),
      _ColorEntry('Gray 6', palette.gray6, LiqAppleColors.systemGray6,
          LiqAppleColors.systemGray6Dark),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle('System Grays'),
        _ColorGrid(grayColors),
      ],
    );
  }

  Widget _buildLabelColors() {
    final palette = context.appleColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle('Label Colors'),
        _ColorGrid(<_ColorEntry>[
          _ColorEntry('Label', palette.label, LiqAppleColors.label,
              LiqAppleColors.labelDark),
          _ColorEntry('Secondary Label', palette.secondaryLabel,
              LiqAppleColors.secondaryLabel, LiqAppleColors.secondaryLabelDark),
          _ColorEntry('Tertiary Label', palette.tertiaryLabel,
              LiqAppleColors.tertiaryLabel, LiqAppleColors.tertiaryLabelDark),
          _ColorEntry('Quaternary Label', palette.quaternaryLabel,
              LiqAppleColors.quaternaryLabel, LiqAppleColors.quaternaryLabelDark),
        ]),
        const SizedBox(height: 32),
        _SectionTitle('Separator Colors'),
        _ColorGrid(<_ColorEntry>[
          _ColorEntry('Separator', palette.separator, LiqAppleColors.separator,
              LiqAppleColors.separatorDark),
          _ColorEntry('Opaque Separator', palette.opaqueSeparator,
              LiqAppleColors.opaqueSeparator, LiqAppleColors.opaqueSeparatorDark),
        ]),
        const SizedBox(height: 32),
        _SectionTitle('Link Colors'),
        _ColorGrid(<_ColorEntry>[
          _ColorEntry('Link', palette.link, LiqAppleColors.link,
              LiqAppleColors.linkDark),
        ]),
      ],
    );
  }

  Widget _buildFillColors() {
    final palette = context.appleColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle('Fill Colors'),
        _ColorGrid(<_ColorEntry>[
          _ColorEntry('System Fill', palette.systemFill,
              LiqAppleColors.systemFill, LiqAppleColors.systemFillDark),
          _ColorEntry(
              'Secondary System Fill',
              palette.secondarySystemFill,
              LiqAppleColors.secondarySystemFill,
              LiqAppleColors.secondarySystemFillDark),
          _ColorEntry(
              'Tertiary System Fill',
              palette.tertiarySystemFill,
              LiqAppleColors.tertiarySystemFill,
              LiqAppleColors.tertiarySystemFillDark),
          _ColorEntry(
              'Quaternary System Fill',
              palette.quaternarySystemFill,
              LiqAppleColors.quaternarySystemFill,
              LiqAppleColors.quaternarySystemFillDark),
        ]),
      ],
    );
  }

  Widget _buildBackgroundColors() {
    final palette = context.appleColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle('Background Colors'),
        _ColorGrid(<_ColorEntry>[
          _ColorEntry('System Background', palette.systemBackground,
              LiqAppleColors.systemBackground, LiqAppleColors.systemBackgroundDark),
          _ColorEntry(
              'Secondary System Background',
              palette.secondarySystemBackground,
              LiqAppleColors.secondarySystemBackground,
              LiqAppleColors.secondarySystemBackgroundDark),
          _ColorEntry(
              'Tertiary System Background',
              palette.tertiarySystemBackground,
              LiqAppleColors.tertiarySystemBackground,
              LiqAppleColors.tertiarySystemBackgroundDark),
        ]),
        const SizedBox(height: 32),
        _SectionTitle('Grouped Background Colors'),
        _ColorGrid(<_ColorEntry>[
          _ColorEntry(
              'System Grouped Background',
              palette.systemGroupedBackground,
              LiqAppleColors.systemGroupedBackground,
              LiqAppleColors.systemGroupedBackgroundDark),
          _ColorEntry(
              'Secondary System Grouped Background',
              palette.secondarySystemGroupedBackground,
              LiqAppleColors.secondarySystemGroupedBackground,
              LiqAppleColors.secondarySystemGroupedBackgroundDark),
          _ColorEntry(
              'Tertiary System Grouped Background',
              palette.tertiarySystemGroupedBackground,
              LiqAppleColors.tertiarySystemGroupedBackground,
              LiqAppleColors.tertiarySystemGroupedBackgroundDark),
        ]),
      ],
    );
  }

  Widget _buildUIColors() {
    final isDark = LiqTheme.of(context).brightness == Brightness.dark;
    final entries = <(String, Color, Color)>[
      ('UI Red', LiqAppleColors.uiRed, LiqAppleColors.uiRedDark),
      ('UI Blue', LiqAppleColors.uiBlue, LiqAppleColors.uiBlue),
      ('UI Indigo', LiqAppleColors.uiIndigo, LiqAppleColors.uiIndigo),
      ('UI Purple', LiqAppleColors.uiPurple, LiqAppleColors.uiPurple),
      ('UI Cyan', LiqAppleColors.uiCyan, LiqAppleColors.uiCyanLight),
      ('UI Teal', LiqAppleColors.uiTeal, LiqAppleColors.uiTeal),
      ('UI Mint', LiqAppleColors.uiMint, LiqAppleColors.uiMint),
      ('UI Green', LiqAppleColors.uiGreen, LiqAppleColors.uiGreen),
      ('UI Yellow', LiqAppleColors.uiYellow, LiqAppleColors.uiYellow),
      ('UI Orange', LiqAppleColors.uiOrange, LiqAppleColors.uiOrange),
      ('UI Brown', LiqAppleColors.uiBrown, LiqAppleColors.uiBrown),
      ('UI Background', LiqAppleColors.uiBackground, LiqAppleColors.uiBackground),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle('Custom UI Colors'),
        _ColorGrid(
          entries
              .map(
                (e) => _ColorEntry(
                  e.$1,
                  isDark && e.$3 != e.$2 ? e.$3 : e.$2,
                  e.$2,
                  e.$3,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ColorEntry {
  const _ColorEntry(this.name, this.color, this.lightColor, this.darkColor);

  factory _ColorEntry.accessible(
    String name,
    Color light,
    Color dark,
    BuildContext context,
  ) {
    final isDark = LiqTheme.of(context).brightness == Brightness.dark;
    return _ColorEntry(name, isDark ? dark : light, light, dark);
  }

  final String name;
  final Color color;
  final Color lightColor;
  final Color darkColor;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: context.textStyles.title2.copyWith(
          fontWeight: LiqAppleTypography.semibold,
        ),
      ),
    );
  }
}

class _ColorGrid extends StatelessWidget {
  const _ColorGrid(this.colors);

  final List<_ColorEntry> colors;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) => _ColorCard(entry: colors[index]),
    );
  }
}

class _ColorCard extends StatelessWidget {
  const _ColorCard({required this.entry});

  final _ColorEntry entry;

  @override
  Widget build(BuildContext context) {
    final isDark = LiqTheme.of(context).brightness == Brightness.dark;
    final hexLight = _hex(entry.lightColor);
    final hexDark = _hex(entry.darkColor);
    final currentHex = _hex(entry.color);

    return LiqCard(
      onTap: () => LiqToastOverlay.show(
        context,
        '${entry.name}: $currentHex',
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: entry.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: entry.color.computeLuminance() > 0.9
                    ? const Color(0x1A000000)
                    : const Color(0x00000000),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  entry.name,
                  style: context.textStyles.footnote.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  isDark ? hexDark : hexLight,
                  style: context.textStyles.caption2.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _hex(Color color) {
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}
