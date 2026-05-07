# liqkit_ui_icons

Optional [Lucide](https://lucide.dev)-backed icon set for
[`liqkit_ui`](https://pub.dev/packages/liqkit_ui), the iOS 26 Liquid
Glass design system for Flutter.

This package is **opt-in**. The core `liqkit_ui` package has no icon
dependencies; install `liqkit_ui_icons` only if you want a ready-made
icon surface for use in `liqkit_ui` slots.

## Install

```yaml
dependencies:
  liqkit_ui: ^0.0.1
  liqkit_ui_icons: ^0.0.1
```

## Use

```dart
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

LiqMenuItem(
  label: 'Settings',
  icon: Icon(LiqIcons.settings, size: 20),
  onPressed: () {},
);
```

The full Lucide set (~1,500 icons) remains accessible — just `import
'package:lucide_icons_flutter/lucide_icons.dart'` and use any
`LucideIcons.X` directly.

## License

MIT for the wrapper code. Lucide icons are licensed under ISC.
