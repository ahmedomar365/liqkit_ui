import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class TopBarDemoScreen extends ConsumerStatefulWidget {
  const TopBarDemoScreen({super.key});

  @override
  ConsumerState<TopBarDemoScreen> createState() => _TopBarDemoScreenState();
}

class _TopBarDemoScreenState extends ConsumerState<TopBarDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Top Bars')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Standard',
              description:
                  'Top bar with title, leading back button, and trailing icon actions.',
              child: _DemoFrame(
                appBar: LiqAppBar(
                  title: const Text('Page Title'),
                  centerTitle: true,
                  leading: LiqIconButton(
                    icon: LiqMaterialIcons.arrowBackIos,
                    style: LiqIconButtonStyle.borderless,
                    size: 36,
                    onPressed: () {},
                  ),
                  actions: <Widget>[
                    LiqIconButton(
                      icon: LiqIcons.share,
                      style: LiqIconButtonStyle.borderless,
                      size: 36,
                      onPressed: () {},
                    ),
                    LiqIconButton(
                      icon: LiqMaterialIcons.moreVert,
                      style: LiqIconButtonStyle.borderless,
                      size: 36,
                      onPressed: () {},
                    ),
                  ],
                ),
                body: _demoBody(context, 'Standard top bar content'),
              ),
            ),
            _Section(
              title: 'Modal',
              description:
                  'Top bar for modal screens with text Cancel / Done actions.',
              child: _DemoFrame(
                appBar: LiqAppBar(
                  title: const Text('New Item'),
                  leading: GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: context.appleColors.blue),
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: context.appleColors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                body: _demoBody(context, 'Modal content'),
              ),
            ),
            _Section(
              title: 'Large Title',
              description: 'iOS-style large title above scrolling content.',
              child: _DemoFrame(
                appBar: LiqAppBar(
                  title: const Text('Large Title'),
                  actions: <Widget>[
                    LiqIconButton(
                      icon: LiqMaterialIcons.add,
                      style: LiqIconButtonStyle.borderless,
                      size: 36,
                      onPressed: () {},
                    ),
                    LiqIconButton(
                      icon: LiqIcons.search,
                      style: LiqIconButtonStyle.borderless,
                      size: 36,
                      onPressed: () {},
                    ),
                  ],
                ),
                body: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'Large Title',
                        style: context.textStyles.largeTitle.copyWith(
                          fontWeight: LiqAppleTypography.bold,
                        ),
                      ),
                    ),
                    for (var i = 0; i < 20; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Text('Item $i', style: context.textStyles.body),
                      ),
                  ],
                ),
              ),
            ),
            _Section(
              title: 'Search Bar',
              description: 'Top bar with an integrated search field.',
              child: _DemoFrame(
                appBar: LiqAppBar(
                  toolbarHeight: 80,
                  title: SizedBox(
                    height: 40,
                    child: LiqSearchField(
                      controller: TextEditingController(),
                      placeholder: 'Search',
                    ),
                  ),
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: context.appleColors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                body: _demoBody(context, 'Search results'),
              ),
            ),
            _Section(
              title: 'Custom Actions',
              description: 'Notification action with badge dot, plus a more-options menu.',
              child: _DemoFrame(
                appBar: LiqAppBar(
                  title: const Text('Messages'),
                  actions: <Widget>[
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        LiqIconButton(
                          icon: LiqMaterialIcons.notificationsOutlined,
                          style: LiqIconButtonStyle.borderless,
                          size: 36,
                          onPressed: () {},
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: context.appleColors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    LiqIconButton(
                      icon: LiqMaterialIcons.moreVert,
                      style: LiqIconButtonStyle.borderless,
                      size: 36,
                      onPressed: () => LiqMenu.showPopup<void>(
                        context: context,
                        children: <Widget>[
                          LiqMenuItem(label: 'Edit', onPressed: () {}),
                          LiqMenuItem(
                              label: 'Select Messages', onPressed: () {}),
                          LiqMenuItem(
                              label: 'Mark All as Read', onPressed: () {}),
                        ],
                        position: const Offset(0, 0),
                        width: 240,
                      ),
                    ),
                  ],
                ),
                body: _demoBody(context, 'Messages list'),
              ),
            ),
            _Section(
              title: 'Transparent',
              description: 'Top bar with a transparent background over a gradient.',
              child: SizedBox(
                height: 400,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              context.appleColors.blue,
                              context.appleColors.purple,
                            ],
                          ),
                        ),
                      ),
                      _DemoFrame(
                        appBar: LiqAppBar(
                          backgroundColor: const Color(0x00000000),
                          title: const Text(
                            'Transparent Bar',
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                          leading: LiqIconButton(
                            icon: LiqMaterialIcons.arrowBackIos,
                            color: const Color(0xFFFFFFFF),
                            style: LiqIconButtonStyle.borderless,
                            size: 36,
                            onPressed: () {},
                          ),
                          actions: <Widget>[
                            LiqIconButton(
                              icon: LiqMaterialIcons.favoriteBorder,
                              color: const Color(0xFFFFFFFF),
                              style: LiqIconButtonStyle.borderless,
                              size: 36,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        body: const SizedBox.expand(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _Section(
              title: 'With Bottom (Segmented)',
              description: 'Top bar with a segmented control attached underneath.',
              child: const _WithBottomFrame(),
            ),
            _Section(
              title: 'Scrolling Content',
              description: 'Long list under the top bar — content scrolls beneath.',
              child: _DemoFrame(
                appBar: const LiqAppBar(title: Text('Scroll Away')),
                body: ListView.builder(
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Scroll item $index',
                              style: context.textStyles.body),
                          Text(
                            'Scroll the list to see content move beneath the bar',
                            style: context.textStyles.caption1.secondary,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            _Section(
              title: 'Dynamic Island Integration',
              description:
                  'Top bar designed to coexist with a Dynamic Island pill.',
              child: SizedBox(
                height: 320,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: context.appleColors.systemGroupedBackground,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 44,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF000000),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4),
                                decoration: BoxDecoration(
                                  color: context.appleColors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                'Phone Call',
                                style: context.textStyles.caption1.copyWith(
                                  color: const Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '3:42',
                                style: context.textStyles.caption1.copyWith(
                                  color: context.appleColors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _DemoFrame(
                            appBar: const LiqAppBar(
                              toolbarHeight: 44,
                              title: Text('Messages'),
                              backgroundColor: Color(0x00000000),
                            ),
                            body: _demoBody(
                                context, 'Content below Dynamic Island'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _demoBody(BuildContext context, String content) {
    return ColoredBox(
      color: context.appleColors.systemGroupedBackground,
      child: Center(
        child: Text(content, style: context.textStyles.body.secondary),
      ),
    );
  }
}

class _DemoFrame extends StatelessWidget {
  const _DemoFrame({this.appBar, required this.body});

  final PreferredSizeWidget? appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        border: Border.all(color: context.appleColors.separator),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          if (appBar != null) appBar!,
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _WithBottomFrame extends StatefulWidget {
  const _WithBottomFrame();

  @override
  State<_WithBottomFrame> createState() => _WithBottomFrameState();
}

class _WithBottomFrameState extends State<_WithBottomFrame> {
  String _tab = 'all';

  @override
  Widget build(BuildContext context) {
    return _DemoFrame(
      appBar: LiqAppBar(
        title: const Text('Categories'),
        centerTitle: true,
        bottomHeight: 48,
        bottom: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: LiqSegmentedControl<String>(
            value: _tab,
            segments: const <({String value, String label})>[
              (value: 'all', label: 'All'),
              (value: 'recent', label: 'Recent'),
              (value: 'favorites', label: 'Favorites'),
            ],
            onChanged: (v) => setState(() => _tab = v),
          ),
        ),
      ),
      body: Center(
        child: Text(
          switch (_tab) {
            'recent' => 'Recent Items',
            'favorites' => 'Favorite Items',
            _ => 'All Items',
          },
          style: context.textStyles.body,
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
