import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

/// iOS 26 page-number selector for paged content (a table of results,
/// a photo album, etc.).
///
/// Renders a previous-page button, a list of page numbers, and a
/// next-page button. Page numbers collapse with an ellipsis ("…")
/// when there are too many pages to show at once
/// (e.g. `1 … 4 5 6 … 12`).
///
/// In [compact] mode the entire control collapses to
/// `[prev] {currentPage} / {totalPages} [next]` — the middle is a
/// non-tappable text label.
///
/// When [onPageChanged] is `null` the entire control is rendered at
/// 40% opacity and taps are no-ops.
final class LiqPagination extends StatelessWidget with Diagnosticable {
  /// Creates a page-number selector.
  const LiqPagination({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.compact = false,
    super.key,
  }) : assert(
         currentPage >= 1 && currentPage <= totalPages,
         'currentPage out of range',
       ),
       assert(totalPages >= 1, 'totalPages must be >= 1');

  /// 1-indexed current page.
  final int currentPage;

  /// Total number of pages. `>= 1`.
  final int totalPages;

  /// Called when the user taps a page number or the prev/next button.
  ///
  /// When `null` the entire control is disabled (40% opacity, no taps).
  final ValueChanged<int>? onPageChanged;

  /// When `true`: only show `[prev] {currentPage} / {totalPages} [next]`.
  final bool compact;

  /// Side length of every interactive square in the control.
  static const double buttonSize = 32;

  /// Squircle corner radius for [buttonSize] buttons.
  static const double buttonRadius = 8;

  /// Horizontal gap between adjacent buttons.
  static const double spacing = 8;

  /// 1pt border around inactive page buttons and chevrons.
  static const Color borderColor = Color(0xFFE5E5EA);

  /// Default (inactive) button background.
  static const Color buttonBackground = Color(0xFFFFFFFF);

  /// Active page background (iOS 26 system blue).
  static const Color activeBackground = Color(0xFF007AFF);

  /// Inactive page-number text color.
  static const Color inactiveTextColor = Color(0xFF1C1C1E);

  /// Active page-number text color.
  static const Color activeTextColor = Color(0xFFFFFFFF);

  /// Ellipsis ("…") text color (iOS 26 tertiary label).
  static const Color ellipsisColor = Color(0xFF8E8E93);

  /// Chevron color when the prev/next button is enabled.
  static const Color chevronColor = Color(0xFF1C1C1E);

  /// Chevron color when the prev/next button is at the boundary
  /// (i.e. visually disabled because there is no previous/next page).
  static const Color chevronDisabledColor = Color(0xFFC7C7CC);

  /// Page-number font size.
  static const double fontSize = 14;

