import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Arrangement for [LiqContextMenu]: which side the menu sits on relative
/// to the preview tile.
enum LiqContextMenuArrangement {
  /// Menu below the preview, aligned to the leading edge.
  belowLeading,

  /// Menu below the preview, aligned to the trailing edge.
  belowTrailing,

  /// Menu beside the preview on the leading side.
  besideLeading,

  /// Menu beside the preview on the trailing side.
  besideTrailing,
}

/// 351×351 preview tile rendered above a [LiqContextMenu] menu.
///
/// Sourced from `native/components/context-menu.css`
/// (`.ios26-context-menu-content-area`).
final class LiqContextMenuPreview extends StatelessWidget {
  /// Creates a preview tile.
  const LiqContextMenuPreview({
    this.size = const Size(351, 351),
    this.child,
    super.key,
  });

  /// Tile size. Defaults to 351×351.
  final Size size;

  /// Optional content rendered centered inside the tile.
  final Widget? child;

  static const Color _bg = Color(0xFFFFFFFF);
  static const Color _border = Color(0xFFE8EBEF);
  static const Color _shadow = Color(0x14000000);
  static const Color _placeholder = Color(0x99000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.fromBorderSide(BorderSide(color: _border)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: _shadow, offset: Offset(0, 16), blurRadius: 28),
        ],
      ),
      alignment: Alignment.center,
      child:
          child ??
          const Text(
            'Content area',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 17,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: _placeholder,
            ),
          ),
    );
  }
}

/// iOS 26 context menu — preview tile + menu panel.
final class LiqContextMenu extends StatelessWidget {
  /// Creates a context menu.
  const LiqContextMenu({
    required this.preview,
    required this.menu,
    this.arrangement = LiqContextMenuArrangement.belowLeading,
    this.gap = 17,
    super.key,
  });

  /// Preview tile (typically a [LiqContextMenuPreview]).
  final Widget preview;

  /// Menu panel (typically a `LiqMenu`).
  final Widget menu;

  /// Arrangement of preview vs menu.
  final LiqContextMenuArrangement arrangement;

  /// Pixels of space between preview and menu.
  final double gap;

  @override
  Widget build(BuildContext context) {
    switch (arrangement) {
      case LiqContextMenuArrangement.belowLeading:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[preview, SizedBox(height: gap), menu],
        );
      case LiqContextMenuArrangement.belowTrailing:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[preview, SizedBox(height: gap), menu],
        );
      case LiqContextMenuArrangement.besideLeading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[menu, SizedBox(width: gap), preview],
        );
      case LiqContextMenuArrangement.besideTrailing:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[preview, SizedBox(width: gap), menu],
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqContextMenuArrangement>('arrangement', arrangement))
      ..add(DoubleProperty('gap', gap));
  }
}
