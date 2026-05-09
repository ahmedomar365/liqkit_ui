/// Canonical material variants — single source of truth for the showcase
/// app and the liqkit.com previews. Faithful 1:1 reproductions of every
/// `_Section(...)` from
/// `apps/showcase_app/lib/screens/demos/material_demo_screen_v2.dart`.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/materials/liq_material_chip.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

const List<({LiqMaterialStyle value, String label, String desc})>
    _kMaterialOptions = <({
  LiqMaterialStyle value,
  String label,
  String desc,
})>[
  (value: LiqMaterialStyle.ultraThin, label: 'Ultra Thin', desc: 'Minimal blur'),
  (value: LiqMaterialStyle.thin, label: 'Thin', desc: 'Light blur'),
  (value: LiqMaterialStyle.regular, label: 'Regular', desc: 'Standard blur'),
  (value: LiqMaterialStyle.thick, label: 'Thick', desc: 'Heavy blur'),
  (value: LiqMaterialStyle.chrome, label: 'Chrome', desc: 'Heaviest blur'),
  (value: LiqMaterialStyle.sidebar, label: 'Sidebar', desc: 'Sidebar surface'),
  (value: LiqMaterialStyle.headerBlur, label: 'Header Blur', desc: 'Header / toolbar'),
  (value: LiqMaterialStyle.fullScreenUI, label: 'Full Screen UI', desc: 'Full overlay'),
  (value: LiqMaterialStyle.hudWindow, label: 'HUD Window', desc: 'High contrast'),
  (value: LiqMaterialStyle.tooltip, label: 'Tooltip', desc: 'Tooltips'),
  (value: LiqMaterialStyle.menu, label: 'Menu', desc: 'Dropdown menus'),
  (value: LiqMaterialStyle.popover, label: 'Popover', desc: 'Popovers'),
  (value: LiqMaterialStyle.sheet, label: 'Sheet', desc: 'Modal sheets'),
  (value: LiqMaterialStyle.windowBackground, label: 'Window Background', desc: 'Window backgrounds'),
  (value: LiqMaterialStyle.contentBackground, label: 'Content Background', desc: 'Content areas'),
];

/// One labeled tile previewing a material style over a colorful gradient.
final class MaterialPreviewTile extends StatelessWidget {
  const MaterialPreviewTile({
    required this.style,
    required this.label,
    required this.description,
    this.config,
    super.key,
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
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  size: const Size(200, 180),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        LiqIcons.layers,
                        size: 32,
                        color: context.appleColors.label,
                      ),
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

/// Each `LiqMaterialStyle` preset rendered over a colorful gradient.
final class MaterialsAllStylesExample extends StatelessWidget {
  const MaterialsAllStylesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: <Widget>[
        for (final opt in _kMaterialOptions)
          MaterialPreviewTile(
            style: opt.value,
            label: opt.label,
            description: opt.desc,
          ),
      ],
    );
  }
}

/// A regular material with explicit blur, opacity, and tint overrides.
final class MaterialsCustomConfigurationExample extends StatelessWidget {
  const MaterialsCustomConfigurationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialPreviewTile(
      style: LiqMaterialStyle.regular,
      label: 'Custom',
      description: 'blur: 30 · tint: 0.4 · saturation: 1.5',
      config: LiqMaterialConfig(
        blurRadius: 30,
        tintOpacity: 0.4,
        saturation: 1.5,
      ),
    );
  }
}

/// Same regular material with vibrancy disabled.
final class MaterialsVibrancyOffExample extends StatelessWidget {
  const MaterialsVibrancyOffExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialPreviewTile(
      style: LiqMaterialStyle.regular,
      label: 'No Vibrancy',
      description: 'vibrancy: false',
      config: LiqMaterialConfig(vibrancy: false),
    );
  }
}
