/// Canonical Face ID + Touch ID variants — single source of truth for
/// the showcase app and the liqkit.com previews.
///
/// Faithful 1:1 reproductions of every `_Section(...)` from
/// `apps/showcase_app/lib/screens/demos/face_id_demo_screen.dart`.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/face_id/liq_auth_view.dart';
import 'package:liqkit_ui/src/components/face_id/liq_face_id.dart';
import 'package:liqkit_ui/src/components/toasts/liq_toast.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';

/// Inline Face ID authentication view with success and
/// alternative-auth callbacks.
final class FaceIdInlineExample extends StatelessWidget {
  const FaceIdInlineExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqFaceIdView(
      autoStart: true,
      showAlternative: true,
      themeColor: context.appleColors.blue,
      onSuccess: () => LiqToastOverlay.show(
        context,
        'Face ID success',
        variant: LiqToastVariant.success,
      ),
      onAlternative: () =>
          LiqToastOverlay.show(context, 'Alternative auth requested'),
    );
  }
}

/// Touch ID sensor with auto-started simulated authentication.
final class TouchIdSensorExample extends StatelessWidget {
  const TouchIdSensorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

/// Every available state of the Face ID bezel glyph in one row.
final class FaceIdBezelStatesExample extends StatelessWidget {
  const FaceIdBezelStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
              Text(state.name, style: context.textStyles.caption2.secondary),
            ],
          ),
      ],
    );
  }
}

/// The same Face ID view tinted to a few common system colors.
final class FaceIdThemeColorsExample extends StatelessWidget {
  const FaceIdThemeColorsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
    );
  }
}
