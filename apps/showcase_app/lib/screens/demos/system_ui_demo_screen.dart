import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class SystemUIDemoScreen extends ConsumerStatefulWidget {
  const SystemUIDemoScreen({super.key});

  @override
  ConsumerState<SystemUIDemoScreen> createState() =>
      _SystemUIDemoScreenState();
}

class _SystemUIDemoScreenState extends ConsumerState<SystemUIDemoScreen> {
  bool _showOverlay = false;
  bool _showSystemAlert = false;
  int _selectedNavIndex = 0;
  final Map<String, bool> _controlCenterStates = <String, bool>{
    'wifi': true,
    'bluetooth': true,
    'airplane': false,
    'cellular': true,
    'hotspot': false,
    'airdrop': false,
  };

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('System UI Components')),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              _section(
                title: 'System Overlay',
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: LiqButton(
                        label: 'Show Loading Overlay',
                        onPressed: () {
                          setState(() => _showOverlay = true);
                          Future<void>.delayed(
                            const Duration(seconds: 3),
                            () {
                              if (mounted) {
                                setState(() => _showOverlay = false);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              _section(
                title: 'System Alerts',
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: LiqButton(
                        label: 'Show System Alert',
                        onPressed: () {
                          setState(() => _showSystemAlert = true);
                          Future<void>.delayed(
                            const Duration(seconds: 5),
                            () {
                              if (mounted) {
                                setState(() => _showSystemAlert = false);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _alertPreview(
                      'Success Alert',
                      LiqSystemAlertStyle.success,
                      LiqMaterialIcons.checkCircle,
                    ),
                    const SizedBox(height: 12),
                    _alertPreview(
                      'Warning Alert',
                      LiqSystemAlertStyle.warning,
                      LiqIcons.warning,
                    ),
                    const SizedBox(height: 12),
                    _alertPreview(
                      'Error Alert',
                      LiqSystemAlertStyle.error,
                      LiqIcons.error,
                    ),
                  ],
                ),
              ),
              _section(
                title: 'System Navigation Bar',
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          context.appleColors.gray.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: <Widget>[
                      ColoredBox(
                        color: context.appleColors.gray.withValues(alpha: 0.05),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LiqIconBar(
                          items: <Widget>[
                            for (var i = 0; i < 5; i++)
                              LiqIconBarItem(
                                icon: <IconData>[
                                  LiqIcons.home,
                                  LiqIcons.search,
                                  LiqMaterialIcons.addBoxOutlined,
                                  LiqMaterialIcons.favoriteOutline,
                                  LiqMaterialIcons.personOutline,
                                ][i],
                                label: <String>[
                                  'Home',
                                  'Search',
                                  'Create',
                                  'Activity',
                                  'Profile',
                                ][i],
                                badge: i == 3 ? '3' : null,
                                isSelected: _selectedNavIndex == i,
                                onTap: () =>
                                    setState(() => _selectedNavIndex = i),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _section(
                title: 'Control Center',
                child: LiqControlCenter(
                  sections: <List<LiqControlCenterTile>>[
                    <LiqControlCenterTile>[
                      LiqControlCenterTile(
                        icon: LiqIcons.wifi,
                        label: 'Wi-Fi',
                        isActive: _controlCenterStates['wifi']!,
                        onTap: () => setState(() {
                          _controlCenterStates['wifi'] =
                              !_controlCenterStates['wifi']!;
                        }),
                      ),
                      LiqControlCenterTile(
                        icon: LiqMaterialIcons.bluetooth,
                        label: 'Bluetooth',
                        isActive: _controlCenterStates['bluetooth']!,
                        activeColor: context.appleColors.blue,
                        onTap: () => setState(() {
                          _controlCenterStates['bluetooth'] =
                              !_controlCenterStates['bluetooth']!;
                        }),
                      ),
                      LiqControlCenterTile(
                        icon: LiqMaterialIcons.airplanemodeActive,
                        label: 'Airplane',
                        isActive: _controlCenterStates['airplane']!,
                        activeColor: context.appleColors.orange,
                        onTap: () => setState(() {
                          _controlCenterStates['airplane'] =
                              !_controlCenterStates['airplane']!;
                        }),
                      ),
                    ],
                    <LiqControlCenterTile>[
                      LiqControlCenterTile(
                        icon: LiqMaterialIcons.signalCellular4Bar,
                        label: 'Cellular',
                        isActive: _controlCenterStates['cellular']!,
                        activeColor: context.appleColors.green,
                        onTap: () => setState(() {
                          _controlCenterStates['cellular'] =
                              !_controlCenterStates['cellular']!;
                        }),
                      ),
                      LiqControlCenterTile(
                        icon: LiqMaterialIcons.wifiTethering,
                        label: 'Hotspot',
                        isActive: _controlCenterStates['hotspot']!,
                        activeColor: context.appleColors.green,
                        onTap: () => setState(() {
                          _controlCenterStates['hotspot'] =
                              !_controlCenterStates['hotspot']!;
                        }),
                      ),
                      LiqControlCenterTile(
                        icon: LiqIcons.share,
                        label: 'AirDrop',
                        isActive: _controlCenterStates['airdrop']!,
                        onTap: () => setState(() {
                          _controlCenterStates['airdrop'] =
                              !_controlCenterStates['airdrop']!;
                        }),
                      ),
                    ],
                  ],
                ),
              ),
              _section(
                title: 'Quick Actions',
                child: Column(
                  children: <Widget>[
                    Text('Horizontal Actions',
                        style: context.textStyles.subheadline),
                    const SizedBox(height: 16),
                    LiqQuickActionsRow(
                      actions: <LiqQuickAction>[
                        LiqQuickAction(
                          icon: LiqMaterialIcons.cameraAlt,
                          color: context.appleColors.blue,
                          onTap: () {},
                        ),
                        LiqQuickAction(
                          icon: LiqMaterialIcons.qrCodeScanner,
                          color: context.appleColors.purple,
                          onTap: () {},
                        ),
                        LiqQuickAction(
                          icon: LiqMaterialIcons.flashlightOn,
                          color: context.appleColors.yellow,
                          onTap: () {},
                        ),
                        LiqQuickAction(
                          icon: LiqMaterialIcons.calculate,
                          color: context.appleColors.orange,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Vertical Actions',
                        style: context.textStyles.subheadline),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.appleColors.gray.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: LiqQuickActionsRow(
                        direction: Axis.vertical,
                        actions: <LiqQuickAction>[
                          LiqQuickAction(
                            icon: LiqMaterialIcons.alarm,
                            color: context.appleColors.orange,
                            onTap: () {},
                          ),
                          LiqQuickAction(
                            icon: LiqMaterialIcons.timer,
                            color: context.appleColors.blue,
                            onTap: () {},
                          ),
                          LiqQuickAction(
                            icon: LiqMaterialIcons.bedtime,
                            color: context.appleColors.purple,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _section(
                title: 'Haptic Feedback',
                child: Column(
                  children: <Widget>[
                    _hapticButton('Light Impact', HapticFeedback.lightImpact),
                    const SizedBox(height: 8),
                    _hapticButton(
                        'Medium Impact', HapticFeedback.mediumImpact),
                    const SizedBox(height: 8),
                    _hapticButton('Heavy Impact', HapticFeedback.heavyImpact),
                    const SizedBox(height: 8),
                    _hapticButton(
                        'Selection Click', HapticFeedback.selectionClick),
                  ],
                ),
              ),
            ],
          ),
          LiqSystemOverlay(
            isVisible: _showOverlay,
            message: 'Loading content...',
            dismissible: true,
            onDismiss: () => setState(() => _showOverlay = false),
          ),
          if (_showSystemAlert)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 0,
              right: 0,
              child: LiqSystemAlert(
                title: 'System Notification',
                message:
                    'This is an important system message that requires your attention.',
                icon: LiqIcons.info,
                actions: <LiqSystemAlertAction>[
                  LiqSystemAlertAction(
                    title: 'Dismiss',
                    onPressed: () =>
                        setState(() => _showSystemAlert = false),
                  ),
                  LiqSystemAlertAction(
                    title: 'View',
                    onPressed: () =>
                        setState(() => _showSystemAlert = false),
                  ),
                ],
                onDismiss: () => setState(() => _showSystemAlert = false),
              ),
            ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: context.textStyles.title2.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        const SizedBox(height: 16),
        child,
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _alertPreview(String title, LiqSystemAlertStyle style, IconData icon) {
    return LiqSystemAlert(
      title: title,
      message: 'This is a $title demonstration.',
      icon: icon,
      style: style,
      dismissible: false,
    );
  }

  Widget _hapticButton(String label, Future<void> Function() haptic) {
    return SizedBox(
      width: double.infinity,
      child: LiqButton(
        label: label,
        style: LiqButtonStyle.borderedSecondary,
        onPressed: () => haptic(),
      ),
    );
  }
}