  /// Style for the ellipsis label.
  static const TextStyle ellipsisTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    color: ellipsisColor,
  );

  /// Text style applied to inactive page-number buttons.
  static const TextStyle inactiveTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    color: inactiveTextColor,
  );

  /// Text style applied to the active (current) page button.
  static const TextStyle activeTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    color: activeTextColor,
  );

  /// Text style applied to the `X / Y` middle label in compact mode.
  static const TextStyle compactTextStyle = inactiveTextStyle;

  /// Computes the page numbers (and ellipses) to render given a
  /// [currentPage] and [totalPages].
  ///
  /// Returns a list whose items are either an `int` (a page number) or
  /// the `String` `'…'` (an ellipsis placeholder). The algorithm always
  /// shows the first page, the last page, and a window around
  /// [currentPage]. Near a boundary the window is extended toward the
  /// interior so the rendered control keeps a roughly stable width.
  /// Ellipses are inserted between non-adjacent groups.
  ///
  /// Examples:
  ///
  /// - `totalPages=5,  currentPage=3`  → `[1, 2, 3, 4, 5]`
  /// - `totalPages=12, currentPage=1`  → `[1, 2, 3, '…', 12]`
  /// - `totalPages=12, currentPage=6`  → `[1, '…', 5, 6, 7, '…', 12]`
  /// - `totalPages=12, currentPage=12` → `[1, '…', 10, 11, 12]`
  static List<dynamic> visiblePages(int currentPage, int totalPages) {
    assert(totalPages >= 1, 'totalPages must be >= 1');
    assert(
      currentPage >= 1 && currentPage <= totalPages,
      'currentPage out of range',
    );

    final pages = <int>{1, totalPages};
    var windowStart = currentPage - 1;
    var windowEnd = currentPage + 1;
    if (windowStart < 1) {
      windowEnd += 1 - windowStart;
      windowStart = 1;
    }
    if (windowEnd > totalPages) {
      windowStart -= windowEnd - totalPages;
      windowEnd = totalPages;
    }
    if (windowStart < 1) windowStart = 1;
    for (var i = windowStart; i <= windowEnd; i++) {
      pages.add(i);
    }

    final sorted = pages.toList()..sort();
    final result = <dynamic>[];
    for (var i = 0; i < sorted.length; i++) {
      if (i > 0 && sorted[i] - sorted[i - 1] > 1) {
        result.add('…');
      }
      result.add(sorted[i]);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final enabled = onPageChanged != null;
    final children = <Widget>[];

    final prevEnabled = enabled && currentPage > 1;
    children.add(
      _ChevronButton(
        icon: Icons.chevron_left,
        enabled: enabled,
        atBoundary: currentPage <= 1,
        semanticLabel: 'Previous page',
        onTap: prevEnabled ? () => onPageChanged!(currentPage - 1) : null,
      ),
    );

    if (compact) {
      children
        ..add(const SizedBox(width: spacing))
        ..add(
          Text(
            '$currentPage / $totalPages',
            style: compactTextStyle,
            textDirection: TextDirection.ltr,
          ),
        )
        ..add(const SizedBox(width: spacing));
    } else {
      final entries = visiblePages(currentPage, totalPages);
      for (final entry in entries) {
        children.add(const SizedBox(width: spacing));
        if (entry is int) {
          final isActive = entry == currentPage;
          children.add(
            _PageNumberButton(
              page: entry,
              isActive: isActive,
              enabled: enabled,
              onTap: enabled ? () => onPageChanged!(entry) : null,
            ),
          );
        } else {
          children.add(const _Ellipsis());
        }
      }
      children.add(const SizedBox(width: spacing));
    }

    final nextEnabled = enabled && currentPage < totalPages;
    children.add(
      _ChevronButton(
        icon: Icons.chevron_right,
        enabled: enabled,
        atBoundary: currentPage >= totalPages,
        semanticLabel: 'Next page',
        onTap: nextEnabled ? () => onPageChanged!(currentPage + 1) : null,
      ),
    );

    final row = Row(mainAxisSize: MainAxisSize.min, children: children);

    if (!enabled) {
      return Opacity(opacity: 0.4, child: row);
    }
    return row;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('currentPage', currentPage))
      ..add(IntProperty('totalPages', totalPages))
      ..add(
        FlagProperty(
          'compact',
          value: compact,
          ifTrue: 'compact',
          ifFalse: 'expanded',
        ),
      )
      ..add(
        FlagProperty(
          'enabled',
          value: onPageChanged != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}

class _PageNumberButton extends StatelessWidget {
  const _PageNumberButton({
    required this.page,
    required this.isActive,
    required this.enabled,
    required this.onTap,
  });

  final int page;
  final bool isActive;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: LiqPagination.buttonSize,
      height: LiqPagination.buttonSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            isActive
                ? LiqPagination.activeBackground
                : LiqPagination.buttonBackground,
        borderRadius: BorderRadius.circular(LiqPagination.buttonRadius),
        border: isActive ? null : Border.all(color: LiqPagination.borderColor),
      ),
      child: Text(
        '$page',
        style:
            isActive
                ? LiqPagination.activeTextStyle
                : LiqPagination.inactiveTextStyle,
        textDirection: TextDirection.ltr,
      ),
    );

    return Semantics(
      button: true,
      enabled: enabled,
      selected: isActive,
      label: 'Page $page',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: box,
      ),
    );
  }
}

class _ChevronButton extends StatelessWidget {
  const _ChevronButton({
    required this.icon,
    required this.enabled,
    required this.atBoundary,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final bool atBoundary;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        atBoundary
            ? LiqPagination.chevronDisabledColor
            : LiqPagination.chevronColor;

    final box = Container(
      width: LiqPagination.buttonSize,
      height: LiqPagination.buttonSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: LiqPagination.buttonBackground,
        borderRadius: BorderRadius.circular(LiqPagination.buttonRadius),
        border: Border.all(color: LiqPagination.borderColor),
      ),
      child: Icon(icon, size: 18, color: color),
    );

    return Semantics(
      button: true,
      enabled: enabled && !atBoundary,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: box,
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: LiqPagination.buttonSize,
      height: LiqPagination.buttonSize,
      child: Center(
        child: Text(
          '…',
          style: LiqPagination.ellipsisTextStyle,
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
