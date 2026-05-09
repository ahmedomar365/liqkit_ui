/// Canonical device-bezel variants — single source of truth for the
/// showcase app and the liqkit.com previews.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/bezels/liq_device_bezel.dart';
import 'package:liqkit_ui/src/components/bezels/liq_device_bezel_extras.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/foundation/liq_colors.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

class _DemoContent extends StatelessWidget {
  const _DemoContent({required this.deviceType});

  final LiqDeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    if (deviceType == LiqDeviceType.appleWatch) return _watch(context);
    if (deviceType == LiqDeviceType.macBookPro16 ||
        deviceType == LiqDeviceType.macBookPro14 ||
        deviceType == LiqDeviceType.iMac) {
      return _desktop(context);
    }
    return _mobile(context);
  }

  Widget _mobile(BuildContext context) {
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
                      Icon(
                        LiqMaterialIcons.chevronRight,
                        color: context.appleColors.gray,
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

  Widget _watch(BuildContext context) {
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

  Widget _desktop(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF1C1C1E), Color(0xFF000000)],
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

/// One labeled device-bezel preview tile, scaled to fit a fixed box.
final class DeviceBezelPreviewTile extends StatelessWidget {
  const DeviceBezelPreviewTile({
    required this.deviceType,
    this.showStatusBar = true,
    this.showHomeIndicator = true,
    this.showReflection = true,
    this.label,
    super.key,
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
    final scaleX =
        targetWidth / (spec.screenSize.width + spec.bezelWidth * 2);
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

/// Common iPhone form factors with screen, notch, and home indicator chrome.
final class DeviceBezelIphoneExample extends StatelessWidget {
  const DeviceBezelIphoneExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: <Widget>[
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.iPhone15ProMax),
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.iPhone15Pro),
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.iPhone15),
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.iPhoneSE),
      ],
    );
  }
}

/// iPad form factors at scaled-down preview sizes.
final class DeviceBezelIpadExample extends StatelessWidget {
  const DeviceBezelIpadExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: <Widget>[
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.iPadPro13),
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.iPadPro11),
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.iPad),
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.iPadMini),
      ],
    );
  }
}

/// Desktop and laptop chrome variants.
final class DeviceBezelMacExample extends StatelessWidget {
  const DeviceBezelMacExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: <Widget>[
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.macBookPro16),
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.macBookPro14),
        DeviceBezelPreviewTile(deviceType: LiqDeviceType.iMac),
      ],
    );
  }
}

/// Wearable form factor.
final class DeviceBezelAppleWatchExample extends StatelessWidget {
  const DeviceBezelAppleWatchExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: DeviceBezelPreviewTile(deviceType: LiqDeviceType.appleWatch),
    );
  }
}

/// The same device with status bar / home indicator / reflection toggled off.
final class DeviceBezelDisplayTogglesExample extends StatelessWidget {
  const DeviceBezelDisplayTogglesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: <Widget>[
        DeviceBezelPreviewTile(
          deviceType: LiqDeviceType.iPhone15Pro,
          showStatusBar: false,
          label: 'No status bar',
        ),
        DeviceBezelPreviewTile(
          deviceType: LiqDeviceType.iPhone15Pro,
          showHomeIndicator: false,
          label: 'No home indicator',
        ),
        DeviceBezelPreviewTile(
          deviceType: LiqDeviceType.iPhone15Pro,
          showReflection: false,
          label: 'No reflection',
        ),
      ],
    );
  }
}
