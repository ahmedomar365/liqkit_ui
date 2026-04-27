import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Visual style for a [LiqAlertAction].
///
/// Sourced from `native/shared-surfaces.css` (`.ios26-dialog-action`).
enum LiqAlertActionStyle {
  /// Default action: light translucent fill, black label.
  regular,

  /// Primary action: solid system-blue fill, white label.
  filled,

  /// Destructive action: light translucent fill, red label.
  destructive,
}

/// How the action row is laid out inside a [LiqAlert].
enum LiqAlertActionLayout {
  /// Vertical stack (one action per row, 10pt gap).
  stacked,

  /// Two equal-width actions side-by-side (16pt gap).
  sideBySide,
}

/// Single action in a [LiqAlert] dialog.
final class LiqAlertAction {
  /// Creates an action.
  const LiqAlertAction({
    required this.label,
    this.onPressed,
    this.style = LiqAlertActionStyle.regular,
  });

  /// Action label.
  final String label;

  /// Tap callback. When null the action is rendered disabled.
  final VoidCallback? onPressed;

  /// Visual style.
  final LiqAlertActionStyle style;
}

/// iOS 26 alert dialog (300pt translucent surface, title/description, actions).
final class LiqAlert extends StatelessWidget {
  /// Creates an alert.
  const LiqAlert({
    required this.title,
    required this.actions,
    this.description,
    this.layout = LiqAlertActionLayout.stacked,
    super.key,
  });

  /// Bold centered title.
  final String title;

  /// Optional description below the title.
  final String? description;

  /// Action buttons (≥1).
  final List<LiqAlertAction> actions;

  /// Layout for the action row.
  final LiqAlertActionLayout layout;

  static const Color _surfaceFill = Color(0x99F5F5F5);
  static const Color _innerScrim = Color(0x14000000);
  static const double _surfaceWidth = 300;
  static const double _surfaceRadius = 34;
  static const Color _titleColor = Color(0xFF000000);
  static const TextStyle _titleStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    height: 22 / 17,
    letterSpacing: -0.43,
    fontWeight: FontWeight.w600,
    color: _titleColor,
  );
  static const TextStyle _descriptionStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    height: 22 / 17,
    letterSpacing: -0.43,
    fontWeight: FontWeight.w400,
    color: _titleColor,
  );

  @override
  Widget build(BuildContext context) {
    assert(actions.isNotEmpty, 'LiqAlert requires at least one action.');
    assert(
      layout != LiqAlertActionLayout.sideBySide || actions.length == 2,
      'sideBySide layout requires exactly two actions.',
    );
    return SizedBox(
      width: _surfaceWidth,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(_surfaceRadius)),
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: ColoredBox(color: _innerScrim)),
            const Positioned.fill(child: ColoredBox(color: _surfaceFill)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: _titleStyle,
                          textDirection: TextDirection.ltr,
                        ),
                        if (description != null) ...<Widget>[
                          const SizedBox(height: 10),
                          Text(
                            description!,
                            textAlign: TextAlign.center,
                            style: _descriptionStyle,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ],
                    ),
                  ),
                  _buildActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    if (layout == LiqAlertActionLayout.sideBySide) {
      return Row(
        children: <Widget>[
          for (var i = 0; i < actions.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 16),
            Expanded(child: _LiqAlertActionButton(action: actions[i])),
          ],
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < actions.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: 10),
          _LiqAlertActionButton(action: actions[i]),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('description', description))
      ..add(IntProperty('actionCount', actions.length))
      ..add(EnumProperty<LiqAlertActionLayout>('layout', layout));
  }
}

class _LiqAlertActionButton extends StatelessWidget {
  const _LiqAlertActionButton({required this.action});

  final LiqAlertAction action;

  static const Color _bg = Color(0x29787880);
  static const Color _filledBg = Color(0xFF0088FF);
  static const Color _filledFg = Color(0xFFFFFFFF);
  static const Color _destructiveFg = Color(0xFFFF383C);
  static const Color _regularFg = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    final isFilled = action.style == LiqAlertActionStyle.filled;
    final isDestructive = action.style == LiqAlertActionStyle.destructive;
    final disabled = action.onPressed == null;
    final fg =
        isFilled ? _filledFg : (isDestructive ? _destructiveFg : _regularFg);
    final bg = isFilled ? _filledBg : _bg;
    return Semantics(
      button: true,
      enabled: !disabled,
      label: action.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: action.onPressed,
        child: Opacity(
          opacity: disabled ? 0.5 : 1,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
            alignment: Alignment.center,
            child: Text(
              action.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                fontSize: 17,
                height: 22 / 17,
                letterSpacing: -0.43,
                fontWeight: FontWeight.w500,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
