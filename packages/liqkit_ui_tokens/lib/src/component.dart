// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: packages/liqkit_ui_design_data/manifests/tokens.json
// SHA-256: f0aac47ec577c298f075fcdf93c58da38ee14d0b9a02eb2e1b72c128a8d01f2b
// Translator: tooling/gen/translate_tokens.dart
// Section: component
// ignore_for_file: lines_longer_than_80_chars, public_member_api_docs, prefer_single_quotes

/// Per-component token archive generated from liqkit.
///
/// Values are the raw CSS-variable strings from liqkit's TS source, e.g.
/// `'var(--ui-accent-primary)'` or `'12px'`. Component themes
/// resolve these at build time against the foundation and semantic
/// layers in `package:liqkit_ui/theme.dart`.
class LiqComponentTokens {
  /// Schema version of the component token set.
  static const int schemaVersion = 1;

  /// Per-component CSS-variable maps (kept verbatim).
  static const Map<String, Map<String, String>> raw =
      <String, Map<String, String>>{
    'button': <String, String>{
      '--button-bg': 'var(--ui-accent-primary)',
      '--button-fg': 'var(--ui-bg-surface)',
      '--button-border': 'var(--ui-accent-primary)',
      '--button-radius': '12px',
      '--button-height': '44px',
      '--button-padding-x': '16px',
    },
    'textField': <String, String>{
      '--textfield-bg': 'var(--ui-bg-surface)',
      '--textfield-fg': 'var(--ui-fg-primary)',
      '--textfield-border': 'var(--ui-accent-primary)',
      '--textfield-placeholder': 'var(--ui-fg-primary)',
      '--textfield-radius': '12px',
      '--textfield-height': '44px',
      '--textfield-padding-x': '14px',
      '--textfield-ring': 'var(--ui-accent-primary)',
    },
    'toggle': <String, String>{
      '--toggle-track-bg-off': 'var(--ui-bg-surface)',
      '--toggle-track-bg-on': 'var(--ui-accent-primary)',
      '--toggle-track-border': 'var(--ui-accent-primary)',
      '--toggle-thumb-bg': 'var(--ui-bg-surface)',
      '--toggle-width': '52px',
      '--toggle-height': '32px',
      '--toggle-thumb-size': '26px',
      '--toggle-ring': 'var(--ui-accent-primary)',
    },
    'segmentedControl': <String, String>{
      '--segmented-bg': 'var(--ui-bg-surface)',
      '--segmented-border': 'var(--ui-accent-primary)',
      '--segmented-radius': '12px',
      '--segmented-height': '36px',
      '--segmented-padding': '2px',
      '--segmented-indicator-bg': 'var(--ui-accent-primary)',
      '--segmented-indicator-fg': 'var(--ui-bg-surface)',
      '--segmented-label-fg': 'var(--ui-fg-primary)',
    },
    'slider': <String, String>{
      '--slider-track-bg': 'var(--ui-bg-surface)',
      '--slider-track-fill': 'var(--ui-accent-primary)',
      '--slider-track-border': 'var(--ui-accent-primary)',
      '--slider-thumb-bg': 'var(--ui-bg-surface)',
      '--slider-thumb-border': 'var(--ui-accent-primary)',
      '--slider-height': '4px',
      '--slider-thumb-size': '20px',
    },
    'stepper': <String, String>{
      '--stepper-bg': 'var(--ui-bg-surface)',
      '--stepper-border': 'var(--ui-accent-primary)',
      '--stepper-fg': 'var(--ui-fg-primary)',
      '--stepper-radius': '12px',
      '--stepper-height': '36px',
      '--stepper-padding-x': '10px',
      '--stepper-divider': 'var(--ui-accent-primary)',
    },
    'alert': <String, String>{
      '--alert-bg': 'var(--ui-bg-surface)',
      '--alert-fg': 'var(--ui-fg-primary)',
      '--alert-border': 'var(--ui-accent-primary)',
      '--alert-radius': '14px',
      '--alert-padding': '14px',
      '--alert-title-fg': 'var(--ui-fg-primary)',
      '--alert-message-fg': 'var(--ui-fg-primary)',
    },
    'sheet': <String, String>{
      '--sheet-overlay-bg': 'var(--ui-bg-surface)',
      '--sheet-panel-bg': 'var(--ui-bg-surface)',
      '--sheet-panel-border': 'var(--ui-accent-primary)',
      '--sheet-panel-radius': '18px',
      '--sheet-panel-padding': '16px',
      '--sheet-title-fg': 'var(--ui-fg-primary)',
    },
    'menu': <String, String>{
      '--menu-bg': 'var(--ui-bg-surface)',
      '--menu-border': 'var(--ui-accent-primary)',
      '--menu-radius': '12px',
      '--menu-padding': '6px',
      '--menu-item-fg': 'var(--ui-fg-primary)',
      '--menu-item-hover-bg': 'var(--ui-bg-surface)',
      '--menu-item-radius': '8px',
    },
    'contextMenu': <String, String>{
      '--context-menu-bg': 'var(--ui-bg-surface)',
      '--context-menu-border': 'var(--ui-accent-primary)',
      '--context-menu-radius': '12px',
      '--context-menu-padding': '6px',
      '--context-menu-item-fg': 'var(--ui-fg-primary)',
      '--context-menu-item-hover-bg': 'var(--ui-bg-surface)',
      '--context-menu-item-radius': '8px',
    },
    'progressIndicator': <String, String>{
      '--progress-track-bg': 'var(--ui-bg-surface)',
      '--progress-track-border': 'var(--ui-accent-primary)',
      '--progress-fill-bg': 'var(--ui-accent-primary)',
      '--progress-radius': '999px',
      '--progress-height': '8px',
      '--spinner-size': '18px',
    },
    'notification': <String, String>{
      '--notification-bg': 'var(--ui-bg-surface)',
      '--notification-border': 'var(--ui-accent-primary)',
      '--notification-radius': '14px',
      '--notification-padding': '12px',
      '--notification-title-fg': 'var(--ui-fg-primary)',
      '--notification-message-fg': 'var(--ui-fg-primary)',
      '--notification-shadow-color': 'var(--ui-accent-primary)',
    },
    'actionSheet': <String, String>{
      '--action-sheet-bg': 'var(--ui-bg-surface)',
      '--action-sheet-border': 'var(--ui-accent-primary)',
      '--action-sheet-radius': '16px',
      '--action-sheet-padding': '10px',
      '--action-sheet-item-fg': 'var(--ui-fg-primary)',
      '--action-sheet-item-bg': 'var(--ui-bg-surface)',
      '--action-sheet-item-radius': '12px',
    },
    'popover': <String, String>{
      '--popover-bg': 'var(--ui-bg-surface)',
      '--popover-border': 'var(--ui-accent-primary)',
      '--popover-radius': '14px',
      '--popover-padding': '12px',
      '--popover-title-fg': 'var(--ui-fg-primary)',
      '--popover-body-fg': 'var(--ui-fg-primary)',
      '--popover-shadow-color': 'var(--ui-accent-primary)',
    },
    'topBar': <String, String>{
      '--topbar-bg': 'var(--ui-bg-surface)',
      '--topbar-border': 'var(--ui-accent-primary)',
      '--topbar-radius': '14px',
      '--topbar-height': '52px',
      '--topbar-padding-x': '12px',
      '--topbar-title-fg': 'var(--ui-fg-primary)',
      '--topbar-item-fg': 'var(--ui-accent-primary)',
    },
    'toolbar': <String, String>{
      '--toolbar-bg': 'var(--ui-bg-surface)',
      '--toolbar-border': 'var(--ui-accent-primary)',
      '--toolbar-radius': '14px',
      '--toolbar-height': '48px',
      '--toolbar-padding-x': '10px',
      '--toolbar-item-fg': 'var(--ui-fg-primary)',
      '--toolbar-item-bg': 'var(--ui-bg-surface)',
    },
    'statusBar': <String, String>{
      '--statusbar-bg': 'var(--ui-bg-surface)',
      '--statusbar-border': 'var(--ui-accent-primary)',
      '--statusbar-radius': '12px',
      '--statusbar-height': '28px',
      '--statusbar-padding-x': '10px',
      '--statusbar-text-fg': 'var(--ui-fg-primary)',
    },
    'pageControl': <String, String>{
      '--page-control-bg': 'var(--ui-bg-surface)',
      '--page-control-border': 'var(--ui-accent-primary)',
      '--page-control-radius': '999px',
      '--page-control-dot-size': '8px',
      '--page-control-gap': '8px',
      '--page-control-dot-bg': 'var(--ui-fg-primary)',
      '--page-control-dot-active-bg': 'var(--ui-accent-primary)',
    },
  };
}
