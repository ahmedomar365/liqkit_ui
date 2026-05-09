import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';

/// App settings state
class AppSettings {
  final Locale locale;
  final bool enableHaptics;
  final bool enableAnimations;
  final bool enableBlurEffects;
  final double animationSpeed;
  
  const AppSettings({
    this.locale = const Locale('en', 'US'),
    this.enableHaptics = true,
    this.enableAnimations = true,
    this.enableBlurEffects = true,
    this.animationSpeed = 1.0,
  });
  
  AppSettings copyWith({
    Locale? locale,
    bool? enableHaptics,
    bool? enableAnimations,
    bool? enableBlurEffects,
    double? animationSpeed,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      enableHaptics: enableHaptics ?? this.enableHaptics,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableBlurEffects: enableBlurEffects ?? this.enableBlurEffects,
      animationSpeed: animationSpeed ?? this.animationSpeed,
    );
  }
}

/// App settings provider
final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings());
  
  void setLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      state = state.copyWith(locale: locale);
    }
  }
  
  void toggleHaptics() {
    state = state.copyWith(enableHaptics: !state.enableHaptics);
  }
  
  void toggleAnimations() {
    state = state.copyWith(enableAnimations: !state.enableAnimations);
  }
  
  void toggleBlurEffects() {
    state = state.copyWith(enableBlurEffects: !state.enableBlurEffects);
  }
  
  void setAnimationSpeed(double speed) {
    state = state.copyWith(animationSpeed: speed.clamp(0.5, 2.0));
  }
}

/// Convenience providers
final localeProvider = Provider<Locale>((ref) {
  return ref.watch(appSettingsProvider).locale;
});

final enableHapticsProvider = Provider<bool>((ref) {
  return ref.watch(appSettingsProvider).enableHaptics;
});

final enableAnimationsProvider = Provider<bool>((ref) {
  return ref.watch(appSettingsProvider).enableAnimations;
});

final enableBlurProvider = Provider<bool>((ref) {
  return ref.watch(appSettingsProvider).enableBlurEffects;
});

final animationSpeedProvider = Provider<double>((ref) {
  return ref.watch(appSettingsProvider).animationSpeed;
});

/// Language display information
class LanguageInfo {
  final Locale locale;
  final String name;
  final String nativeName;
  final String flag;
  
  const LanguageInfo({
    required this.locale,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

/// Available languages with display information
const List<LanguageInfo> availableLanguages = [
  LanguageInfo(
    locale: Locale('en', 'US'),
    name: 'English',
    nativeName: 'English',
    flag: 'EN',
  ),
  LanguageInfo(
    locale: Locale('ar', 'SA'),
    name: 'Arabic',
    nativeName: 'العربية',
    flag: 'AR',
  ),
  LanguageInfo(
    locale: Locale('de', 'DE'),
    name: 'German',
    nativeName: 'Deutsch',
    flag: 'DE',
  ),
  LanguageInfo(
    locale: Locale('es', 'ES'),
    name: 'Spanish',
    nativeName: 'Español',
    flag: 'ES',
  ),
  LanguageInfo(
    locale: Locale('fr', 'FR'),
    name: 'French',
    nativeName: 'Français',
    flag: 'FR',
  ),
  LanguageInfo(
    locale: Locale('nl', 'NL'),
    name: 'Dutch',
    nativeName: 'Nederlands',
    flag: 'NL',
  ),
  LanguageInfo(
    locale: Locale('pt', 'BR'),
    name: 'Portuguese',
    nativeName: 'Português',
    flag: 'BR',
  ),
];

/// Get language info for a locale
LanguageInfo getLanguageInfo(Locale locale) {
  return availableLanguages.firstWhere(
    (lang) => lang.locale == locale,
    orElse: () => availableLanguages.first,
  );
}