// GENERATED FILE — DO NOT EDIT BY HAND.
// Source: tooling/gen/snippet_manifest.json
// Regenerate: melos run docs:gen:routes

export interface SnippetRoute {
  readonly component: string;
  readonly variant: string;
  readonly displayName: string;
  readonly path: string;
}

export const SNIPPET_ROUTES = {
  'button/destructive': { component: 'button', variant: 'destructive', displayName: "Destructive", path: '/button/destructive' },
  'button/glass': { component: 'button', variant: 'glass', displayName: "Glass", path: '/button/glass' },
  'button/regular': { component: 'button', variant: 'regular', displayName: "Regular", path: '/button/regular' },
  'color-picker/grid': { component: 'color-picker', variant: 'grid', displayName: "Grid", path: '/color-picker/grid' },
  'color-picker/large': { component: 'color-picker', variant: 'large', displayName: "Large", path: '/color-picker/large' },
  'color-picker/small': { component: 'color-picker', variant: 'small', displayName: "Small", path: '/color-picker/small' },
  'colors/swatch-grid': { component: 'colors', variant: 'swatch-grid', displayName: "Swatch grid", path: '/colors/swatch-grid' },
  'materials/dark': { component: 'materials', variant: 'dark', displayName: "Dark", path: '/materials/dark' },
  'materials/light': { component: 'materials', variant: 'light', displayName: "Light", path: '/materials/light' },
  'page-controls/dark': { component: 'page-controls', variant: 'dark', displayName: "Dark", path: '/page-controls/dark' },
  'page-controls/light': { component: 'page-controls', variant: 'light', displayName: "Light", path: '/page-controls/light' },
  'picker/inline-calendar': { component: 'picker', variant: 'inline-calendar', displayName: "Inline Calendar", path: '/picker/inline-calendar' },
  'segmented/four': { component: 'segmented', variant: 'four', displayName: "Four Segments", path: '/segmented/four' },
  'segmented/three': { component: 'segmented', variant: 'three', displayName: "Three Segments", path: '/segmented/three' },
  'segmented/two': { component: 'segmented', variant: 'two', displayName: "Two Segments", path: '/segmented/two' },
  'slider/dark': { component: 'slider', variant: 'dark', displayName: "Dark", path: '/slider/dark' },
  'slider/default': { component: 'slider', variant: 'default', displayName: "Default", path: '/slider/default' },
  'stepper/default': { component: 'stepper', variant: 'default', displayName: "Default", path: '/stepper/default' },
  'stepper/disabled': { component: 'stepper', variant: 'disabled', displayName: "Disabled", path: '/stepper/disabled' },
  'text-field/disabled': { component: 'text-field', variant: 'disabled', displayName: "Disabled", path: '/text-field/disabled' },
  'text-field/empty': { component: 'text-field', variant: 'empty', displayName: "Empty", path: '/text-field/empty' },
  'text-field/filled': { component: 'text-field', variant: 'filled', displayName: "Filled", path: '/text-field/filled' },
  'text-field/obscured': { component: 'text-field', variant: 'obscured', displayName: "Obscured", path: '/text-field/obscured' },
  'text-styles/accessibility': { component: 'text-styles', variant: 'accessibility', displayName: "Accessibility sizes", path: '/text-styles/accessibility' },
  'text-styles/dynamic': { component: 'text-styles', variant: 'dynamic', displayName: "Dynamic Type", path: '/text-styles/dynamic' },
  'toggle/disabled': { component: 'toggle', variant: 'disabled', displayName: "Disabled", path: '/toggle/disabled' },
  'toggle/off': { component: 'toggle', variant: 'off', displayName: "Off", path: '/toggle/off' },
  'toggle/on': { component: 'toggle', variant: 'on', displayName: "On", path: '/toggle/on' },
} as const satisfies Record<string, SnippetRoute>;

export type SnippetRouteKey = keyof typeof SNIPPET_ROUTES;
