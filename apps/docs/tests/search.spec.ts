import { test, expect } from '@playwright/test';

// Smoke tests for the Fumadocs ⌘K search dialog.
//
// Search is wired in two places:
//   1. apps/docs/app/api/search/route.ts — Orama-backed server endpoint
//      built from the Fumadocs MDX source.
//   2. fumadocs-ui's RootProvider, which mounts the dialog and binds
//      ⌘K / Ctrl+K globally.

test.describe('Search', () => {
  test('Cmd+K opens the search dialog', async ({ page }) => {
    await page.goto('/docs/inputs/buttons');
    // Focus the page so the keystroke isn't swallowed by the URL bar.
    await page.locator('h1').click();
    const isMac = process.platform === 'darwin';
    await page.keyboard.press(isMac ? 'Meta+k' : 'Control+k');

    const searchBox = page.getByPlaceholder(/search/i).first();
    await expect(searchBox).toBeVisible({ timeout: 4000 });

    await searchBox.fill('carousel');
    // Result row links to /docs/containers/carousel — wait for it.
    const result = page.locator('a[href="/docs/containers/carousel"]').first();
    await expect(result).toBeVisible({ timeout: 4000 });
  });

  test('search API returns Phase-4 component pages', async ({ request }) => {
    const queries = [
      { q: 'accordion',    slug: '/docs/containers/accordion' },
      { q: 'carousel',     slug: '/docs/containers/carousel' },
      { q: 'command palette', slug: '/docs/navigation/command-palette' },
      { q: 'skeleton',     slug: '/docs/status/skeleton' },
      { q: 'pagination',   slug: '/docs/navigation/pagination' },
      { q: 'LiqDataTable', slug: '/docs/containers/data-table' },
    ];
    for (const { q, slug } of queries) {
      const resp = await request.get(`/api/search?query=${encodeURIComponent(q)}`);
      expect(resp.status(), `${q}: HTTP status`).toBe(200);
      const results = (await resp.json()) as Array<{ url: string }>;
      expect(results.length, `${q}: at least one result`).toBeGreaterThan(0);
      const matches = results.filter((r) => r.url.startsWith(slug));
      expect(matches.length, `${q}: result pointing to ${slug}`).toBeGreaterThan(0);
    }
  });
});
