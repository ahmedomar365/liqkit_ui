import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          children: <Widget>[
            _Section(
              title: 'iPhone Bezels',
              description:
                  'Common iPhone form factors with screen, notch, and home indicator chrome.',
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _DevicePreview(deviceType: LiqDeviceType.iPhone15ProMax),
                  _DevicePreview(deviceType: LiqDeviceType.iPhone15Pro),
                  _DevicePreview(deviceType: LiqDeviceType.iPhone15),
                  _DevicePreview(deviceType: LiqDeviceType.iPhoneSE),
                ],
              ),
            ),
            _Section(
              title: 'iPad Bezels',
              description: 'iPad form factors at scaled-down preview sizes.',
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _DevicePreview(deviceType: LiqDeviceType.iPadPro13),
                  _DevicePreview(deviceType: LiqDeviceType.iPadPro11),
                  _DevicePreview(deviceType: LiqDeviceType.iPad),
                  _DevicePreview(deviceType: LiqDeviceType.iPadMini),
                ],
              ),
            ),
            _Section(
              title: 'Mac Bezels',
              description: 'Desktop and laptop chrome variants.',
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _DevicePreview(deviceType: LiqDeviceType.macBookPro16),
                  _DevicePreview(deviceType: LiqDeviceType.macBookPro14),
                  _DevicePreview(deviceType: LiqDeviceType.iMac),
                ],
              ),
            ),
            const _Section(
              title: 'Apple Watch',
              description: 'Wearable form factor.',
              child: Center(
                child: _DevicePreview(deviceType: LiqDeviceType.appleWatch),
              ),
            ),
            _Section(
              title: 'Display Toggles',
              description:
                  'The same device with status bar / home indicator / reflection toggled off.',
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _DevicePreview(
                    deviceType: LiqDeviceType.iPhone15Pro,
                    showStatusBar: false,
                    label: 'No status bar',
                  ),
                  _DevicePreview(
                    deviceType: LiqDeviceType.iPhone15Pro,
                    showHomeIndicator: false,
                    label: 'No home indicator',
                  ),
                  _DevicePreview(
                    deviceType: LiqDeviceType.iPhone15Pro,
                    showReflection: false,
                    label: 'No reflection',
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

class _DevicePreview extends StatelessWidget {
  const _DevicePreview({
    required this.deviceType,
    this.showStatusBar = true,
    this.showHomeIndicator = true,
    this.showReflection = true,
    this.label,
  });

  final LiqDeviceType deviceType;
  final bool showStatusBar;
  final bool showHomeIndicator;
  final bool showReflection;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final spec = LiqDeviceSpec.forType(deviceType);
    const targetWidth = 220.0;
    const targetHeight = 320.0;
    final scaleX = targetWidth / (spec.screenSize.width + spec.bezelWidth * 2);
    final scaleY =
        targetHeight / (spec.screenSize.height + spec.bezelWidth * 2);
    final scale = (scaleX < scaleY ? scaleX : scaleY).clamp(0.05, 1.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: targetWidth,
          height: targetHeight,
          child: Center(
            child: LiqDeviceShowcase(
              deviceType: deviceType,
              scale: scale,
              showStatusBar: showStatusBar,
              showHomeIndicator: showHomeIndicator,
              showReflection: showReflection,
              child: _DemoContent(deviceType: deviceType),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label ?? spec.name,
          style: context.textStyles.footnote.copyWith(
            fontWeight: LiqAppleTypography.semibold,
          ),
        ),
      ],
    );
  }
}

class _DemoContent extends StatelessWidget {
  const _DemoContent({required this.deviceType});

  final LiqDeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    if (deviceType == LiqDeviceType.appleWatch) return _watchContent(context);
    if (deviceType == LiqDeviceType.macBookPro16 ||
        deviceType == LiqDeviceType.macBookPro14 ||
        deviceType == LiqDeviceType.iMac) {
      return _desktopContent(context);
    }
    return _mobileContent(context);
  }

  Widget _mobileContent(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFFFFFFF),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 70, 16, 50),
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    context.appleColors.blue,
                    context.appleColors.purple,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.appleColors.systemGroupedBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.appleColors.blue
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          LiqIcons.star,
                          color: context.appleColors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Item ${i + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: context.appleColors.label,
                              ),
                            ),
                            Text(
                              'Subtitle text',
                              style: TextStyle(
                                color: context.appleColors.gray,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(LiqMaterialIcons.chevronRight,
                          color: context.appleColors.gray),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _watchContent(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF000000),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.appleColors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LiqMaterialIcons.favorite,
                color: Color(0xFFFFFFFF),
                size: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '120',
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'BPM',
              style: TextStyle(
                color: LiqColors.white.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _desktopContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF1C1C1E),
            Color(0xFF000000),
          ],
        ),
      ),
      child: const Center(
        child: Text(
          'macOS Desktop',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
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
