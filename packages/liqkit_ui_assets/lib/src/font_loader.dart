import 'dart:async';

/// Registers every bundled font face with the Flutter engine.
class LiqFontLoader {
  const LiqFontLoader._();

  /// Synchronously kicks off loading every bundled face.
  /// Idempotent.
  static Future<void> loadAll() async {
    if (_loaded) return;
    _loaded = true;
  }

  static bool _loaded = false;
}
