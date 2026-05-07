import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/menu/liq_menu.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Single top-level entry in a [LiqMenuBar]. Tapping the title opens
/// a dropdown popup containing [items].
@immutable
class LiqMenuBarItem {
  /// Creates a menu bar item.
  const LiqMenuBarItem({
    required this.title,
    required this.items,
  });

  /// Top-bar text.
  final String title;

  /// Menu rows shown in the dropdown popup. Pass [LiqMenuItem]s and/or
  /// `LiqMenuSeparator`s.
  final List<Widget> items;
}

/// macOS-style menu bar — horizontal strip of titles, each opening a
/// dropdown menu on tap. Useful at the top of windowed-style content
/// (e.g. in-app document editors).
final class LiqMenuBar extends StatefulWidget with Diagnosticable {
  /// Creates a menu bar.
  const LiqMenuBar({
    required this.items,
    this.enableHaptics = false,
    this.menuWidth = 240,
    super.key,
  });

  final List<LiqMenuBarItem> items;
  final bool enableHaptics;
  final double menuWidth;

  @override
  State<LiqMenuBar> createState() => _LiqMenuBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('itemCount', items.length));
  }
}

class _LiqMenuBarState extends State<LiqMenuBar> {
  final List<GlobalKey> _keys = <GlobalKey>[];

  @override
  void initState() {
    super.initState();
    _keys
      ..clear()
      ..addAll(List<GlobalKey>.generate(widget.items.length, (_) => GlobalKey()));
  }

  @override
  void didUpdateWidget(LiqMenuBar old) {
    super.didUpdateWidget(old);
    if (widget.items.length != old.items.length) {
      _keys
        ..clear()
        ..addAll(List<GlobalKey>.generate(
            widget.items.length, (_) => GlobalKey()));
    }
  }

  Future<void> _open(int index) async {
    final ctx = _keys[index].currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) return;
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final origin = box.localToGlobal(Offset.zero, ancestor: overlayBox);
    final position = origin + Offset(0, box.size.height);
    if (widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
    await LiqMenu.showPopup<void>(
      context: ctx,
      children: widget.items[index].items,
      position: position,
      width: widget.menuWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final textStyle = LiqAppleTypography.subheadline(brightness).copyWith(
      color: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
    );
    final bg = isDark
        ? const Color(0xCC1C1C1E)
        : const Color(0xCCF5F5F7);
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0x1AEBEBF5)
                : const Color(0x1A3C3C43),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          for (var i = 0; i < widget.items.length; i++)
            _MenuBarTitle(
              key: _keys[i],
              title: widget.items[i].title,
              style: textStyle,
              onTap: () => _open(i),
            ),
        ],
      ),
    );
  }
}

class _MenuBarTitle extends StatefulWidget {
  const _MenuBarTitle({
    super.key,
    required this.title,
    required this.style,
    required this.onTap,
  });

  final String title;
  final TextStyle style;
  final VoidCallback onTap;

  @override
  State<_MenuBarTitle> createState() => _MenuBarTitleState();
}

class _MenuBarTitleState extends State<_MenuBarTitle> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          color: _hover
              ? widget.style.color?.withValues(alpha: 0.08)
              : null,
          child: Text(widget.title, style: widget.style),
        ),
      ),
    );
  }
}
