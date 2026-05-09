import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class MaterialDemoScreenV2 extends ConsumerStatefulWidget {
  const MaterialDemoScreenV2({super.key});

  @override
  ConsumerState<MaterialDemoScreenV2> createState() =>
      _MaterialDemoScreenV2State();
}

class _MaterialDemoScreenV2State extends ConsumerState<MaterialDemoScreenV2> {
  static const List<({LiqMaterialStyle value, String label, String desc})>
      _materialOptions = <({
    LiqMaterialStyle value,
    String label,
    String desc,
  })>[
    (
      value: LiqMaterialStyle.ultraThin,
      label: 'Ultra Thin',
      desc: 'Minimal blur'
    ),
    (value: LiqMaterialStyle.thin, label: 'Thin', desc: 'Light blur'),
    (
      value: LiqMaterialStyle.regular,
      label: 'Regular',
      desc: 'Standard blur'
    ),
    (value: LiqMaterialStyle.thick, label: 'Thick', desc: 'Heavy blur'),
    (value: LiqMaterialStyle.chrome, label: 'Chrome', desc: 'Heaviest blur'),
    (
      value: LiqMaterialStyle.sidebar,
      label: 'Sidebar',
      desc: 'Sidebar surface'
    ),
    (
      value: LiqMaterialStyle.headerBlur,
      label: 'Header Blur',
      desc: 'Header / toolbar'
    ),
    (
      value: LiqMaterialStyle.fullScreenUI,
      label: 'Full Screen UI',
      desc: 'Full overlay'
    ),
    (
      value: LiqMaterialStyle.hudWindow,
      label: 'HUD Window',
      desc: 'High contrast'
    ),
    (value: LiqMaterialStyle.tooltip, label: 'Tooltip', desc: 'Tooltips'),
    (value: LiqMaterialStyle.menu, label: 'Menu', desc: 'Dropdown menus'),
    (value: LiqMaterialStyle.popover, label: 'Popover', desc: 'Popovers'),
    (value: LiqMaterialStyle.sheet, label: 'Sheet', desc: 'Modal sheets'),
    (
      value: LiqMaterialStyle.windowBackground,
      label: 'Window Background',
      desc: 'Window backgrounds'
    ),
    (
      value: LiqMaterialStyle.contentBackground,
      label: 'Content Background',
      desc: 'Content areas'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Materials')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'All Material Styles',
              description:
                  'Each preset rendered over a colorful gradient background to show its translucency.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  for (final opt in _materialOptions)
                    _MaterialPreview(
                      style: opt.value,
                      label: opt.label,
                      description: opt.desc,
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Custom Configuration',
              description:
                  'A regular material with explicit blur, opacity, and tint overrides.',
              child: _MaterialPreview(
                style: LiqMaterialStyle.regular,
                label: 'Custom',
                description: 'blur: 30 · tint: 0.4 · saturation: 1.5',
                config: const LiqMaterialConfig(
                  blurRadius: 30,
                  tintOpacity: 0.4,
                  saturation: 1.5,
                ),
              ),
            ),
            _Section(
              title: 'Vibrancy Off',
              description: 'Same regular material with vibrancy disabled.',
              child: _MaterialPreview(
                style: LiqMaterialStyle.regular,
                label: 'No Vibrancy',
                description: 'vibrancy: false',
                config: const LiqMaterialConfig(vibrancy: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialPreview extends StatelessWidget {
  const _MaterialPreview({
    required this.style,
    required this.label,
    required this.description,
    this.config,
  });

  final LiqMaterialStyle style;
  final String label;
  final String description;
  final LiqMaterialConfig? config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 220,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      context.appleColors.blue.withValues(alpha: 0.5),
                      context.appleColors.purple.withValues(alpha: 0.5),
                      context.appleColors.pink.withValues(alpha: 0.5),
                      context.appleColors.orange.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: LiqMaterialChip(
                  style: style,
                  config: config,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(16)),
                  size: const Size(200, 180),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(LiqIcons.layers,
                          size: 32, color: context.appleColors.label),
                      const SizedBox(height: 12),
                      Text(
                        label,
                        style: context.textStyles.headline.copyWith(
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: context.textStyles.caption1.secondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
