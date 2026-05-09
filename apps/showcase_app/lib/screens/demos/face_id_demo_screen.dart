import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class FaceIDDemoScreen extends ConsumerStatefulWidget {
  const FaceIDDemoScreen({super.key});

  @override
  ConsumerState<FaceIDDemoScreen> createState() => _FaceIDDemoScreenState();
}

class _FaceIDDemoScreenState extends ConsumerState<FaceIDDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Face ID & Touch ID')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'Face ID — Inline',
              description:
                  'Inline Face ID authentication view with success and alternative-auth callbacks.',
              child: FaceIdInlineExample(),
            ),
            _Section(
              title: 'Touch ID — Sensor',
              description:
                  'Touch the sensor glyph to scan. Auto-starts the simulated authentication flow.',
              child: TouchIdSensorExample(),
            ),
            _Section(
              title: 'Bezel States',
              description:
                  'Every available state of the Face ID bezel glyph in one row.',
              child: FaceIdBezelStatesExample(),
            ),
            _Section(
              title: 'Theme Colors',
              description:
                  'The same Face ID view tinted to a few common system colors.',
              child: FaceIdThemeColorsExample(),
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
