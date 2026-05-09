import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

class WidgetDemoScreen extends ConsumerStatefulWidget {
  const WidgetDemoScreen({super.key});

  @override
  ConsumerState<WidgetDemoScreen> createState() => _WidgetDemoScreenState();
}

class _WidgetDemoScreenState extends ConsumerState<WidgetDemoScreen> {
  int _currentCarouselPage = 0;
  final Map<String, bool> _miniWidgetStates = <String, bool>{
    'wifi': true,
    'bluetooth': false,
    'location': true,
    'battery': false,
  };

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Widgets')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Small Widgets (164x164)',
              description: 'Quick-glance widgets — weather, battery, music, screen time.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  LiqHomeWidget(
                    size: LiqHomeWidgetSize.small,
                    title: 'Weather',
                    icon: LiqMaterialIcons.wbSunny,
                    backgroundColor:
                        context.appleColors.systemGroupedBackground,
                    content: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            LiqMaterialIcons.wbSunny,
                            size: 48,
                            color: context.appleColors.yellow,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '72°',
                            style: context.textStyles.largeTitle.copyWith(
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  LiqHomeWidget(
                    size: LiqHomeWidgetSize.small,
                    title: 'Battery',
                    icon: LiqMaterialIcons.batteryFull,
                    showBadge: true,
                    badgeText: '85%',
                    badgeColor: context.appleColors.green,
                    content: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Icon(
                            LiqMaterialIcons.batteryFull,
                            size: 64,
                            color: context.appleColors.green,
                          ),
                          Text(
                            '85%',
                            style: context.textStyles.subheadline.copyWith(
                              fontWeight: FontWeight.bold,
                              color: LiqColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  LiqHomeWidget(
                    size: LiqHomeWidgetSize.small,
                    title: 'Screen Time',
                    icon: LiqMaterialIcons.phoneIphone,
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '2h 34m',
                          style: context.textStyles.title2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.appleColors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Today',
                          style: context.textStyles.caption1.secondary,
                        ),
                        const Spacer(),
                        LiqProgressBar(
                          value: 0.7,
                          backgroundColor:
                              context.appleColors.gray.withValues(alpha: 0.2),
                          progressColor: context.appleColors.blue,
                        ),
                      ],
                    ),
                  ),
                  LiqHomeWidget(
                    size: LiqHomeWidgetSize.small,
                    title: 'Music',
                    icon: LiqMaterialIcons.musicNote,
                    backgroundColor:
                        context.appleColors.pink.withValues(alpha: 0.1),
                    content: Center(
                      child: Icon(
                        LiqMaterialIcons.playCircleFilled,
                        size: 64,
                        color: context.appleColors.pink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Medium Widgets (349x164)',
              description:
                  'Wider widgets that fit more detail — calendar overview, fitness rings.',
              child: Column(
                children: <Widget>[
                  LiqHomeWidget(
                    size: LiqHomeWidgetSize.medium,
                    title: 'Calendar',
                    icon: LiqMaterialIcons.calendarToday,
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Today',
                                style: context.textStyles.caption1.secondary,
                              ),
                              Text(
                                'November 25',
                                style: context.textStyles.title2.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '3 Events',
                                style: context.textStyles.subheadline.copyWith(
                                  color: context.appleColors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 120,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                context.appleColors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '25',
                                style: context.textStyles.largeTitle.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: context.appleColors.blue,
                                ),
                              ),
                              Text(
                                'MON',
                                style: context.textStyles.caption1.copyWith(
                                  color: context.appleColors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  LiqHomeWidget(
                    size: LiqHomeWidgetSize.medium,
                    title: 'Fitness',
                    icon: LiqMaterialIcons.fitnessCenter,
                    backgroundColor:
                        context.appleColors.green.withValues(alpha: 0.1),
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    LiqMaterialIcons.localFireDepartment,
                                    color: context.appleColors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '450 cal',
                                    style: context.textStyles.subheadline
                                        .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    LiqMaterialIcons.directionsWalk,
                                    color: context.appleColors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '8,234 steps',
                                    style: context.textStyles.subheadline
                                        .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        LiqCircularProgress(
                          value: 0.75,
                          backgroundColor:
                              context.appleColors.gray.withValues(alpha: 0.2),
                          progressColor: context.appleColors.green,
                          strokeWidth: 8,
                          showPercentage: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Large Widget (349x365)',
              description:
                  'Rich content widget with chart and stat row.',
              child: LiqHomeWidget(
                size: LiqHomeWidgetSize.large,
                title: 'Activity',
                icon: LiqMaterialIcons.showChart,
                content: Column(
                  children: <Widget>[
                    Expanded(
                      child: LiqChartHomeWidget(
                        data: const <double>[20, 45, 30, 80, 65, 90, 45, 70, 85, 60],
                        color: context.appleColors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _statItem(context, 'Steps', '8,234',
                            context.appleColors.green),
                        _statItem(context, 'Calories', '450',
                            context.appleColors.orange),
                        _statItem(context, 'Distance', '5.2km',
                            context.appleColors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _Section(
              title: 'Apple-Style Widgets',
              description:
                  'Branded widgets with app name, icon, accent color, and last-updated stamp.',
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: LiqAppleHomeWidget(
                          size: LiqHomeWidgetSize.small,
                          appName: 'Weather',
                          appIcon: LiqMaterialIcons.wbSunny,
                          accentColor: context.appleColors.yellow,
                          showLastUpdated: true,
                          lastUpdated:
                              DateTime.now().subtract(const Duration(minutes: 5)),
                          content: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '72°',
                                  style:
                                      context.textStyles.largeTitle.copyWith(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                Text(
                                  'Sunny',
                                  style: context.textStyles.body.secondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: LiqAppleHomeWidget(
                          size: LiqHomeWidgetSize.small,
                          appName: 'Stocks',
                          appIcon: LiqMaterialIcons.trendingUp,
                          accentColor: context.appleColors.green,
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    LiqMaterialIcons.trendingUp,
                                    color: context.appleColors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+2.4%',
                                    style: context.textStyles.headline.copyWith(
                                      color: context.appleColors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'S&P 500',
                                style: context.textStyles.caption1.secondary,
                              ),
                              Text(
                                '4,567.80',
                                style: context.textStyles.subheadline.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Chart Widget',
              description: 'Medium-sized widget with stock chart.',
              child: LiqHomeWidget(
                size: LiqHomeWidgetSize.medium,
                title: 'Stock Price',
                icon: LiqMaterialIcons.showChart,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'AAPL',
                              style: context.textStyles.headline.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              r'$184.92',
                              style: context.textStyles.subheadline,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.appleColors.green
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+2.4%',
                            style: context.textStyles.caption1.copyWith(
                              color: context.appleColors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: LiqChartHomeWidget(
                        data: const <double>[180, 182, 179, 183, 185, 184, 186, 185, 187, 185],
                        color: context.appleColors.green,
                        showGrid: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _Section(
              title: 'Live Activity',
              description: 'Real-time activity card (e.g. food delivery).',
              child: LiqLiveActivity(
                title: 'Food Delivery',
                accentColor: context.appleColors.orange,
                onTap: () {},
                content: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          LiqMaterialIcons.deliveryDining,
                          size: 32,
                          color: context.appleColors.orange,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Your order is on the way',
                                style: context.textStyles.body,
                              ),
                              Text(
                                'Arriving in 15 minutes',
                                style: context.textStyles.caption1.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LiqProgressBar(
                      value: 0.7,
                      backgroundColor:
                          context.appleColors.gray.withValues(alpha: 0.2),
                      progressColor: context.appleColors.orange,
                    ),
                  ],
                ),
              ),
            ),
            _Section(
              title: 'Mini Widget Grid',
              description:
                  'Compact toggle tiles for connectivity / settings shortcuts.',
              child: LiqHomeWidgetGrid(
                widgets: <Widget>[
                  LiqMiniHomeWidget(
                    icon: LiqIcons.wifi,
                    label: 'Wi-Fi',
                    isActive: _miniWidgetStates['wifi']!,
                    onTap: () => setState(() {
                      _miniWidgetStates['wifi'] = !_miniWidgetStates['wifi']!;
                    }),
                  ),
                  LiqMiniHomeWidget(
                    icon: LiqMaterialIcons.bluetooth,
                    label: 'Bluetooth',
                    isActive: _miniWidgetStates['bluetooth']!,
                    color: context.appleColors.blue,
                    onTap: () => setState(() {
                      _miniWidgetStates['bluetooth'] =
                          !_miniWidgetStates['bluetooth']!;
                    }),
                  ),
                  LiqMiniHomeWidget(
                    icon: LiqMaterialIcons.locationOn,
                    label: 'Location',
                    isActive: _miniWidgetStates['location']!,
                    color: context.appleColors.green,
                    onTap: () => setState(() {
                      _miniWidgetStates['location'] =
                          !_miniWidgetStates['location']!;
                    }),
                  ),
                  LiqMiniHomeWidget(
                    icon: LiqMaterialIcons.batteryFull,
                    label: 'Battery',
                    value: '85%',
                    isActive: _miniWidgetStates['battery']!,
                    color: context.appleColors.yellow,
                    onTap: () => setState(() {
                      _miniWidgetStates['battery'] =
                          !_miniWidgetStates['battery']!;
                    }),
                  ),
                ],
                crossAxisCount: 4,
                spacing: 12,
              ),
            ),
            _Section(
              title: 'Interactive Widget',
              description: 'Widget that responds to tap, double-tap, and long-press.',
              child: LiqInteractiveHomeWidget(
                onTap: () => LiqToastOverlay.show(context, 'Widget tapped!'),
                onDoubleTap: () =>
                    LiqToastOverlay.show(context, 'Widget double tapped!'),
                onLongPress: () =>
                    LiqToastOverlay.show(context, 'Widget long pressed!'),
                child: LiqHomeWidget(
                  size: LiqHomeWidgetSize.medium,
                  title: 'Interactive',
                  subtitle: 'Tap, double tap, or long press',
                  icon: LiqMaterialIcons.touchApp,
                  content: Center(
                    child: Icon(
                      LiqMaterialIcons.touchApp,
                      size: 48,
                      color: context.appleColors.blue.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
            _Section(
              title: 'Widget Carousel',
              description: 'Swipeable horizontal carousel of widgets.',
              child: Column(
                children: <Widget>[
                  LiqHomeWidgetCarousel(
                    height: 200,
                    autoPlay: true,
                    onPageChanged: (index) =>
                        setState(() => _currentCarouselPage = index),
                    widgets: <Widget>[
                      _carouselWidget(context, 'Photos', '1,234 Items',
                          LiqMaterialIcons.photoLibrary,
                          context.appleColors.yellow),
                      _carouselWidget(context, 'Music', '456 Songs',
                          LiqMaterialIcons.musicNote, context.appleColors.pink),
                      _carouselWidget(context, 'Videos', '89 Videos',
                          LiqMaterialIcons.videocam, context.appleColors.blue),
                      _carouselWidget(context, 'Documents', '234 Files',
                          LiqIcons.folder, context.appleColors.orange),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(4, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _currentCarouselPage == index
                              ? context.appleColors.blue
                              : context.appleColors.gray.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Widget Stack',
              description: 'Combine multiple widgets in a vertical stack.',
              child: LiqHomeWidgetStack(
                spacing: 12,
                widgets: <LiqHomeWidgetStackItem>[
                  LiqHomeWidgetStackItem(
                    widget: _stackWidget(context, 'Screen Time', '2h 34m today',
                        LiqMaterialIcons.phoneIphone, context.appleColors.blue),
                  ),
                  LiqHomeWidgetStackItem(
                    widget: Row(
                      children: <Widget>[
                        Expanded(
                          child: _stackWidget(
                              context,
                              'Focus',
                              'Work Mode',
                              LiqMaterialIcons.doNotDisturbOn,
                              context.appleColors.purple),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _stackWidget(
                              context,
                              'Music',
                              'Now Playing',
                              LiqMaterialIcons.musicNote,
                              context.appleColors.pink),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(
      BuildContext context, String label, String value, Color color) {
    return Column(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(LiqIcons.check, size: 20, color: color),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: context.textStyles.headline.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: context.textStyles.caption1.secondary),
      ],
    );
  }

  Widget _stackWidget(BuildContext context, String title, String subtitle,
      IconData icon, Color color) {
    return LiqHomeWidget(
      height: 80,
      padding: const EdgeInsets.all(12),
      content: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: context.textStyles.subheadline.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: context.textStyles.caption1.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _carouselWidget(BuildContext context, String title, String subtitle,
      IconData icon, Color color) {
    return LiqHomeWidget(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: context.textStyles.headline.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(subtitle, style: context.textStyles.body.secondary),
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
