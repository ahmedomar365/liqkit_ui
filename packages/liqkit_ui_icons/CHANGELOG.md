## 0.4.0

Bumps the `liqkit_ui` peer dep constraint from `^0.3.0` to `^0.4.0` so
this package keeps resolving against the matching liqkit_ui release.
No icon-surface changes in this version.

## 0.3.0

Bumps the `liqkit_ui` peer dep constraint from `^0.2.0` to `^0.3.0` so
this package keeps resolving against the matching liqkit_ui release.
No icon-surface changes in this version.

## 0.2.0

Adds `LiqMaterialIcons` — a 315-icon verbose-name surface mapping
every Material `Icons.X` identifier used by the showcase to the
closest Lucide equivalent. Drop-in replacement: rename
`Icons.account_circle` → `LiqMaterialIcons.accountCircle` and
remove the `package:flutter/material.dart` import.

The curated short-name surface on `LiqIcons` is unchanged.

Bumps the `liqkit_ui` peer dep to `^0.2.0`.

## 0.0.1

- Initial release. Curated `LiqIcons` namespace backed by Lucide.
- ~70 aliased icons covering common iOS-26 app surfaces (top bars,
  menus, list rows, empty states, badges, status). Full Lucide
  surface accessible via the underlying `LucideIcons.X` names.
