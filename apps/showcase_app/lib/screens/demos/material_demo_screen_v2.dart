import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class MaterialDemoScreenV2 extends ConsumerStatefulWidget {
  const MaterialDemoScreenV2({super.key});

  @override
  ConsumerState<MaterialDemoScreenV2> createState() =>
      _MaterialDemoScreenV2State();
}

class _MaterialDemoScreenV2State extends ConsumerState<MaterialDemoScreenV2> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Materials')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'All Material Styles',
              description:
                  'Each preset rendered over a colorful gradient background to show its translucency.',
              child: MaterialsAllStylesExample(),
            ),
            _Section(
              title: 'Custom Configuration',
              description:
                  'A regular material with explicit blur, opacity, and tint overrides.',
              child: MaterialsCustomConfigurationExample(),
            ),
            _Section(
              title: 'Vibrancy Off',
              description: 'Same regular material with vibrancy disabled.',
              child: MaterialsVibrancyOffExample(),
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
