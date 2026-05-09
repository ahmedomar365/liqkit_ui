import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import 'core/providers/app_settings_provider.dart';
import 'core/theme/liquid_theme.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';

const _rtlLanguageCodes = {'ar', 'he', 'fa', 'ur'};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-load the liquid-glass shader so the very first surface paints
  // real glass on its first frame instead of flashing the blur+tint
  // fallback. Fire-and-forget: shader is needed before any glass paints,
  // and Impeller will load it well before the first user interaction.
  LiqGlassSurface.precacheShader();
  runApp(
    const ProviderScope(
      child: LiquidUIKitApp(),
    ),
  );
}

class LiquidUIKitApp extends ConsumerWidget {
  const LiquidUIKitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liquidTheme = ref.watch(liquidThemeProvider);
    final locale = ref.watch(localeProvider);

    return WidgetsApp(
      title: 'Flutter Liquid UI Kit',
      debugShowCheckedModeBanner: false,
      color: const Color(0xFF0088FF),
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (c, _, _) => builder(c),
      ),
      home: const HomeScreen(),
      builder: (context, child) {
        // Apply RTL + LiqTheme + ColoredBox background at the app root.
        final activeLocale = Localizations.localeOf(context);
        final isRTL = _rtlLanguageCodes.contains(activeLocale.languageCode);
        return LiqTheme(
          data: liquidTheme.brightness == Brightness.dark
              ? LiqThemeData.dark
              : LiqThemeData.light,
          child: Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
