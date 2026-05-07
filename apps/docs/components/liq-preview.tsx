'use client';

import { useEffect, useRef, useState } from 'react';
import { useTheme } from 'next-themes';
import { SNIPPET_ROUTES, type SnippetRouteKey } from '@/lib/snippet-routes';

const PREVIEW_INITIAL_HEIGHTS: Partial<Record<SnippetRouteKey, number>> = {
  'card/default': 180,
  'card/with-header': 220,
  'card/with-footer': 260,
  'colors/swatch-grid': 1180,
  'calendar/default': 380,
  'calendar/with-bounds': 380,
  'date-picker-field/default': 560,
  'date-picker-field/preselected': 560,
  'materials/light': 540,
  'materials/dark': 540,
  'picker/inline-calendar': 380,
  'time-picker/12-hour': 300,
  'time-picker/24-hour': 300,
  'time-picker/intervals': 300,
  'tree-view/files': 360,
  'tree-view/outline': 420,
  'badge/counter': 88,
  'badge/status': 88,
  'badge/dot': 88,
  'command-palette/default': 360,
  'command-palette/sections': 420,
  'data-table/default': 320,
  'data-table/sortable': 320,
  'glass-surface/floating': 240,
  'glass-surface/flat': 240,
  'glass-surface/dark': 240,
  'hover-card/default': 440,
  'hover-card/bottom': 440,
  'kit-helpers/header': 220,
  'kit-helpers/mode-pill': 96,
  'kit-helpers/mode-labels': 150,
  'motion/default': 340,
  'text-styles/dynamic': 520,
  'text-styles/accessibility': 700,
  'kanban/default': 360,
  'kanban/dense': 360,
  'sidebar/default': 380,
  'sidebar/with-search': 380,
  'keyboard/qwerty': 320,
  'keyboard/numbers': 260,
  'menu/default': 220,
  'menu/with-section': 220,
  'rich-editor/default': 320,
  'rich-editor/empty': 260,
  'sheet/full-screen': 520,
  'sheet/stacked': 420,
  'sheet/inspector': 340,
  'dialog/default': 280,
  'dialog/with-actions': 300,
  'alert/stacked': 300,
  'alert/side-by-side': 300,
  'alert/destructive': 300,
  'drawer/left': 320,
  'drawer/right': 320,
  'drawer/collapsed': 320,
  'window/default': 360,
  'window/inactive-controls': 360,
  'widget/large': 360,
  'widget/extra-large': 430,
  'color-picker/large': 112,
  'color-picker/small': 112,
  'color-picker/grid': 360,
  'combobox/default': 96,
  'combobox/preselected': 96,
  'scroll-area/vertical': 300,
  'scroll-area/horizontal': 220,
  'carousel/default': 280,
  'carousel/autoplay': 280,
  'carousel/no-indicator': 260,
  'collapsible/default': 120,
  'collapsible/expanded': 220,
  'tooltip/top': 320,
  'tooltip/bottom': 320,
  'tooltip/with-arrow': 320,
};

export interface LiqPreviewProps {
  component: string;
  variant: string;
  /** Override for tests; otherwise read from NEXT_PUBLIC_SNIPPETS_URL. */
  snippetsBaseUrl?: string;
  /** Initial iframe height before the snippets app reports its layout. */
  initialHeight?: number;
}

export function LiqPreview({
  component,
  variant,
  snippetsBaseUrl,
  initialHeight = 120,
}: LiqPreviewProps) {
  const key = `${component}/${variant}` as SnippetRouteKey;
  if (!(key in SNIPPET_ROUTES)) {
    throw new Error(
      `LiqPreview: unknown snippet route "${key}". Add it to tooling/gen/snippet_manifest.json and re-run melos run docs:gen:routes.`,
    );
  }
  const route = SNIPPET_ROUTES[key];
  const resolvedInitialHeight = PREVIEW_INITIAL_HEIGHTS[key] ?? initialHeight;
  const baseUrl =
    snippetsBaseUrl ?? process.env.NEXT_PUBLIC_SNIPPETS_URL ?? '';
  const normalizedBaseUrl = baseUrl.replace(/\/$/, '');
  const { resolvedTheme } = useTheme();
  const [mounted, setMounted] = useState(false);
  const cacheKey = process.env.NEXT_PUBLIC_SNIPPETS_CACHE_KEY ?? '1';
  const theme = mounted && resolvedTheme === 'light' ? 'light' : 'dark';
  // Hash-based routing: the snippets Flutter app reads
  // `window.location.hash` to pick the route. This keeps it working
  // against ANY static origin (Cloudflare Pages, `serve -s`, plain
  // Python http.server) without depending on SPA-fallback rewrites.
  // The `?theme=` query is placed BEFORE the `#` so it's available
  // via window.location.search, not buried inside the fragment.
  const src = `${normalizedBaseUrl}/index.html?theme=${theme}&v=${encodeURIComponent(cacheKey)}#${route.path}`;
  const [height, setHeight] = useState(resolvedInitialHeight);
  const iframeRef = useRef<HTMLIFrameElement>(null);

  useEffect(() => {
    setMounted(true);
  }, []);

  useEffect(() => {
    setHeight(resolvedInitialHeight);
    if (iframeRef.current) {
      iframeRef.current.height = String(resolvedInitialHeight);
    }
  }, [resolvedInitialHeight, src]);

  useEffect(() => {
    function onMessage(e: MessageEvent) {
        const expectedOrigin =
        normalizedBaseUrl.length > 0
          ? new URL(normalizedBaseUrl, window.location.href).origin
          : window.location.origin;
      if (e.origin !== expectedOrigin) return;
      const data = e.data as { type?: string; px?: number };
      if (data?.type === 'liq.height' && typeof data.px === 'number') {
        const newHeight = Math.max(
          resolvedInitialHeight,
          Math.min(4000, data.px),
        );
        setHeight(newHeight);
        if (iframeRef.current) {
          iframeRef.current.height = String(newHeight);
        }
      }
    }
    window.addEventListener('message', onMessage);
    return () => window.removeEventListener('message', onMessage);
  }, [normalizedBaseUrl, resolvedInitialHeight]);

  return (
    <iframe
      key={src}
      ref={iframeRef}
      src={src}
      title={`liqkit_ui — ${component}/${variant}`}
      width="100%"
      height={height}
      loading="eager"
      allow="cross-origin-isolated"
      sandbox="allow-scripts allow-same-origin"
      style={{
        background: theme === 'dark' ? '#000' : '#fff',
        border: '1px solid var(--color-fd-border)',
        borderRadius: 12,
        transition: 'height 220ms ease-out',
      }}
    />
  );
}
