import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

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

/// Single action in a [LiqAlert] dialog or [LiqActionSheet].
final class LiqAlertAction {
  /// Creates an action.
  const LiqAlertAction({
    required this.label,
    this.onPressed,
    this.style = LiqAlertActionStyle.regular,
    this.icon,
  });

  /// Action label.
  final String label;

  /// Tap callback. When null the action is rendered disabled.
  final VoidCallback? onPressed;

  /// Visual style.
  final LiqAlertActionStyle style;

  /// Optional leading glyph rendered before the label (action sheets).
  final IconData? icon;
}

/// iOS 26 alert dialog (300pt translucent surface, title/description, actions).
final class LiqAlert extends StatelessWidget {
  /// Creates an alert.
  const LiqAlert({
    required this.title,
    required this.actions,
    this.description,
    this.content,
    this.layout = LiqAlertActionLayout.stacked,
    super.key,
  });

  /// Show this alert as a centered modal dialog with a translucent
  /// scrim. Returns the value an action's `onPressed` pops with.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<LiqAlertAction> actions,
    String? description,
    Widget? content,
    LiqAlertActionLayout layout = LiqAlertActionLayout.stacked,
    bool barrierDismissible = true,
  }) {
    return Navigator.of(context).push<T>(
      _LiqAlertRoute<T>(
        title: title,
        description: description,
        content: content,
        actions: actions,
        layout: layout,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// Convenience: single-button informational alert. Resolves when the
  /// dialog is dismissed.
  static Future<void> showMessage({
    required BuildContext context,
    required String title,
    String? description,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return show<void>(
      context: context,
      title: title,
      description: description,
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: buttonText,
          style: LiqAlertActionStyle.filled,
          onPressed: () {
            Navigator.of(context).pop();
            onPressed?.call();
          },
        ),
      ],
    );
  }

  /// Convenience: red-styled single-button error alert.
  static Future<void> showError({
    required BuildContext context,
    required String title,
    String? description,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return show<void>(
      context: context,
      title: title,
      description: description,
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: buttonText,
          style: LiqAlertActionStyle.destructive,
          onPressed: () {
            Navigator.of(context).pop();
            onPressed?.call();
          },
        ),
      ],
    );
  }

  /// Convenience: two-button confirmation alert. Resolves to `true` if
  /// the user taps the confirm action, `false` if the cancel action,
  /// `null` if dismissed.
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    String? description,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    LiqAlertActionLayout layout = LiqAlertActionLayout.sideBySide,
  }) {
    return show<bool>(
      context: context,
      title: title,
      description: description,
      layout: layout,
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: cancelText,
          onPressed: () => Navigator.of(context).pop<bool>(false),
        ),
        LiqAlertAction(
          label: confirmText,
          style: isDestructive
              ? LiqAlertActionStyle.destructive
              : LiqAlertActionStyle.filled,
          onPressed: () => Navigator.of(context).pop<bool>(true),
        ),
      ],
    );
  }

  /// Bold centered title.
  final String title;

  /// Optional description below the title.
  final String? description;

  /// Optional custom widget rendered below the description and above
  /// the action row (e.g. a text field, a chart, an indicator stack).
  final Widget? content;

  /// Action buttons (≥1).
  final List<LiqAlertAction> actions;

  /// Layout for the action row.
  final LiqAlertActionLayout layout;

  static const Color _surfaceFill = Color(0x99F5F5F5);
  static const Color _surfaceFillDark = Color(0xCC1C1C1E);
  static const Color _innerScrim = Color(0x14000000);
  static const Color _innerScrimDark = Color(0x24FFFFFF);
  static const double _surfaceWidth = 300;
  static const double _surfaceRadius = 34;
  static const Color _titleColor = Color(0xFF000000);
  static const Color _titleColorDark = Color(0xFFFFFFFF);
  static const TextStyle _titleStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    height: 22 / 17,
    letterSpacing: -0.43,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle _descriptionStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    height: 22 / 17,
    letterSpacing: -0.43,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    assert(actions.isNotEmpty, 'LiqAlert requires at least one action.');
    assert(
      layout != LiqAlertActionLayout.sideBySide || actions.length == 2,
      'sideBySide layout requires exactly two actions.',
    );
    final isDark = context.liqIsDark;
    final titleColor = isDark ? _titleColorDark : _titleColor;
    return SizedBox(
      width: _surfaceWidth,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(_surfaceRadius)),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ColoredBox(color: isDark ? _innerScrimDark : _innerScrim),
            ),
            Positioned.fill(
              child: ColoredBox(
                color: isDark ? _surfaceFillDark : _surfaceFill,
              ),
            ),
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
                          style: _titleStyle.copyWith(color: titleColor),
                          textDirection: TextDirection.ltr,
                        ),
                        if (description != null) ...<Widget>[
                          const SizedBox(height: 10),
                          Text(
                            description!,
                            textAlign: TextAlign.center,
                            style: _descriptionStyle.copyWith(
                              color: titleColor,
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                        if (content != null) ...<Widget>[
                          const SizedBox(height: 16),
                          content!,
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
  static const Color _bgDark = Color(0x33767680);
  static const Color _filledBg = Color(0xFF0088FF);
  static const Color _filledFg = Color(0xFFFFFFFF);
  static const Color _destructiveFg = Color(0xFFFF383C);
  static const Color _regularFg = Color(0xFF000000);
  static const Color _regularFgDark = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final isFilled = action.style == LiqAlertActionStyle.filled;
    final isDestructive = action.style == LiqAlertActionStyle.destructive;
    final disabled = action.onPressed == null;
    final fg =
        isFilled
            ? _filledFg
            : (isDestructive
                ? _destructiveFg
                : (context.liqIsDark ? _regularFgDark : _regularFg));
    final bg = isFilled ? _filledBg : (context.liqIsDark ? _bgDark : _bg);
    return Semantics(
      button: true,
      enabled: !disabled,
      label: action.label,
      child: LiqPointerCursor(
        enabled: !disabled,
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
      ),
    );
  }
}

/// Modal route for [LiqAlert.show].
class _LiqAlertRoute<T> extends ModalRoute<T> {
  _LiqAlertRoute({
    required this.title,
    required this.actions,
    required this.layout,
    this.description,
    this.content,
    bool barrierDismissible = true,
  }) : _barrierDismissible = barrierDismissible;

  final String title;
  final String? description;
  final Widget? content;
  final List<LiqAlertAction> actions;
  final LiqAlertActionLayout layout;
  final bool _barrierDismissible;

  @override
  Color? get barrierColor => const Color(0x80000000);
  @override
  bool get barrierDismissible => _barrierDismissible;
  @override
  String? get barrierLabel => 'alert';
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
        scale: Tween<double>(begin: 0.92, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        ),
        child: Center(
          child: LiqAlert(
            title: title,
            description: description,
            content: content,
            actions: actions,
            layout: layout,
          ),
        ),
      ),
    );
  }
}
