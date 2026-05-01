import { DocsLayout } from 'fumadocs-ui/layouts/docs';
import { source } from '@/lib/source';
import { baseOptions } from '@/lib/layout.shared';
import type { ReactNode } from 'react';

// Wrap the Fumadocs `DocsLayout` in a `<main>` landmark so axe-core
// and screen readers can find the page's primary content. Fumadocs'
// own markup uses `<article id="nd-page">` for the article — we
// promote the surrounding container to a single `<main>` here so the
// page passes WCAG's "landmark-one-main" + "region" rules out of
// the box. `className="contents"` keeps `<main>` invisible to layout
// (its children inherit the original CSS grid placement).
export default function Layout({ children }: { children: ReactNode }) {
  return (
    <main className="contents">
      <DocsLayout tree={source.pageTree} {...baseOptions}>
        {children}
      </DocsLayout>
    </main>
  );
}
