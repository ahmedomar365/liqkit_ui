import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/foundation/liq_motion.dart';

/// One node in a [LiqTreeView].
///
/// A node with a non-empty [children] list is rendered as a "folder" —
/// its row gets a leading chevron that toggles expansion. A node with
/// no children is a leaf and fires [LiqTreeView.onSelected] when
/// tapped.
final class LiqTreeNode<T> with Diagnosticable {
  /// Creates a tree node.
  const LiqTreeNode({
    required this.id,
    required this.label,
    this.icon,
    this.children = const <LiqTreeNode<Never>>[],
    this.value,
  });

  /// Stable identifier used for selection + expansion tracking.
  final String id;

  /// Visible row label.
  final String label;

  /// Optional 16x16 leading icon rendered before the label.
  final IconData? icon;

  /// Child nodes — non-empty makes this a folder.
  final List<LiqTreeNode<dynamic>> children;

  /// Optional payload for leaf nodes — exposed back via
  /// [LiqTreeView.onSelected].
  final T? value;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('id', id))
      ..add(StringProperty('label', label))
      ..add(IntProperty('childrenCount', children.length))
      ..add(DiagnosticsProperty<IconData?>('icon', icon, defaultValue: null));
  }
}

/// iOS 26 hierarchical list with collapsible folders — file-explorer
/// / outline view style.
///
/// Distinct from `LiqAccordion` (flat top-level expand/collapse panels):
/// `LiqTreeView` supports arbitrarily nested children. The tree owns
/// its own expansion state; selection state is owned by the consumer
/// via [selectedId] + [onSelected].
final class LiqTreeView<T> extends StatefulWidget {
  /// Creates a tree view.
  const LiqTreeView({
    required this.nodes,
    this.selectedId,
    this.onSelected,
    this.initialExpanded = const <String>{},
    this.indent = 16,
    super.key,
  });

  /// Top-level nodes rendered top-to-bottom.
  final List<LiqTreeNode<T>> nodes;

  /// Id of the currently selected node, or null.
  final String? selectedId;

  /// Receives the leaf node's id and value when the consumer taps a
  /// leaf row. Folder rows toggle expansion and do **not** fire this.
  final void Function(String id, T? value)? onSelected;

  /// Set of node ids that should be expanded on first paint.
  final Set<String> initialExpanded;

  /// Per-level horizontal indent in points.
  final double indent;

  /// Minimum row height.
  static const double rowMinHeight = 36;

  /// Vertical padding inside each row.
  static const double rowVerticalPadding = 8;

  /// Base left padding added on top of `indent * depth`.
  static const double rowBaseLeftPadding = 12;

  /// Right padding inside each row.
  static const double rowRightPadding = 12;

  /// Selected-row background.
  static const Color selectedBackground = Color(0xFFE5E5EA);

  /// Row label color.
  static const Color labelColor = Color(0xFF1C1C1E);

  /// Leading icon + chevron color.
  static const Color glyphColor = Color(0xFF8E8E93);

  /// Leading-icon size.
  static const double iconSize = 16;

  /// Chevron-glyph size.
  static const double chevronSize = 12;

  /// Gap between leading icon and the label.
  static const double iconLabelGap = 8;

  /// Gap between chevron and the leading icon (or label when no icon).
  static const double chevronGap = 6;

  /// Chevron rotation animation duration.
  static const Duration rotateDuration = LiqMotion.fast;

  /// Children expansion animation duration.
  static const Duration expandDuration = LiqMotion.normal;

  /// Animation curve shared by both the rotation and the expansion.
  static const Curve curve = LiqMotion.standard;

  static const String _fontFamily = 'SF Pro Text';
  static const List<String> _fontFamilyFallback = <String>[
    'SF Pro',
    'sans-serif',
  ];

