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
  'colors/swatch-grid': { component: 'colors', variant: 'swatch-grid', displayName: "Swatch grid", path: '/colors/swatch-grid' },
  'materials/dark': { component: 'materials', variant: 'dark', displayName: "Dark", path: '/materials/dark' },
  'materials/light': { component: 'materials', variant: 'light', displayName: "Light", path: '/materials/light' },
  'text-styles/accessibility': { component: 'text-styles', variant: 'accessibility', displayName: "Accessibility sizes", path: '/text-styles/accessibility' },
  'text-styles/dynamic': { component: 'text-styles', variant: 'dynamic', displayName: "Dynamic Type", path: '/text-styles/dynamic' },
} as const satisfies Record<string, SnippetRoute>;

export type SnippetRouteKey = keyof typeof SNIPPET_ROUTES;
