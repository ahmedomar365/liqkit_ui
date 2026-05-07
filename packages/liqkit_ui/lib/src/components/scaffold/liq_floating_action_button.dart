import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';

/// iOS 26 floating action button.
///
/// Circular glass button typically anchored to the bottom-end of a
/// `LiqScaffold`. Matches the Material `FloatingActionButton` shape but
/// renders via [LiqGlassSurface] for the iOS 26 aesthetic.
final class LiqFloatingActionButton extends StatelessWidget {
  /// Creates a FAB.
  const LiqFloatingActionButton({
    required this.child,
    required this.onPressed,
    this.semanticLabel,
    this.mini = false,
    this.tint = LiqGlassTint.light,
    super.key,
  });

  /// Inner glyph (typically `Icon(LiqIcons.plus)`).
  final Widget child;

  /// Tap callback. When `null`, the button renders disabled.
  final VoidCallback? onPressed;

  /// Accessibility label.
  final String? semanticLabel;

  /// When true, renders as a 40px mini FAB instead of the 56px default.
  final bool mini;

  /// Glass tint preset.
  final LiqGlassTint tint;

  @override
  Widget build(BuildContext context) {
    final size = mini ? 40.0 : 56.0;
    final radius = BorderRadius.circular(size / 2);
    final disabled = onPressed == null;

    return Semantics(
      button: true,
      enabled: !disabled,
      label: semanticLabel,
      child: LiqPointerCursor(
        child: GestureDetector(
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: LiqGlassSurface(
              tint: tint,
              borderRadius: radius,
              child: child,
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
      ..add(EnumProperty<LiqGlassTint>('tint', tint))
      ..add(FlagProperty('mini', value: mini, ifTrue: 'mini'))
      ..add(StringProperty('semanticLabel', semanticLabel, defaultValue: null))
      ..add(
        FlagProperty(
          'enabled',
          value: onPressed != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}
