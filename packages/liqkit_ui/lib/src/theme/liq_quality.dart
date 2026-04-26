/// Glass-rendering quality tier.
enum LiqQuality {
  /// Full BackdropFilter + vibrancy + tint + bezel.
  standard,

  /// Lower sigma; vibrancy dropped. Default on Android Impeller.
  reduced,

  /// Opaque fallback (LiqMaterial.solid).
  minimal,
}
