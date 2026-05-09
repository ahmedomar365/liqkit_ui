import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class StatusBarDemoScreenV2 extends ConsumerStatefulWidget {
  const StatusBarDemoScreenV2({super.key});

  @override
  ConsumerState<StatusBarDemoScreenV2> createState() =>
      _StatusBarDemoScreenV2State();
}

class _StatusBarDemoScreenV2State
    extends ConsumerState<StatusBarDemoScreenV2> {
  bool _isDynamicIslandExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Status Bars')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Standard Status Bar',
              description:
                  'Default iOS status bar shown over a light surface.',
              child: _statusBarFrame(
                context,
                background: const Color(0xFFFFFFFF),
                child: const LiqStatusBar(brightness: Brightness.light),
                caption: 'Standard iOS status bar',
              ),
            ),
            _Section(
              title: 'Dark Status Bar',
              description: 'Same component over a dark backdrop.',
              child: _statusBarFrame(
                context,
                background: const Color(0xFF000000),
                child: const LiqStatusBar(brightness: Brightness.dark),
                caption: 'Dark style — light glyphs',
                captionLight: true,
              ),
            ),
            _Section(
              title: 'Custom Status Bar',
              description:
                  'Custom strip designed to match an app theme — gradient + branded label.',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 220,
                  child: Stack(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              context.appleColors.blue,
                              context.appleColors.purple,
                            ],
                          ),
                        ),
                        child: const SizedBox.expand(),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: LiqColors.black.withValues(alpha: 0.2),
                          padding:
                              const EdgeInsets.fromLTRB(16, 12, 16, 14),
                          child: Row(
                            children: <Widget>[
                              const Icon(LiqMaterialIcons.cloud,
                                  color: LiqColors.white, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                'Weather App',
                                style: context.textStyles.body.copyWith(
                                  color: LiqColors.white,
                                  fontWeight: LiqAppleTypography.semibold,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                LiqMaterialIcons.locationOn,
                                color: LiqColors.white.withValues(alpha: 0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'San Francisco',
                                style: TextStyle(
                                  color:
                                      LiqColors.white.withValues(alpha: 0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Text(
                          'Custom status bar with app-specific content',
                          style: TextStyle(color: LiqColors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _Section(
              title: 'Compact Status Strips',
              description:
                  'Minimal information bars that surface ongoing activity inline.',
              child: Column(
                children: <Widget>[
                  _compactStrip(
                    context,
                    title: 'Downloading 3 files...',
                    actions: <Widget>[
                      SizedBox(
                        width: 80,
                        child: LiqProgressBar(
                          value: 0.7,
                          progressColor: context.appleColors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '70%',
                        style: TextStyle(
                          fontSize: 11,
                          color: context.appleColors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _compactStrip(
                    context,
                    title: 'macOS Sonoma 14.2 Available',
                    background: context.appleColors.green.withValues(alpha: 0.1),
                    actions: <Widget>[
                      LiqButton(
                        label: 'Update',
                        size: LiqButtonSize.small,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _compactStrip(
                    context,
                    title: 'No Internet Connection',
                    background: context.appleColors.red.withValues(alpha: 0.1),
                    actions: <Widget>[
                      Icon(LiqMaterialIcons.wifiOff,
                          size: 16, color: context.appleColors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.appleColors.red,
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Dynamic Island',
              description:
                  'Tap the toggle to expand the island. Try different activities.',
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Expanded',
                          style: context.textStyles.body),
                      const SizedBox(width: 12),
                      LiqToggle(
                        value: _isDynamicIslandExpanded,
                        onChanged: (v) =>
                            setState(() => _isDynamicIslandExpanded = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 360,
                    width: 280,
                    decoration: BoxDecoration(
                      color: const Color(0xFF000000),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: const Color(0xFF444444), width: 3),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: ColoredBox(
                            color: const Color(0xFF1C1C1E),
                            child: Center(
                              child: Text(
                                'Phone screen',
                                style: TextStyle(
                                  color: LiqColors.white
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              width:
                                  _isDynamicIslandExpanded ? 240 : 130,
                              height:
                                  _isDynamicIslandExpanded ? 80 : 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF000000),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: _isDynamicIslandExpanded
                                    ? _expandedIslandContent(context)
                                    : _collapsedIslandContent(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'System Status Indicators',
              description: 'Pill-shaped chips representing common system signals.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _indicatorChip(context, LiqIcons.wifi, 'Wi-Fi',
                      context.appleColors.blue),
                  _indicatorChip(context, LiqMaterialIcons.bluetooth,
                      'Bluetooth', context.appleColors.blue),
                  _indicatorChip(context, LiqMaterialIcons.batteryFull,
                      'Battery', context.appleColors.green),
                  _indicatorChip(context, LiqMaterialIcons.signalCellularAlt,
                      'Cellular', context.appleColors.green),
                  _indicatorChip(context, LiqMaterialIcons.locationOn,
                      'Location', context.appleColors.blue),
                  _indicatorChip(context, LiqMaterialIcons.doNotDisturb,
                      'Focus', context.appleColors.purple),
                ],
              ),
            ),
            _Section(
              title: 'macOS Menu Bar Style',
              description:
                  'A strip mimicking the macOS menu bar with apple icon, menu items, and status icons.',
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.appleColors.separator),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(LiqMaterialIcons.apple,
                        color: LiqColors.black, size: 18),
                    const SizedBox(width: 16),
                    for (final m
                        in <String>['Finder', 'File', 'Edit', 'View', 'Help'])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          m,
                          style: const TextStyle(
                            fontSize: 13,
                            color: LiqColors.black,
                          ),
                        ),
                      ),
                    const Spacer(),
                    for (final i in <IconData>[
                      LiqIcons.wifi,
                      LiqMaterialIcons.batteryFull,
                      LiqMaterialIcons.accessTime,
                    ])
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Icon(
                          i,
                          size: 14,
                          color: LiqColors.black,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBarFrame(
    BuildContext context, {
    required Color background,
    required Widget child,
    required String caption,
    bool captionLight = false,
  }) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: context.appleColors.separator),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          ColoredBox(color: background),
          Positioned(top: 0, left: 0, right: 0, child: child),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Text(
              caption,
              style: TextStyle(
                color: captionLight
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF000000),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactStrip(
    BuildContext context, {
    required String title,
    required List<Widget> actions,
    Color? background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background ?? context.appleColors.gray.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(title, style: context.textStyles.footnote),
          ),
          ...actions,
        ],
      ),
    );
  }

  Widget _collapsedIslandContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: context.appleColors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Phone Call',
          style: TextStyle(
            color: LiqColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _expandedIslandContent(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.appleColors.green,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(LiqIcons.phone, color: LiqColors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Phone Call',
                style: TextStyle(
                  color: LiqColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '03:42 with John',
                style: TextStyle(
                  color: LiqColors.white.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _indicatorChip(
      BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: LiqAppleTypography.semibold,
              fontSize: 13,
            ),
          ),
        ],
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
