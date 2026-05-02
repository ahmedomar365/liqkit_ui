# iOS 26 Component Audit Checklist

Source of truth: `packages/liqkit_ui/lib/components.dart`

Status values:

- `Pass`: conforms today.
- `Fix`: needs code changes in `liqkit_ui`.
- `Extension`: not a native iOS primitive, kept for forui/shadcn parity and rendered in iOS 26 visual language.
- `Defer`: intentionally excluded from the migration with a written reason.

| Component | Category | Apple/Figma source | forui/shadcn parity source | iOS 26 visual status | Token usage status | Glass/material status | Motion status | Typography status | Accessibility status | Test/doc status | Showcase status | Action |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
