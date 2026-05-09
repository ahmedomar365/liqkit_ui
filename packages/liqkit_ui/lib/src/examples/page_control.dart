/// Canonical page-control variants — single source of truth for the
/// showcase app and the liqkit.com previews.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/page_controls/liq_page_control.dart';
import 'package:liqkit_ui/src/components/progress/liq_progress_indicator.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/foundation/liq_colors.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

const int _kPageCount = 5;
const List<Color> _kPageColors = <Color>[
  Color(0xFFBBDEFB),
  Color(0xFFC8E6C9),
  Color(0xFFFFE0B2),
  Color(0xFFE1BEE7),
  Color(0xFFFFCDD2),
];

/// Swipe or tap dots to change page. Standard iOS-style dots indicator.
final class PageControlDotsExample extends StatefulWidget {
  const PageControlDotsExample({super.key});

  @override
  State<PageControlDotsExample> createState() => _PageControlDotsExampleState();
}

class _PageControlDotsExampleState extends State<PageControlDotsExample> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _controller,
              onPageChanged: (page) => setState(() => _current = page),
              children: <Widget>[
                for (var i = 0; i < _kPageCount; i++)
                  ColoredBox(
                    color: _kPageColors[i % _kPageColors.length],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            LiqMaterialIcons.landscape,
                            size: 80,
                            color: LiqColors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Page ${i + 1}',
                            style: context.textStyles.largeTitle.copyWith(
                              color: LiqColors.white,
                              fontWeight: LiqAppleTypography.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: LiqPageControl(
                  count: _kPageCount,
                  activeIndex: _current,
                  onPageChanged: (page) {
                    setState(() => _current = page);
                    _controller.animateToPage(
                      page,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Linear progress bar showing pagination progress.
final class PageControlProgressExample extends StatefulWidget {
  const PageControlProgressExample({super.key});

  @override
  State<PageControlProgressExample> createState() =>
      _PageControlProgressExampleState();
}

class _PageControlProgressExampleState
    extends State<PageControlProgressExample> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 280,
          child: LiqProgressBar(
            value: (_current + 1) / _kPageCount,
            height: 6,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Page ${_current + 1} of $_kPageCount',
          style: context.textStyles.body.secondary,
        ),
        const SizedBox(height: 12),
        LiqPageControl(
          count: _kPageCount,
          activeIndex: _current,
          onPageChanged: (i) => setState(() => _current = i),
        ),
      ],
    );
  }
}

/// Each page is shown as a numbered chip.
final class PageControlNumberedExample extends StatefulWidget {
  const PageControlNumberedExample({super.key});

  @override
  State<PageControlNumberedExample> createState() =>
      _PageControlNumberedExampleState();
}

class _PageControlNumberedExampleState
    extends State<PageControlNumberedExample> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          setState(() => _current = (_current + 1) % _kPageCount),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < _kPageCount; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == _current
                      ? context.appleColors.blue
                      : context.appleColors.blue.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${i + 1}',
                  style: context.textStyles.footnote.copyWith(
                    color: i == _current
                        ? const Color(0xFFFFFFFF)
                        : context.appleColors.blue,
                    fontWeight: LiqAppleTypography.semibold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Animated indicator that grows for the active page.
final class PageControlSizedOutlinedExample extends StatefulWidget {
  const PageControlSizedOutlinedExample({super.key});

  @override
  State<PageControlSizedOutlinedExample> createState() =>
      _PageControlSizedOutlinedExampleState();
}

class _PageControlSizedOutlinedExampleState
    extends State<PageControlSizedOutlinedExample> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          setState(() => _current = (_current + 1) % _kPageCount),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < _kPageCount; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: i == _current ? 24 : 16,
                height: i == _current ? 24 : 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _current
                      ? context.appleColors.blue
                      : const Color(0x00000000),
                  border:
                      Border.all(color: context.appleColors.blue, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Use maxVisible to keep the indicator compact when there are many pages.
final class PageControlScrollingExample extends StatefulWidget {
  const PageControlScrollingExample({super.key});

  @override
  State<PageControlScrollingExample> createState() =>
      _PageControlScrollingExampleState();
}

class _PageControlScrollingExampleState
    extends State<PageControlScrollingExample> {
  int _current = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appleColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: LiqPageControl(
        count: 20,
        activeIndex: _current,
        maxVisible: 7,
        onPageChanged: (page) => setState(() => _current = page),
      ),
    );
  }
}

/// Pick custom active/inactive dot colors.
final class PageControlCustomColorsExample extends StatefulWidget {
  const PageControlCustomColorsExample({super.key});

  @override
  State<PageControlCustomColorsExample> createState() =>
      _PageControlCustomColorsExampleState();
}

class _PageControlCustomColorsExampleState
    extends State<PageControlCustomColorsExample> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return LiqPageControl(
      count: _kPageCount,
      activeIndex: _current,
      activeColor: context.appleColors.purple,
      inactiveColor:
          context.appleColors.purple.withValues(alpha: 0.3),
      onPageChanged: (page) => setState(() => _current = page),
    );
  }
}
