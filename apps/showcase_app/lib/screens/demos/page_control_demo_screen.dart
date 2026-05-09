import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class PageControlDemoScreen extends ConsumerStatefulWidget {
  const PageControlDemoScreen({super.key});

  @override
  ConsumerState<PageControlDemoScreen> createState() =>
      _PageControlDemoScreenState();
}

class _PageControlDemoScreenState
    extends ConsumerState<PageControlDemoScreen> {
  static const int _pageCount = 5;
  int _currentPage = 0;
  int _scrollingPage = 3;
  final PageController _pageController = PageController();

  static const List<Color> _pageColors = <Color>[
    Color(0xFFBBDEFB),
    Color(0xFFC8E6C9),
    Color(0xFFFFE0B2),
    Color(0xFFE1BEE7),
    Color(0xFFFFCDD2),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Page Controls')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'PageView with Dots',
              description:
                  'Swipe or tap dots to change page. Standard iOS-style dots indicator.',
              child: SizedBox(
                height: 380,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: <Widget>[
                      PageView(
                        controller: _pageController,
                        onPageChanged: (page) =>
                            setState(() => _currentPage = page),
                        children: <Widget>[
                          for (var i = 0; i < _pageCount; i++)
                            ColoredBox(
                              color: _pageColors[i % _pageColors.length],
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
                                      style: context.textStyles.largeTitle
                                          .copyWith(
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
                            count: _pageCount,
                            activeIndex: _currentPage,
                            onPageChanged: (page) {
                              setState(() => _currentPage = page);
                              _pageController.animateToPage(
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
              ),
            ),
            _Section(
              title: 'Progress Indicator',
              description:
                  'Linear progress bar driven by current page (page ${_currentPage + 1} of $_pageCount).',
              child: SizedBox(
                width: 280,
                child: LiqProgressBar(
                  value: (_currentPage + 1) / _pageCount,
                  height: 6,
                ),
              ),
            ),
            _Section(
              title: 'Numbered Indicator',
              description: 'Each page is shown as a numbered chip.',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (var i = 0; i < _pageCount; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? context.appleColors.blue
                              : context.appleColors.blue
                                  .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${i + 1}',
                          style: context.textStyles.footnote.copyWith(
                            color: i == _currentPage
                                ? const Color(0xFFFFFFFF)
                                : context.appleColors.blue,
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Custom Sized & Outlined',
              description: 'Animated indicator that grows for the active page.',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (var i = 0; i < _pageCount; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: i == _currentPage ? 24 : 16,
                        height: i == _currentPage ? 24 : 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _currentPage
                              ? context.appleColors.blue
                              : const Color(0x00000000),
                          border:
                              Border.all(color: context.appleColors.blue, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Scrolling (Compact for Many Pages)',
              description:
                  'Use maxVisible to keep the indicator compact when there are many pages.',
              child: Container(
                decoration: BoxDecoration(
                  color: context.appleColors.secondarySystemBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: LiqPageControl(
                  count: 20,
                  activeIndex: _scrollingPage,
                  maxVisible: 7,
                  onPageChanged: (page) =>
                      setState(() => _scrollingPage = page),
                ),
              ),
            ),
            _Section(
              title: 'Custom Colors',
              description: 'Pick custom active/inactive dot colors.',
              child: LiqPageControl(
                count: _pageCount,
                activeIndex: _currentPage,
                activeColor: context.appleColors.purple,
                inactiveColor:
                    context.appleColors.purple.withValues(alpha: 0.3),
                onPageChanged: (page) => setState(() => _currentPage = page),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(description!, style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
