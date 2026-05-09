import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class AppIconDemoScreen extends ConsumerStatefulWidget {
  const AppIconDemoScreen({super.key});

  @override
  ConsumerState<AppIconDemoScreen> createState() =>
      _AppIconDemoScreenState();
}

class _AppIconDemoScreenState extends ConsumerState<AppIconDemoScreen> {
  bool _isEditMode = false;
  bool _showBadges = true;
  double _downloadProgress = 0;
  bool _isDownloading = false;

  static final List<({IconData icon, String label, Color color, int badge})>
      _appData =
      <({IconData icon, String label, Color color, int badge})>[
    (
      icon: LiqIcons.message,
      label: 'Messages',
      color: LiqAppleColors.systemGreen,
      badge: 5,
    ),
    (
      icon: LiqIcons.phone,
      label: 'Phone',
      color: LiqAppleColors.systemGreen,
      badge: 0,
    ),
    (
      icon: LiqIcons.mail,
      label: 'Mail',
      color: LiqAppleColors.systemBlue,
      badge: 127,
    ),
    (
      icon: LiqMaterialIcons.musicNote,
      label: 'Music',
      color: LiqAppleColors.systemRed,
      badge: 0,
    ),
    (
      icon: LiqMaterialIcons.cameraAlt,
      label: 'Camera',
      color: LiqAppleColors.systemGray,
      badge: 0,
    ),
    (
      icon: LiqMaterialIcons.map,
      label: 'Maps',
      color: LiqAppleColors.systemGreen,
      badge: 0,
    ),
    (
      icon: LiqMaterialIcons.cloud,
      label: 'Weather',
      color: LiqAppleColors.systemBlue,
      badge: 0,
    ),
    (
      icon: LiqMaterialIcons.note,
      label: 'Notes',
      color: LiqAppleColors.systemYellow,
      badge: 3,
    ),
    (
      icon: LiqMaterialIcons.alarm,
      label: 'Clock',
      color: LiqAppleColors.systemGray,
      badge: 0,
    ),
    (
      icon: LiqMaterialIcons.photoLibrary,
      label: 'Photos',
      color: LiqAppleColors.systemTeal,
      badge: 0,
    ),
    (
      icon: LiqIcons.settings,
      label: 'Settings',
      color: LiqAppleColors.systemGray,
      badge: 1,
    ),
    (
      icon: LiqMaterialIcons.calendarToday,
      label: 'Calendar',
      color: LiqAppleColors.systemRed,
      badge: 2,
    ),
  ];

  static final List<({IconData icon, String label, Color color})> _dockApps =
      <({IconData icon, String label, Color color})>[
    (icon: LiqIcons.phone, label: 'Phone', color: LiqAppleColors.systemGreen),
    (icon: LiqIcons.message, label: 'Messages', color: LiqAppleColors.systemGreen),
    (icon: LiqMaterialIcons.web, label: 'Safari', color: LiqAppleColors.systemBlue),
    (icon: LiqIcons.mail, label: 'Mail', color: LiqAppleColors.systemBlue),
  ];