  /// Idle row label style — exposed for tests.
  static const TextStyle labelStyle = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 15,
    height: 1.3,
    color: labelColor,
  );

  /// Selected row label style — semibold variant of [labelStyle].
  static const TextStyle selectedLabelStyle = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 15,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: labelColor,
  );

  @override
  State<LiqTreeView<T>> createState() => _LiqTreeViewState<T>();
}

class _LiqTreeViewState<T> extends State<LiqTreeView<T>> {
  late Set<String> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = <String>{...widget.initialExpanded};
  }

  void _toggle(String id) {
    setState(() {
      if (_expanded.contains(id)) {
        _expanded.remove(id);
      } else {
        _expanded.add(id);
      }
    });
  }

  int _countExpanded(List<LiqTreeNode<dynamic>> nodes) {
    var count = 0;
    for (final node in nodes) {
      if (_expanded.contains(node.id)) {
        count += 1;
        count += _countExpanded(node.children);
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[for (final node in widget.nodes) _buildNode(node, 0)],
    );
  }

  Widget _buildNode(LiqTreeNode<dynamic> node, int depth) {
    final isFolder = node.children.isNotEmpty;
    final isExpanded = _expanded.contains(node.id);
    final isSelected = widget.selectedId == node.id;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _TreeRow(
          node: node,
          depth: depth,
          indent: widget.indent,
          isFolder: isFolder,
          isExpanded: isExpanded,
          isSelected: isSelected,
          onTap: () {
            if (isFolder) {
              _toggle(node.id);
            } else {
              widget.onSelected?.call(node.id, node.value as T?);
            }
          },
        ),
        if (isFolder)
          ClipRect(
            child: AnimatedSize(
              duration: LiqTreeView.expandDuration,
              curve: LiqTreeView.curve,
              alignment: Alignment.topCenter,
              child:
                  isExpanded
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          for (final child in node.children)
                            _buildNode(child, depth + 1),
                        ],
                      )
                      : const SizedBox(width: double.infinity),
            ),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('rootCount', widget.nodes.length))
      ..add(IntProperty('expandedCount', _countExpanded(widget.nodes)))
      ..add(
        StringProperty('selectedId', widget.selectedId, defaultValue: null),
      );
  }
}

class _TreeRow extends StatelessWidget {
  const _TreeRow({
    required this.node,
    required this.depth,
    required this.indent,
    required this.isFolder,
    required this.isExpanded,
    required this.isSelected,
    required this.onTap,
  });

  final LiqTreeNode<dynamic> node;
  final int depth;
  final double indent;
  final bool isFolder;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final left = indent * depth + LiqTreeView.rowBaseLeftPadding;
    final children = <Widget>[
      if (isFolder)
        AnimatedRotation(
          duration: LiqTreeView.rotateDuration,
          curve: LiqTreeView.curve,
          turns: isExpanded ? 0.25 : 0,
          child: const Icon(
            Icons.chevron_right,
            size: LiqTreeView.chevronSize,
            color: LiqTreeView.glyphColor,
          ),
        )
      else
        const SizedBox(width: LiqTreeView.chevronSize),
      const SizedBox(width: LiqTreeView.chevronGap),
      if (node.icon != null) ...<Widget>[
        Icon(
          node.icon,
          size: LiqTreeView.iconSize,
          color: LiqTreeView.glyphColor,
        ),
        const SizedBox(width: LiqTreeView.iconLabelGap),
      ],
      Expanded(
        child: Text(
          node.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.ltr,
          style:
              isSelected
                  ? LiqTreeView.selectedLabelStyle
                  : LiqTreeView.labelStyle,
        ),
      ),
    ];

    return Semantics(
      button: true,
      label: node.label,
      selected: isSelected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: LiqTreeView.rowMinHeight,
          ),
          padding: EdgeInsets.fromLTRB(
            left,
            LiqTreeView.rowVerticalPadding,
            LiqTreeView.rowRightPadding,
            LiqTreeView.rowVerticalPadding,
          ),
          color: isSelected ? LiqTreeView.selectedBackground : null,
          child: Row(children: children),
        ),
      ),
    );
  }
}
