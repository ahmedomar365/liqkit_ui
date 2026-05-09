import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class ToggleDemoScreen extends ConsumerStatefulWidget {
  const ToggleDemoScreen({super.key});

  @override
  ConsumerState<ToggleDemoScreen> createState() => _ToggleDemoScreenState();
}

class _ToggleDemoScreenState extends ConsumerState<ToggleDemoScreen> {
  bool _basicToggle = true;
  bool _scaledToggle = true;

  bool _wifiEnabled = true;
  bool _bluetoothEnabled = false;
  bool _airplaneMode = false;
  bool _doNotDisturb = false;
  bool _lowPowerMode = false;

  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _inAppNotifications = true;

  bool _locationServices = true;
  bool _cameraAccess = true;
  bool _microphoneAccess = false;
  bool _contactsAccess = true;

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Toggles')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Basic',
              description: 'Simple on/off switches with default styling.',
              child: Column(
                children: <Widget>[
                  _toggleRow(context, 'Basic Toggle', _basicToggle,
                      (v) => setState(() => _basicToggle = v)),
                  const SizedBox(height: 16),
                  _toggleRow(context, 'Disabled (On)', true, null),
                  const SizedBox(height: 16),
                  _toggleRow(context, 'Disabled (Off)', false, null),
                ],
              ),
            ),
            _Section(
              title: 'Sizes',
              description: 'Use scale to size toggles for compact or accessibility contexts.',
              child: Column(
                children: <Widget>[
                  _scaledToggleRow(
                    context,
                    'Small (0.8x)',
                    _scaledToggle,
                    (v) => setState(() => _scaledToggle = v),
                    0.8,
                  ),
                  const SizedBox(height: 16),
                  _scaledToggleRow(
                    context,
                    'Default (1.0x)',
                    _scaledToggle,
                    (v) => setState(() => _scaledToggle = v),
                    1.0,
                  ),
                  const SizedBox(height: 16),
                  _scaledToggleRow(
                    context,
                    'Large (1.2x)',
                    _scaledToggle,
                    (v) => setState(() => _scaledToggle = v),
                    1.2,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Colored',
              description: 'Toggles with custom active colors.',
              child: Column(
                children: <Widget>[
                  for (final entry in <({String name, Color color})>[
                    (name: 'Green (Default)', color: context.appleColors.green),
                    (name: 'Blue', color: context.appleColors.blue),
                    (name: 'Red', color: context.appleColors.red),
                    (name: 'Orange', color: context.appleColors.orange),
                    (name: 'Purple', color: context.appleColors.purple),
                    (name: 'Pink', color: context.appleColors.pink),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(entry.name, style: context.textStyles.body),
                          LiqToggle(
                            value: true,
                            activeColor: entry.color,
                            onChanged: (_) {},
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Settings — Connectivity',
              description: 'Grouped toggles in a settings-style list section.',
              child: LiqListSection(
                header: 'Connectivity',
                children: <LiqListRow>[
                  LiqListRow(
                    title: 'Wi-Fi',
                    subtitle: 'HomePod Network',
                    leading: Icon(LiqIcons.wifi, color: context.appleColors.blue),
                    trailing: LiqToggle(
                      value: _wifiEnabled,
                      onChanged: (v) => setState(() => _wifiEnabled = v),
                    ),
                  ),
                  LiqListRow(
                    title: 'Bluetooth',
                    leading: Icon(LiqMaterialIcons.bluetooth,
                        color: context.appleColors.blue),
                    trailing: LiqToggle(
                      value: _bluetoothEnabled,
                      onChanged: (v) => setState(() => _bluetoothEnabled = v),
                    ),
                  ),
                  LiqListRow(
                    title: 'Airplane Mode',
                    leading: Icon(LiqMaterialIcons.airplanemodeActive,
                        color: context.appleColors.orange),
                    trailing: LiqToggle(
                      value: _airplaneMode,
                      activeColor: context.appleColors.orange,
                      onChanged: (v) => setState(() => _airplaneMode = v),
                    ),
                  ),
                  LiqListRow(
                    title: 'Cellular Data',
                    leading: Icon(LiqMaterialIcons.signalCellularAlt,
                        color: context.appleColors.green),
                    trailing: LiqToggle(value: true, onChanged: (_) {}),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Settings — Focus',
              description: 'Another settings section showing Do Not Disturb / Sleep Focus.',
              child: LiqListSection(
                header: 'Focus',
                children: <LiqListRow>[
                  LiqListRow(
                    title: 'Do Not Disturb',
                    subtitle: 'Silence calls and notifications',
                    leading: Icon(LiqMaterialIcons.doNotDisturb,
                        color: context.appleColors.purple),
                    trailing: LiqToggle(
                      value: _doNotDisturb,
                      activeColor: context.appleColors.purple,
                      onChanged: (v) => setState(() => _doNotDisturb = v),
                    ),
                  ),
                  LiqListRow(
                    title: 'Sleep Focus',
                    subtitle: 'Wind down for better sleep',
                    leading: Icon(LiqMaterialIcons.bedtime,
                        color: context.appleColors.indigo),
                    trailing: LiqToggle(
                      value: false,
                      activeColor: context.appleColors.indigo,
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Notification Settings',
              description: 'Toggles inside a list group with leading icons and subtitles.',
              child: LiqListGroup(
                rows: <LiqListRow>[
                  LiqListRow(
                    title: 'Email Notifications',
                    subtitle: 'Receive email alerts',
                    leading: Icon(LiqMaterialIcons.email,
                        color: context.appleColors.blue),
                    trailing: LiqToggle(
                      value: _emailNotifications,
                      onChanged: (v) =>
                          setState(() => _emailNotifications = v),
                    ),
                  ),
                  LiqListRow(
                    title: 'Push Notifications',
                    subtitle: 'Get real-time updates',
                    leading: Icon(LiqMaterialIcons.notifications,
                        color: context.appleColors.red),
                    trailing: LiqToggle(
                      value: _pushNotifications,
                      onChanged: (v) =>
                          setState(() => _pushNotifications = v),
                    ),
                  ),
                  LiqListRow(
                    title: 'SMS Notifications',
                    subtitle: 'Text message alerts',
                    leading: Icon(LiqMaterialIcons.sms,
                        color: context.appleColors.green),
                    trailing: LiqToggle(
                      value: _smsNotifications,
                      onChanged: (v) =>
                          setState(() => _smsNotifications = v),
                    ),
                  ),
                  LiqListRow(
                    title: 'In-App Notifications',
                    subtitle: 'Show notifications in app',
                    leading: Icon(LiqMaterialIcons.appSettingsAlt,
                        color: context.appleColors.orange),
                    trailing: LiqToggle(
                      value: _inAppNotifications,
                      onChanged: (v) =>
                          setState(() => _inAppNotifications = v),
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Accessibility',
              description: 'Larger toggles for improved accessibility.',
              child: Column(
                children: <Widget>[
                  _accessibilityRow(
                    context,
                    LiqMaterialIcons.recordVoiceOver,
                    'VoiceOver',
                    'Screen reader for blind users',
                    false,
                    scale: 1.3,
                  ),
                  const SizedBox(height: 16),
                  _accessibilityRow(
                    context,
                    LiqMaterialIcons.zoomIn,
                    'Zoom',
                    'Magnify the screen',
                    true,
                    scale: 1.3,
                  ),
                  const SizedBox(height: 16),
                  _accessibilityRow(
                    context,
                    LiqMaterialIcons.textIncrease,
                    'Larger Text',
                    'Increase text size',
                    false,
                    scale: 1.3,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Custom Track / Thumb',
              description: 'Toggles with custom track and thumb colors.',
              child: Column(
                children: <Widget>[
                  _customStyledRow(
                    context,
                    'Dark Mode',
                    true,
                    activeColor: context.appleColors.gray,
                    inactiveColor: LiqAppleColors.systemGray5,
                  ),
                  const SizedBox(height: 16),
                  _customStyledRow(
                    context,
                    'Low Power Mode',
                    _lowPowerMode,
                    activeColor: context.appleColors.yellow,
                    onChanged: (v) => setState(() => _lowPowerMode = v),
                  ),
                  const SizedBox(height: 16),
                  _customStyledRow(
                    context,
                    'Night Shift',
                    true,
                    activeColor: context.appleColors.orange.withValues(alpha: 0.8),
                    thumbColor: const Color(0xFFFFF3E0),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Privacy Group',
              description: 'Multiple settings sections plus a destructive bulk action.',
              child: Column(
                children: <Widget>[
                  LiqListSection(
                    header: 'Location Services',
                    children: <LiqListRow>[
                      LiqListRow(
                        title: 'Location Services',
                        subtitle: 'Allow apps to use your location',
                        leading: Icon(LiqMaterialIcons.locationOn,
                            color: context.appleColors.blue),
                        trailing: LiqToggle(
                          value: _locationServices,
                          onChanged: (v) =>
                              setState(() => _locationServices = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LiqListSection(
                    header: 'App Permissions',
                    children: <LiqListRow>[
                      LiqListRow(
                        title: 'Camera',
                        subtitle: 'Allow access to camera',
                        leading: Icon(LiqMaterialIcons.cameraAlt,
                            color: context.appleColors.gray),
                        trailing: LiqToggle(
                          value: _cameraAccess,
                          onChanged: (v) =>
                              setState(() => _cameraAccess = v),
                        ),
                      ),
                      LiqListRow(
                        title: 'Microphone',
                        subtitle: 'Allow access to microphone',
                        leading: Icon(LiqMaterialIcons.mic,
                            color: context.appleColors.orange),
                        trailing: LiqToggle(
                          value: _microphoneAccess,
                          onChanged: (v) =>
                              setState(() => _microphoneAccess = v),
                        ),
                      ),
                      LiqListRow(
                        title: 'Contacts',
                        subtitle: 'Allow access to contacts',
                        leading: Icon(LiqMaterialIcons.contacts,
                            color: context.appleColors.blue),
                        trailing: LiqToggle(
                          value: _contactsAccess,
                          onChanged: (v) =>
                              setState(() => _contactsAccess = v),
                        ),
                      ),
                      LiqListRow(
                        title: 'Photos',
                        subtitle: 'Allow access to photo library',
                        leading: Icon(LiqMaterialIcons.photoLibrary,
                            color: context.appleColors.pink),
                        trailing: LiqToggle(value: false, onChanged: (_) {}),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  LiqButton(
                    label: 'Reset All Permissions',
                    destructive: true,
                    size: LiqButtonSize.large,
                    fullWidth: true,
                    onPressed: () => setState(() {
                      _locationServices = false;
                      _cameraAccess = false;
                      _microphoneAccess = false;
                      _contactsAccess = false;
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleRow(BuildContext context, String label, bool value,
      ValueChanged<bool>? onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: context.textStyles.body),
        LiqToggle(value: value, onChanged: onChanged),
      ],
    );
  }

  Widget _scaledToggleRow(
    BuildContext context,
    String label,
    bool value,
    ValueChanged<bool>? onChanged,
    double scale,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: context.textStyles.body),
        LiqToggle(value: value, scale: scale, onChanged: onChanged),
      ],
    );
  }

  Widget _accessibilityRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool value, {
    double scale = 1.0,
  }) {
    return Row(
      children: <Widget>[
        Icon(icon, color: context.appleColors.blue, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: context.textStyles.headline),
              Text(subtitle, style: context.textStyles.footnote.secondary),
            ],
          ),
        ),
        LiqToggle(value: value, scale: scale, onChanged: (_) {}),
      ],
    );
  }

  Widget _customStyledRow(
    BuildContext context,
    String label,
    bool value, {
    Color? activeColor,
    Color? inactiveColor,
    Color? thumbColor,
    ValueChanged<bool>? onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: context.textStyles.body),
        LiqToggle(
          value: value,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          thumbColor: thumbColor,
          onChanged: onChanged ?? (_) {},
        ),
      ],
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