  Future<void> _startDownload() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });
    while (mounted && _isDownloading) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() {
        _downloadProgress += 0.05;
        if (_downloadProgress >= 1.0) {
          _downloadProgress = 1.0;
          _isDownloading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('App Icons')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _section(
              title: 'Controls',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  LiqButton(
                    label: _isEditMode ? 'Done' : 'Edit Mode',
                    style: LiqButtonStyle.borderedSecondary,
                    onPressed: () =>
                        setState(() => _isEditMode = !_isEditMode),
                  ),
                  LiqButton(
                    label: _showBadges ? 'Hide Badges' : 'Show Badges',
                    style: LiqButtonStyle.borderedSecondary,
                    onPressed: () =>
                        setState(() => _showBadges = !_showBadges),
                  ),
                  LiqButton(
                    label: 'Download App',
                    style: LiqButtonStyle.borderedSecondary,
                    onPressed: _isDownloading ? null : _startDownload,
                  ),
                ],
              ),
            ),
            _section(
              title: 'Single Icons',
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: <Widget>[
                  LiqHomeIcon(
                    icon: LiqMaterialIcons.apps,
                    label: 'App Store',
                    backgroundColor: LiqAppleColors.systemBlue,
                    onPressed: () => LiqToastOverlay.show(context, 'App Store'),
                  ),
                  LiqHomeIcon(
                    icon: LiqIcons.download,
                    label: 'Downloads',
                    backgroundColor: LiqAppleColors.systemGreen,
                    isDownloading: _isDownloading,
                    downloadProgress: _downloadProgress,
                    onPressed: () =>
                        LiqToastOverlay.show(context, 'Downloads'),
                  ),
                  LiqHomeIcon(
                    icon: LiqMaterialIcons.notifications,
                    label: 'Notifications',
                    backgroundColor: LiqAppleColors.systemRed,
                    showBadge: _showBadges,
                    badgeCount: 15,
                    onPressed: () =>
                        LiqToastOverlay.show(context, 'Notifications'),
                  ),
                ],
              ),
            ),
            _section(
              title: 'Different Sizes',
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: <Widget>[
                  LiqHomeIcon(
                    icon: LiqMaterialIcons.photo,
                    label: 'Small',
                    size: 40,
                    backgroundColor: LiqAppleColors.systemOrange,
                    onPressed: () => LiqToastOverlay.show(context, 'Small'),
                  ),
                  LiqHomeIcon(
                    icon: LiqMaterialIcons.photo,
                    label: 'Medium',
                    size: 60,
                    backgroundColor: LiqAppleColors.systemOrange,
                    onPressed: () => LiqToastOverlay.show(context, 'Medium'),
                  ),
                  LiqHomeIcon(
                    icon: LiqMaterialIcons.photo,
                    label: 'Large',
                    size: 80,
                    backgroundColor: LiqAppleColors.systemOrange,
                    onPressed: () => LiqToastOverlay.show(context, 'Large'),
                  ),
                ],
              ),
            ),
            _section(
              title: 'App Icon Grid',
              child: LiqAppIconGrid(
                isEditing: _isEditMode,
                icons: <Widget>[
                  for (final app in _appData)
                    LiqHomeIcon(
                      icon: app.icon,
                      label: app.label,
                      backgroundColor: app.color,
                      showBadge: _showBadges && app.badge > 0,
                      badgeCount: app.badge,
                      isEditing: _isEditMode,
                      onPressed: () =>
                          LiqToastOverlay.show(context, app.label),
                      onLongPress: () =>
                          setState(() => _isEditMode = true),
                      onDelete: () =>
                          LiqToastOverlay.show(context, 'Delete ${app.label}'),
                    ),
                ],
              ),
            ),
            _section(
              title: 'Folders',
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: <Widget>[
                  LiqFolderIcon(
                    label: 'Productivity',
                    previewIcons: const <IconData>[
                      LiqMaterialIcons.note,
                      LiqMaterialIcons.calendarToday,
                      LiqMaterialIcons.task,
                      LiqMaterialIcons.timer,
                    ],
                    onTap: () =>
                        LiqToastOverlay.show(context, 'Productivity'),
                  ),
                  LiqFolderIcon(
                    label: 'Social',
                    previewIcons: const <IconData>[
                      LiqMaterialIcons.chat,
                      LiqMaterialIcons.group,
                      LiqIcons.share,
                      LiqMaterialIcons.thumbUp,
                      LiqMaterialIcons.favorite,
                      LiqMaterialIcons.comment,
                    ],
                    backgroundColor:
                        LiqAppleColors.systemPink.withValues(alpha: 0.5),
                    onTap: () => LiqToastOverlay.show(context, 'Social'),
                  ),
                  LiqFolderIcon(
                    label: 'Games',
                    previewIcons: const <IconData>[
                      LiqMaterialIcons.sportsEsports,
                      LiqMaterialIcons.casino,
                      LiqMaterialIcons.sportsSoccer,
                      LiqMaterialIcons.extension,
                      LiqMaterialIcons.rocket,
                      LiqIcons.star,
                      LiqMaterialIcons.emojiEvents,
                      LiqMaterialIcons.flag,
                      LiqMaterialIcons.sportsScore,
                    ],
                    backgroundColor:
                        LiqAppleColors.systemIndigo.withValues(alpha: 0.5),
                    isOpen: true,
                    onTap: () => LiqToastOverlay.show(context, 'Games'),
                  ),
                ],
              ),
            ),
            _section(
              title: 'App Dock',
              child: Center(
                child: LiqAppIconDock(
                  icons: <Widget>[
                    for (final app in _dockApps)
                      LiqHomeIcon(
                        icon: app.icon,
                        backgroundColor: app.color,
                        size: 56,
                        onPressed: () =>
                            LiqToastOverlay.show(context, app.label),
                      ),
                  ],
                ),
              ),
            ),
            _section(
              title: 'Custom Colors',
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: <Widget>[
                  LiqHomeIcon(
                    icon: LiqMaterialIcons.brush,
                    label: 'Design',
                    backgroundColor: const Color(0xFF9C27B0),
                    onPressed: () => LiqToastOverlay.show(context, 'Design'),
                  ),
                  LiqHomeIcon(
                    icon: LiqMaterialIcons.code,
                    label: 'Code',
                    backgroundColor: const Color(0xFFFF5722),
                    iconColor: LiqColors.white,
                    onPressed: () => LiqToastOverlay.show(context, 'Code'),
                  ),
                  LiqHomeIcon(
                    icon: LiqMaterialIcons.science,
                    label: 'Lab',
                    backgroundColor: const Color(0xFF009688),
                    onPressed: () => LiqToastOverlay.show(context, 'Lab'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title2.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
