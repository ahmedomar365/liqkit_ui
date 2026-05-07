import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/bezels/liq_device_bezel.dart';

/// Catalog of device frames supported by [LiqDeviceShowcase].
enum LiqDeviceType {
  iPhone15ProMax,
  iPhone15Pro,
  iPhone15,
  iPhoneSE,
  iPadPro13,
  iPadPro11,
  iPad,
  iPadMini,
  macBookPro16,
  macBookPro14,
  iMac,
  appleWatch,
}

/// Visual + layout spec for a [LiqDeviceType]. Caller-introspectable
/// so consumers can build their own overlays.
@immutable
class LiqDeviceSpec {
  const LiqDeviceSpec({
    required this.name,
    required this.screenSize,
    required this.cornerRadius,
    required this.bezelWidth,
    this.screenPadding = EdgeInsets.zero,
    this.hasDynamicIsland = false,
    this.dynamicIslandSize = const Size(126, 38),
    this.hasNotch = false,
    this.notchSize = const Size(162, 36),
    this.hasHomeIndicator = false,
    this.bezelColor = const Color(0xFF000000),
  });

  final String name;
  final Size screenSize;
  final double cornerRadius;
  final double bezelWidth;
  final EdgeInsets screenPadding;
  final bool hasDynamicIsland;
  final Size dynamicIslandSize;
  final bool hasNotch;
  final Size notchSize;
  final bool hasHomeIndicator;
  final Color bezelColor;

  static LiqDeviceSpec forType(LiqDeviceType type) {
    switch (type) {
      case LiqDeviceType.iPhone15ProMax:
        return const LiqDeviceSpec(
          name: 'iPhone 15 Pro Max',
          screenSize: Size(430, 932),
          screenPadding: EdgeInsets.only(top: 59, bottom: 34),
          cornerRadius: 55,
          bezelWidth: 10,
          hasDynamicIsland: true,
          hasHomeIndicator: true,
        );
      case LiqDeviceType.iPhone15Pro:
        return const LiqDeviceSpec(
          name: 'iPhone 15 Pro',
          screenSize: Size(393, 852),
          screenPadding: EdgeInsets.only(top: 59, bottom: 34),
          cornerRadius: 55,
          bezelWidth: 10,
          hasDynamicIsland: true,
          hasHomeIndicator: true,
        );
      case LiqDeviceType.iPhone15:
        return const LiqDeviceSpec(
          name: 'iPhone 15',
          screenSize: Size(393, 852),
          screenPadding: EdgeInsets.only(top: 59, bottom: 34),
          cornerRadius: 55,
          bezelWidth: 12,
          hasNotch: true,
          hasHomeIndicator: true,
        );
      case LiqDeviceType.iPhoneSE:
        return const LiqDeviceSpec(
          name: 'iPhone SE',
          screenSize: Size(375, 667),
          screenPadding: EdgeInsets.only(top: 20),
          cornerRadius: 0,
          bezelWidth: 16,
        );
      case LiqDeviceType.iPadPro13:
        return const LiqDeviceSpec(
          name: 'iPad Pro 13"',
          screenSize: Size(1032, 1376),
          screenPadding: EdgeInsets.all(24),
          cornerRadius: 38,
          bezelWidth: 14,
        );
      case LiqDeviceType.iPadPro11:
        return const LiqDeviceSpec(
          name: 'iPad Pro 11"',
          screenSize: Size(834, 1194),
          screenPadding: EdgeInsets.all(24),
          cornerRadius: 38,
          bezelWidth: 14,
        );
      case LiqDeviceType.iPad:
        return const LiqDeviceSpec(
          name: 'iPad',
          screenSize: Size(810, 1080),
          screenPadding: EdgeInsets.all(20),
          cornerRadius: 38,
          bezelWidth: 20,
        );
      case LiqDeviceType.iPadMini:
        return const LiqDeviceSpec(
          name: 'iPad mini',
          screenSize: Size(744, 1133),
          screenPadding: EdgeInsets.all(20),
          cornerRadius: 38,
          bezelWidth: 18,
        );
      case LiqDeviceType.macBookPro16:
        return const LiqDeviceSpec(
          name: 'MacBook Pro 16"',
          screenSize: Size(3456, 2234),
          screenPadding:
              EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 8),
          cornerRadius: 28,
          bezelWidth: 8,
          bezelColor: Color(0xFF1D1D1F),
        );
      case LiqDeviceType.macBookPro14:
        return const LiqDeviceSpec(
          name: 'MacBook Pro 14"',
          screenSize: Size(3024, 1964),
          screenPadding:
              EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 8),
          cornerRadius: 28,
          bezelWidth: 8,
          bezelColor: Color(0xFF1D1D1F),
        );
      case LiqDeviceType.iMac:
        return const LiqDeviceSpec(
          name: 'iMac 24"',
          screenSize: Size(4480, 2520),
          screenPadding: EdgeInsets.all(48),
          cornerRadius: 16,
          bezelWidth: 48,
          bezelColor: Color(0xFFF5F5F7),
        );
      case LiqDeviceType.appleWatch:
        return const LiqDeviceSpec(
          name: 'Apple Watch Series 9',
          screenSize: Size(184, 224),
          screenPadding: EdgeInsets.zero,
          cornerRadius: 38,
          bezelWidth: 12,
          bezelColor: Color(0xFF1D1D1F),
        );
    }
  }
}

