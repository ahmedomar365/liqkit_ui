import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          children: <Widget>[
            _Section(
              title: 'Face ID — Inline',
              description:
                  'Inline Face ID authentication view with success and alternative-auth callbacks.',
              child: LiqFaceIdView(
                autoStart: true,
                showAlternative: true,
                themeColor: context.appleColors.blue,
                onSuccess: () => LiqToastOverlay.show(
                  context,
                  'Face ID success',
                  variant: LiqToastVariant.success,
                ),
                onAlternative: () => LiqToastOverlay.show(
                  context,
                  'Alternative auth requested',
                ),
              ),
            ),
            _Section(
              title: 'Touch ID — Sensor',
              description:
                  'Touch the sensor glyph to scan. Auto-starts the simulated authentication flow.',
              child: Column(
                children: <Widget>[
                  LiqTouchIdSensor(
                    autoStart: true,
                    themeColor: context.appleColors.blue,
                    onSuccess: () => LiqToastOverlay.show(
                      context,
                      'Touch ID success',
                      variant: LiqToastVariant.success,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Touch the sensor to scan',
                    style: context.textStyles.subheadline.secondary,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Bezel States',
              description:
                  'Every available state of the Face ID bezel glyph in one row.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  for (final state in LiqFaceIdState.values)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        LiqFaceIdBezel(
                          state: state,
                          size: 56,
                          glyphColor: context.appleColors.blue,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          state.name,
                          style: context.textStyles.caption2.secondary,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Theme Colors',
              description: 'The same Face ID view tinted to a few common system colors.',
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  for (final entry in <({String name, Color color})>[
                    (name: 'Blue', color: context.appleColors.blue),
                    (name: 'Green', color: context.appleColors.green),
                    (name: 'Purple', color: context.appleColors.purple),
                    (name: 'Red', color: context.appleColors.red),
                  ])
                    SizedBox(
                      width: 220,
                      child: Column(
                        children: <Widget>[
                          LiqFaceIdBezel(
                            state: LiqFaceIdState.scanning,
                            size: 72,
                            glyphColor: entry.color,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry.name,
                            style: context.textStyles.footnote.copyWith(
                              fontWeight: LiqAppleTypography.semibold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
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
