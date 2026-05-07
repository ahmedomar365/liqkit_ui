import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/face_id/liq_face_id.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Lifecycle states for [LiqFaceIdView] / [LiqTouchIdSensor].
enum LiqAuthState {
  /// Awaiting user trigger.
  idle,

  /// Active scan in progress.
  scanning,

  /// Auth succeeded.
  success,

  /// Auth failed.
  failed,
}

/// Bezel + status text + optional alternative-auth link below. Drives
/// [LiqFaceIdBezel] from a [LiqAuthState] machine.
final class LiqFaceIdView extends StatefulWidget with Diagnosticable {
  /// Creates a Face ID view.
  const LiqFaceIdView({
    this.autoStart = false,
    this.themeColor,
    this.titleIdle = 'Face ID',
    this.titleScanning = 'Scanning…',
    this.titleSuccess = 'Authenticated',
    this.titleFailed = 'Try Again',
    this.alternativeAuthLabel = 'Use Passcode',
    this.showAlternative = true,
    this.bezelSize = 145,
    this.onSuccess,
    this.onFailed,
    this.onAlternative,
    this.scanDuration = const Duration(seconds: 2),
    super.key,
  });

  final bool autoStart;
  final Color? themeColor;
  final String titleIdle;
  final String titleScanning;
  final String titleSuccess;
  final String titleFailed;
  final String alternativeAuthLabel;
  final bool showAlternative;
  final double bezelSize;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailed;
  final VoidCallback? onAlternative;
  final Duration scanDuration;

  @override
  State<LiqFaceIdView> createState() => _LiqFaceIdViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('autoStart', value: autoStart, ifTrue: 'auto'))
      ..add(ColorProperty('themeColor', themeColor));
  }
}

class _LiqFaceIdViewState extends State<LiqFaceIdView> {
  LiqAuthState _state = LiqAuthState.idle;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _state = LiqAuthState.scanning);
    _timer = Timer(widget.scanDuration, () {
      if (!mounted) return;
      setState(() => _state = LiqAuthState.success);
      widget.onSuccess?.call();
    });
  }

  // ignore: unused_element
  void _fail() {
    _timer?.cancel();
    setState(() => _state = LiqAuthState.failed);
    widget.onFailed?.call();
  }

  void _reset() => setState(() => _state = LiqAuthState.idle);

  LiqFaceIdState get _bezelState => switch (_state) {
        LiqAuthState.idle => LiqFaceIdState.idle,
        LiqAuthState.scanning => LiqFaceIdState.scanning,
        LiqAuthState.success => LiqFaceIdState.success,
        LiqAuthState.failed => LiqFaceIdState.fail,
      };

  String get _title => switch (_state) {
        LiqAuthState.idle => widget.titleIdle,
        LiqAuthState.scanning => widget.titleScanning,
        LiqAuthState.success => widget.titleSuccess,
        LiqAuthState.failed => widget.titleFailed,
      };

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final titleStyle = LiqAppleTypography.headline(brightness).copyWith(
      fontWeight: LiqAppleTypography.semibold,
    );
    final altStyle = LiqAppleTypography.body(brightness).copyWith(
      color: widget.themeColor ?? const Color(0xFF007AFF),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: _state == LiqAuthState.idle
              ? _start
              : _state == LiqAuthState.failed
                  ? _start
                  : null,
          child: LiqFaceIdBezel(
            state: _bezelState,
            size: widget.bezelSize,
            glyphColor: widget.themeColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(_title, style: titleStyle),
        const SizedBox(height: 8),
        if (_state == LiqAuthState.scanning)
          Text('Hold device steady', style: LiqAppleTypography.subheadline(brightness))
        else if (_state == LiqAuthState.failed)
          GestureDetector(
            onTap: _start,
            child: Text('Tap to retry', style: altStyle),
          ),
        if (widget.showAlternative) ...<Widget>[
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              widget.onAlternative?.call();
              _reset();
            },
            child: Text(widget.alternativeAuthLabel, style: altStyle),
          ),
        ],
      ],
    );
  }
}

/// Touch ID-style fingerprint sensor circle with auth state machine.
final class LiqTouchIdSensor extends StatefulWidget with Diagnosticable {
  /// Creates a Touch ID sensor view.
  const LiqTouchIdSensor({
    this.autoStart = false,
    this.themeColor,
    this.size = 110,
    this.scanDuration = const Duration(seconds: 2),
    this.onSuccess,
    this.onFailed,
    super.key,
  });

  final bool autoStart;
  final Color? themeColor;
  final double size;
  final Duration scanDuration;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailed;

  @override
  State<LiqTouchIdSensor> createState() => _LiqTouchIdSensorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('themeColor', themeColor));
  }
}

class _LiqTouchIdSensorState extends State<LiqTouchIdSensor>
    with SingleTickerProviderStateMixin {
  LiqAuthState _state = LiqAuthState.idle;
  Timer? _timer;
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _state = LiqAuthState.scanning);
    _pulse.repeat(reverse: true);
    _timer = Timer(widget.scanDuration, () {
      if (!mounted) return;
      _pulse.stop();
      setState(() => _state = LiqAuthState.success);
      widget.onSuccess?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.themeColor ?? const Color(0xFF007AFF);
    final base = const Color(0xFFE5E5EA);
    return GestureDetector(
      onTap: _state == LiqAuthState.idle ? _start : null,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          final t = _pulse.value;
          final fillColor = _state == LiqAuthState.scanning
              ? Color.lerp(base, accent, t)
              : _state == LiqAuthState.success
                  ? accent
                  : base;
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: fillColor,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: accent.withValues(
                    alpha: _state == LiqAuthState.scanning ? 0.4 * t : 0,
                  ),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: Size.square(widget.size * 0.55),
                painter: _FingerprintPainter(
                  color: _state == LiqAuthState.success
                      ? const Color(0xFFFFFFFF)
                      : accent.withValues(
                          alpha: _state == LiqAuthState.scanning ? 1.0 : 0.5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FingerprintPainter extends CustomPainter {
  const _FingerprintPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2;
    final cy = size.height / 2;
    for (var i = 0; i < 5; i++) {
      final r = size.width * (0.18 + i * 0.08);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        -2.4,
        4.8,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FingerprintPainter old) => color != old.color;
}