/// Renders a device frame with its accurate bezel, optional Dynamic
/// Island / notch / home indicator. Wraps the existing
/// [LiqDeviceBezel] for iPhone-with-Dynamic-Island, but also handles
/// iPad / Mac / Watch frames using direct compositing.
final class LiqDeviceShowcase extends StatelessWidget with Diagnosticable {
  /// Creates a device showcase frame.
  const LiqDeviceShowcase({
    required this.deviceType,
    this.scale = 1.0,
    this.showStatusBar = true,
    this.showHomeIndicator = true,
    this.showReflection = false,
    this.screenColor = const Color(0xFFECECEF),
    this.child,
    super.key,
  });

  final LiqDeviceType deviceType;
  final double scale;
  final bool showStatusBar;
  final bool showHomeIndicator;
  final bool showReflection;
  final Color screenColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final spec = LiqDeviceSpec.forType(deviceType);
    // For iPhones with Dynamic Island we delegate to the canonical
    // LiqDeviceBezel. For other devices we render a generic
    // device-shape Container.
    if (spec.hasDynamicIsland) {
      final bezelChild = SizedBox.fromSize(
        size: spec.screenSize,
        child: child,
      );
      return Transform.scale(
        scale: scale,
        child: LiqDeviceBezel(
          size: Size(
            spec.screenSize.width + spec.bezelWidth * 2,
            spec.screenSize.height + spec.bezelWidth * 2,
          ),
          showIsland: showStatusBar,
          screenColor: screenColor,
          child: bezelChild,
        ),
      );
    }
    final w = spec.screenSize.width + spec.bezelWidth * 2;
    final h = spec.screenSize.height + spec.bezelWidth * 2;
    return Transform.scale(
      scale: scale,
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: spec.bezelColor,
          borderRadius:
              BorderRadius.all(Radius.circular(spec.cornerRadius)),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0x33000000), blurRadius: 32, offset: Offset(0, 12)),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(spec.bezelWidth),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(spec.cornerRadius - spec.bezelWidth),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ColoredBox(color: screenColor),
                if (child != null) child!,
                if (spec.hasNotch && showStatusBar)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: spec.notchSize.width,
                        height: spec.notchSize.height,
                        decoration: BoxDecoration(
                          color: spec.bezelColor,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (spec.hasHomeIndicator && showHomeIndicator)
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 134,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0x80000000),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                if (showReflection)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              const Color(0xFFFFFFFF).withValues(alpha: 0.1),
                              const Color(0x00FFFFFF),
                              const Color(0x00FFFFFF),
                              const Color(0xFFFFFFFF).withValues(alpha: 0.05),
                            ],
                            stops: const <double>[0, 0.3, 0.6, 1],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqDeviceType>('deviceType', deviceType))
      ..add(DoubleProperty('scale', scale));
  }
}
