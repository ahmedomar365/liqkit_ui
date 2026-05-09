import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class TextStylesDemoScreen extends ConsumerStatefulWidget {
  const TextStylesDemoScreen({super.key});

  @override
  ConsumerState<TextStylesDemoScreen> createState() =>
      _TextStylesDemoScreenState();
}

class _TextStylesDemoScreenState extends ConsumerState<TextStylesDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Text Styles')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Display Styles',
              description:
                  'Large titles and headers used for the most prominent text on a screen.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _styleExample(context, 'Large Title',
                      context.textStyles.largeTitle, 'Used for prominent page titles'),
                  _divider(context),
                  _styleExample(context, 'Title 1',
                      context.textStyles.title1, 'Major section headers'),
                  _divider(context),
                  _styleExample(context, 'Title 2',
                      context.textStyles.title2, 'Subsection headers'),
                  _divider(context),
                  _styleExample(context, 'Title 3',
                      context.textStyles.title3, 'Minor section headers'),
                ],
              ),
            ),
            _Section(
              title: 'Body Styles',
              description: 'Text styles used for body content, captions, and secondary text.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _styleExample(context, 'Headline',
                      context.textStyles.headline, 'Emphasized body text'),
                  _divider(context),
                  _styleExample(context, 'Body', context.textStyles.body,
                      'Primary content text'),
                  _divider(context),
                  _styleExample(context, 'Callout', context.textStyles.callout,
                      'Highlighted information'),
                  _divider(context),
                  _styleExample(
                      context,
                      'Subheadline',
                      context.textStyles.subheadline,
                      'Secondary headings'),
                  _divider(context),
                  _styleExample(context, 'Footnote',
                      context.textStyles.footnote, 'Supporting information'),
                  _divider(context),
                  _styleExample(context, 'Caption 1',
                      context.textStyles.caption1, 'Small text labels'),
                  _divider(context),
                  _styleExample(context, 'Caption 2',
                      context.textStyles.caption2, 'Very small text'),
                ],
              ),
            ),
            _Section(
              title: 'Monospaced',
              description: 'For code, technical content, and tabular numbers.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _styleExample(
                      context,
                      'Monospaced Body',
                      context.textStyles.monospacedBody,
                      'Code and technical content'),
                  _divider(context),
                  _styleExample(
                      context,
                      'Monospaced Headline',
                      context.textStyles.monospacedHeadline,
                      'Emphasized code or data'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.appleColors.gray.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'func greetUser(name: String) {\n  print("Hello, \\(name)!")\n}',
                      style: context.textStyles.monospacedBody,
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Font Weights',
              description: 'All weight variations applied to the same body text.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (final entry in <MapEntry<String, FontWeight>>[
                    const MapEntry('Ultra Light', LiqAppleTypography.ultraLight),
                    const MapEntry('Thin', LiqAppleTypography.thin),
                    const MapEntry('Light', LiqAppleTypography.light),
                    const MapEntry('Regular', LiqAppleTypography.regular),
                    const MapEntry('Medium', LiqAppleTypography.medium),
                    const MapEntry('Semibold', LiqAppleTypography.semibold),
                    const MapEntry('Bold', LiqAppleTypography.bold),
                    const MapEntry('Heavy', LiqAppleTypography.heavy),
                    const MapEntry('Black', LiqAppleTypography.black),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 100,
                            child: Text(
                              entry.key,
                              style: context.textStyles.caption1.secondary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'The quick brown fox jumps over the lazy dog',
                              style: context.textStyles.body
                                  .copyWith(fontWeight: entry.value),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Label Color Variants',
              description: 'Primary, secondary, tertiary, and quaternary label colors.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _colorExample(context, 'Primary Label',
                      context.textStyles.body, null),
                  const SizedBox(height: 12),
                  _colorExample(
                      context,
                      'Secondary Label',
                      context.textStyles.body.secondary,
                      'context.textStyles.body.secondary'),
                  const SizedBox(height: 12),
                  _colorExample(
                      context,
                      'Tertiary Label',
                      context.textStyles.body.tertiary,
                      'context.textStyles.body.tertiary'),
                  const SizedBox(height: 12),
                  _colorExample(
                      context,
                      'Quaternary Label',
                      context.textStyles.body.quaternary,
                      'context.textStyles.body.quaternary'),
                ],
              ),
            ),
            _Section(
              title: 'System Colors',
              description: 'Color chips drawn from the Apple system color palette.',
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                children: <Widget>[
                  _systemColorChip(context, 'Blue', context.appleColors.blue),
                  _systemColorChip(context, 'Green', context.appleColors.green),
                  _systemColorChip(context, 'Red', context.appleColors.red),
                  _systemColorChip(
                      context, 'Orange', context.appleColors.orange),
                  _systemColorChip(
                      context, 'Yellow', context.appleColors.yellow),
                  _systemColorChip(
                      context, 'Purple', context.appleColors.purple),
                  _systemColorChip(context, 'Pink', context.appleColors.pink),
                  _systemColorChip(context, 'Teal', context.appleColors.teal),
                ],
              ),
            ),
            _Section(
              title: 'Dynamic Type Sizes',
              description:
                  'Approximations of iOS dynamic type — body text scaled to a few preferred sizes.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _dynamicSizeRow(context, 'xSmall', 0.8),
                  _dynamicSizeRow(context, 'Small', 0.9),
                  _dynamicSizeRow(context, 'Medium', 1.0),
                  _dynamicSizeRow(context, 'Large', 1.1),
                  _dynamicSizeRow(context, 'xLarge', 1.2),
                  _dynamicSizeRow(context, 'xxLarge', 1.3),
                  _dynamicSizeRow(context, 'xxxLarge', 1.4),
                  _dynamicSizeRow(context, 'Accessibility M', 1.6),
                  _dynamicSizeRow(context, 'Accessibility L', 1.8),
                  _dynamicSizeRow(context, 'Accessibility XL', 2.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _styleExample(BuildContext context, String name, TextStyle style,
      String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(name, style: context.textStyles.headline),
              const SizedBox(width: 8),
              Text(
                '${style.fontSize?.round()}pt',
                style: context.textStyles.caption1.secondary,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(description, style: context.textStyles.footnote.secondary),
          const SizedBox(height: 8),
          Text('The quick brown fox jumps over the lazy dog', style: style),
        ],
      ),
    );
  }

  Widget _colorExample(
      BuildContext context, String name, TextStyle style, String? code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(name, style: context.textStyles.footnote.secondary),
        const SizedBox(height: 4),
        Text('The quick brown fox jumps over the lazy dog', style: style),
        if (code != null) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            code,
            style: context.textStyles.caption2.copyWith(
              fontFamily: LiqAppleTypography.monospacedFontFamily,
              color: context.appleColors.gray,
            ),
          ),
        ],
      ],
    );
  }

  Widget _systemColorChip(BuildContext context, String name, Color color) {
    return Column(
      children: <Widget>[
        Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Aa',
              style: context.textStyles.title2.copyWith(color: color),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: context.textStyles.caption1),
      ],
    );
  }

  Widget _dynamicSizeRow(BuildContext context, String size, double scale) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 140,
            child: Text(size, style: context.textStyles.footnote.secondary),
          ),
          Expanded(
            child: Text(
              'Dynamic Type Example',
              style: context.textStyles.body.copyWith(
                fontSize: (context.textStyles.body.fontSize ?? 17) * scale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(height: 1, color: context.appleColors.separator);
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(description!, style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
