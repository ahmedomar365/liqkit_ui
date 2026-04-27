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
} as const satisfies Record<string, SnippetRoute>;

export type SnippetRouteKey = keyof typeof SNIPPET_ROUTES;
