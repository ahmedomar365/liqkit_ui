import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/color_pickers/liq_color_picker.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Modal-route convenience wrapper around [LiqColorPickerPanel].
/// Returns the selected color when the user taps Done, or null if
/// dismissed.
final class LiqColorPickerModal {
  LiqColorPickerModal._();

  /// Opens a modal route hosting a [LiqColorPickerPanel].
  static Future<Color?> show({
    required BuildContext context,
    Color initialColor = const Color(0xFF007AFF),
    String? title,
    List<Color> presetColors = liqDefaultColorPickerColors,
    bool barrierDismissible = true,
  }) {
    return Navigator.of(context).push<Color?>(
      _LiqColorPickerModalRoute(
        initialColor: initialColor,
        title: title,
        presetColors: presetColors,
        barrierDismissible: barrierDismissible,
      ),
    );
  }
}

class _LiqColorPickerModalRoute extends ModalRoute<Color?> {
  _LiqColorPickerModalRoute({
    required this.initialColor,
    required this.title,
    required this.presetColors,
    bool barrierDismissible = true,
  }) : _barrierDismissible = barrierDismissible;

  final Color initialColor;
  final String? title;
  final List<Color> presetColors;
  final bool _barrierDismissible;

  @override
  Color? get barrierColor => const Color(0x80000000);
  @override
  bool get barrierDismissible => _barrierDismissible;
  @override
  String? get barrierLabel => 'color picker';
  @override
  bool get opaque => false;
  @override
  bool get maintainState => true;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        ),
        child: Center(
          child: _LiqColorPickerModalBody(
            initialColor: initialColor,
            title: title,
            presetColors: presetColors,
          ),
        ),
      ),
    );
  }
}

class _LiqColorPickerModalBody extends StatefulWidget {
  const _LiqColorPickerModalBody({
    required this.initialColor,
    required this.title,
    required this.presetColors,
  });

  final Color initialColor;
  final String? title;
  final List<Color> presetColors;

  @override
  State<_LiqColorPickerModalBody> createState() =>
      _LiqColorPickerModalBodyState();
}

class _LiqColorPickerModalBodyState extends State<_LiqColorPickerModalBody> {
  late Color _color = widget.initialColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final titleColor =
        isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: LiqGlassSurface(
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (widget.title != null) ...<Widget>[
                Text(
                  widget.title!,
                  textAlign: TextAlign.center,
                  style: LiqAppleTypography.headline(brightness).copyWith(
                    color: titleColor,
                    fontWeight: LiqAppleTypography.semibold,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 480),
                child: SingleChildScrollView(
                  child: LiqColorPickerPanel(
                    color: _color,
                    savedColors: widget.presetColors,
                    onChanged: (c) => setState(() => _color = c),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: LiqButton(
                      label: 'Cancel',
                      style: LiqButtonStyle.borderedSecondary,
                      onPressed: () => Navigator.of(context).pop<Color?>(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LiqButton(
                      label: 'Done',
                      onPressed: () =>
                          Navigator.of(context).pop<Color?>(_color),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple chip-style button — a colored circle/square showing the
/// currently selected color, optional bordered ring, optional label
/// underneath. Convenient for inline color-pick triggers (e.g.
/// "Primary" / "Accent" swatch pickers).
final class LiqColorChipButton extends StatelessWidget with Diagnosticable {
  /// Creates a color chip.
  const LiqColorChipButton({
    required this.color,
    this.onTap,
    this.size = 44,
    this.label,
    this.showBorder = true,
    super.key,
  });

  final Color color;
  final VoidCallback? onTap;
  final double size;
  final String? label;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final borderColor = isDark
        ? const Color(0x33EBEBF5)
        : const Color(0x1A3C3C43);
    final chip = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: showBorder ? Border.all(color: borderColor, width: 2) : null,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
    if (label == null) return chip;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        chip,
        const SizedBox(height: 4),
        Text(
          label!,
          style: LiqAppleTypography.caption2(brightness),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(StringProperty('label', label))
      ..add(DoubleProperty('size', size));
  }
}
