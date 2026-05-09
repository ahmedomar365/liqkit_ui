import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class DeviceBezelDemoScreenV2 extends ConsumerStatefulWidget {
  const DeviceBezelDemoScreenV2({super.key});

  @override
  ConsumerState<DeviceBezelDemoScreenV2> createState() =>
      _DeviceBezelDemoScreenV2State();
}

class _DeviceBezelDemoScreenV2State
    extends ConsumerState<DeviceBezelDemoScreenV2> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Device Bezels')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'iPhone Bezels',
              description:
                  'Common iPhone form factors with screen, notch, and home indicator chrome.',
              child: DeviceBezelIphoneExample(),
            ),
            _Section(
              title: 'iPad Bezels',
              description: 'iPad form factors at scaled-down preview sizes.',
              child: DeviceBezelIpadExample(),
            ),
            _Section(
              title: 'Mac Bezels',
              description: 'Desktop and laptop chrome variants.',
              child: DeviceBezelMacExample(),
            ),
            _Section(
              title: 'Apple Watch',
              description: 'Wearable form factor.',
              child: DeviceBezelAppleWatchExample(),
            ),
            _Section(
              title: 'Display Toggles',
              description:
                  'The same device with status bar / home indicator / reflection toggled off.',
              child: DeviceBezelDisplayTogglesExample(),
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
