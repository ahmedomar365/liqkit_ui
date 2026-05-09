import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/providers/app_settings_provider.dart';
import '../core/theme/liquid_theme.dart';
import '../l10n/app_localizations.dart';

const _githubUrl = 'https://github.com/ahmedomar365/liqkit_ui';
const _pubDevUrl = 'https://pub.dev/packages/liqkit_ui';

const _mitLicenseText = '''MIT License

Copyright (c) 2026 Ahmed Omar

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.''';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);
    final isDarkMode =
        ref.watch(liquidThemeProvider).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          l10n?.settings ?? 'Settings',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SectionHeader(title: l10n?.language ?? 'Language'),
            const SizedBox(height: 12),
            LiqCard(
              onTap: () => _showLanguageSelector(context, ref),
              child: LiqListRow(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.appleColors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LiqMaterialIcons.language, color: LiqColors.blue),
                ),
                title: l10n?.language ?? 'Language',
                subtitle: getLanguageInfo(appSettings.locale).nativeName,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      getLanguageInfo(appSettings.locale).flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      LiqMaterialIcons.chevronRight,
                      color: context.appleColors.tertiaryLabel,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _SectionHeader(title: l10n?.appearance ?? 'Appearance'),
            const SizedBox(height: 12),
            LiqCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  LiqListRow(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.appleColors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isDarkMode ? LiqMaterialIcons.darkMode : LiqMaterialIcons.lightMode,
                        color: context.appleColors.purple,
                      ),
                    ),
                    title: l10n?.darkMode ?? 'Dark Mode',
                    trailing: LiqToggle(
                      value: isDarkMode,
                      onChanged: (_) {
                        ref
                            .read(liquidThemeProvider.notifier)
                            .toggleTheme();
                      },
                    ),
                  ),
                  const SizedBox(height: 1, child: Center(child: LiqDivider(indent: 68))),
                  LiqListRow(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.appleColors.orange
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LiqMaterialIcons.animation,
                        color: context.appleColors.orange,
                      ),
                    ),
                    title: l10n?.animations ?? 'Animations',
                    trailing: LiqToggle(
                      value: appSettings.enableAnimations,
                      onChanged: (_) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .toggleAnimations();
                      },
                    ),
                  ),
                  const SizedBox(height: 1, child: Center(child: LiqDivider(indent: 68))),
                  LiqListRow(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.appleColors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LiqMaterialIcons.blurOn,
                        color: context.appleColors.teal,
                      ),
                    ),
                    title: l10n?.blurEffects ?? 'Blur Effects',
                    subtitle: l10n?.blurEffectsDescription ??
                        'May impact performance',
                    trailing: LiqToggle(
                      value: appSettings.enableBlurEffects,
                      onChanged: (_) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .toggleBlurEffects();
                      },
                    ),
                  ),
                  const SizedBox(height: 1, child: Center(child: LiqDivider(indent: 68))),
                  LiqListRow(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.appleColors.indigo
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LiqMaterialIcons.vibration,
                        color: context.appleColors.indigo,
                      ),
                    ),
                    title: l10n?.hapticFeedback ?? 'Haptic Feedback',
                    trailing: LiqToggle(
                      value: appSettings.enableHaptics,
                      onChanged: (_) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .toggleHaptics();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _SectionHeader(title: 'liqkit_ui'),
            const SizedBox(height: 12),
            LiqCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  LiqListRow(
                    onTap: () => _launchUrl(context, _githubUrl),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF24292E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LiqMaterialIcons.code,
                        color: LiqColors.white,
                      ),
                    ),
                    title: 'View on GitHub',
                    subtitle: 'github.com/ahmedomar365/liqkit_ui',
                    trailing: Icon(
                      LiqMaterialIcons.openInNew,
                      color: context.appleColors.tertiaryLabel,
                    ),
                  ),
                  const SizedBox(height: 1, child: Center(child: LiqDivider(indent: 68))),
                  LiqListRow(
                    onTap: () => _launchUrl(context, _pubDevUrl),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0175C2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LiqMaterialIcons.archive,
                        color: LiqColors.white,
                      ),
                    ),
                    title: 'View on pub.dev',
                    subtitle: 'pub.dev/packages/liqkit_ui',
                    trailing: Icon(
                      LiqMaterialIcons.openInNew,
                      color: context.appleColors.tertiaryLabel,
                    ),
                  ),
                  const SizedBox(height: 1, child: Center(child: LiqDivider(indent: 68))),
                  LiqListRow(
                    onTap: () => _showLicense(context),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.appleColors.green
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LiqMaterialIcons.docFill,
                        color: context.appleColors.green,
                      ),
                    ),
                    title: 'License',
                    subtitle: 'MIT — free for personal & commercial use',
                    trailing: Icon(
                      LiqMaterialIcons.chevronRight,
                      color: context.appleColors.tertiaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _SectionHeader(title: l10n?.about ?? 'About'),
            const SizedBox(height: 12),
            LiqCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  LiqListRow(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            context.appleColors.blue,
                            context.appleColors.purple,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LiqMaterialIcons.waterDrop,
                        color: LiqColors.white,
                      ),
                    ),
                    title: 'Flutter Liquid UI Kit',
                    subtitle: 'Version 1.0.0',
                    trailing: Icon(
                      LiqMaterialIcons.chevronRight,
                      color: context.appleColors.tertiaryLabel,
                    ),
                  ),
                  const SizedBox(height: 1, child: Center(child: LiqDivider(indent: 68))),
                  LiqListRow(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            context.appleColors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LiqMaterialIcons.favorite,
                        color: context.appleColors.red,
                      ),
                    ),
                    title: l10n?.madeWithLove ?? 'Made with Love',
                    subtitle: 'Built with Flutter & Riverpod',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(appSettingsProvider).locale;
    LiqActionSheet.show<void>(
      context: context,
      title: 'Select Language',
      actions: availableLanguages.map((lang) {
        return LiqAlertAction(
          label: '${lang.flag} ${lang.nativeName}',
          style: lang.locale == currentLocale
              ? LiqAlertActionStyle.filled
              : LiqAlertActionStyle.regular,
          onPressed: () {
            ref.read(appSettingsProvider.notifier).setLocale(lang.locale);
            Navigator.of(context).pop();
          },
        );
      }).toList(),
    );
  }
}

Future<void> _launchUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    if (!context.mounted) return;
    LiqAlert.show<void>(
      context: context,
      title: "Couldn't open link",
      description: url,
      actions: [
        LiqAlertAction(
          label: 'OK',
          style: LiqAlertActionStyle.filled,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

void _showLicense(BuildContext context) {
  LiqSheet.show<void>(
    context: context,
    title: 'MIT License',
    height: 560,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: SingleChildScrollView(
        child: Text(
          _mitLicenseText,
          style: context.textStyles.callout,
        ),
      ),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title.toUpperCase(),
        style: context.textStyles.footnote.copyWith(
          color: context.appleColors.secondaryLabel,
          fontWeight: LiqAppleTypography.medium,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
