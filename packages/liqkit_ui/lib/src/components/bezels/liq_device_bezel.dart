import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 device bezel — iPhone-style outer chrome with optional Dynamic
/// Island.
///
/// Sourced from `native/components/bezels.css`:
/// 402×874 default, 56pt outer radius, dark gradient body, inner light
/// rim + dark mid-rim, 46pt inner screen radius. Renders a 111×37 black
/// "Dynamic Island" pill at top + a small camera dot when [showIsland] is
/// true. The `child` is clipped to the inner screen rounded rect.
final class LiqDeviceBezel extends StatelessWidget {
  /// Creates a device bezel.
  const LiqDeviceBezel({
    this.size = const Size(402, 874),
    this.showIsland = true,
    this.screenColor = const Color(0xFFECECEF),
    this.child,
    super.key,
  });

  /// Outer dimensions.
  final Size size;

  /// When true, renders a Dynamic Island pill + camera dot on top of [child].
  final bool showIsland;

  /// Background color of the inner screen.
  final Color screenColor;

  /// Optional content rendered inside the screen rect.
  final Widget? child;

  static const Color _outerRimLight = Color(0x57FFFFFF);
  static const Color _outerRimDark = Color(0xE606070B);
  static const Color _shadow = Color(0x4D07090E);
  static const Color _islandBg = Color(0xFF090909);
  static const Color _islandRim = Color(0x0AFFFFFF);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(56)),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(56)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF2F323A),
                Color(0xFF101217),
                Color(0xFF262A33),
              ],
              stops: <double>[0, 0.46, 1],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: _shadow,
                offset: Offset(0, 20),
                blurRadius: 42,
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(56)),
                    border: Border.fromBorderSide(
                      BorderSide(color: _outerRimLight),
                    ),
                  ),
                ),
              ),
              const Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(54)),
                      border: Border.fromBorderSide(
                        BorderSide(color: _outerRimDark, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                top: 10,
                bottom: 10,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(46)),
                  child: ColoredBox(
                    color: screenColor,
                    child: child ?? const SizedBox.expand(),
                  ),
                ),
              ),
              if (showIsland) ...<Widget>[
                Positioned(
                  top: 23,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 111,
                      height: 37,
                      decoration: const BoxDecoration(
                        color: _islandBg,
                        borderRadius:
                            BorderRadius.all(Radius.circular(24)),
                        border: Border.fromBorderSide(
                          BorderSide(color: _islandRim),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 39,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(left: 80),
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(-0.4, -0.4),
                          colors: <Color>[
                            Color(0xFF2754FF),
                            Color(0xFF0D1A45),
                            Color(0xFF07080F),
                          ],
                          stops: <double>[0, 0.42, 1],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Size>('size', size))
      ..add(FlagProperty('showIsland',
          value: showIsland, ifTrue: 'with island'));
  }
}
