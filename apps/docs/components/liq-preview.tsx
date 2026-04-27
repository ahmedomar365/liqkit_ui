'use client';

import { useEffect, useRef, useState } from 'react';
import { useTheme } from 'next-themes';
import { SNIPPET_ROUTES, type SnippetRouteKey } from '@/lib/snippet-routes';

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
  initialHeight = 200,
}: LiqPreviewProps) {
  const key = `${component}/${variant}` as SnippetRouteKey;
  if (!(key in SNIPPET_ROUTES)) {
    throw new Error(
      `LiqPreview: unknown snippet route "${key}". Add it to tooling/gen/snippet_manifest.json and re-run melos run docs:gen:routes.`,
    );
  }
  const route = SNIPPET_ROUTES[key];
  const baseUrl =
    snippetsBaseUrl ?? process.env.NEXT_PUBLIC_SNIPPETS_URL ?? '';
  const { resolvedTheme } = useTheme();
  const theme = resolvedTheme === 'dark' ? 'dark' : 'light';
  const src = `${baseUrl}${route.path}?theme=${theme}`;
  const [height, setHeight] = useState(initialHeight);
  const iframeRef = useRef<HTMLIFrameElement>(null);

  useEffect(() => {
    function onMessage(e: MessageEvent) {
      if (e.origin !== baseUrl) return;
      const data = e.data as { type?: string; px?: number };
      if (data?.type === 'liq.height' && typeof data.px === 'number') {
        const newHeight = Math.max(48, Math.min(2000, data.px));
        setHeight(newHeight);
        if (iframeRef.current) {
          iframeRef.current.height = String(newHeight);
        }
      }
    }
    window.addEventListener('message', onMessage);
    return () => window.removeEventListener('message', onMessage);
  }, [baseUrl]);

  return (
    <iframe
      ref={iframeRef}
      src={src}
      title={`liqkit_ui — ${component}/${variant}`}
      width="100%"
      height={height}
      loading="lazy"
      sandbox="allow-scripts allow-same-origin"
      style={{ border: '1px solid var(--color-fd-border)', borderRadius: 12 }}
    />
  );
}
