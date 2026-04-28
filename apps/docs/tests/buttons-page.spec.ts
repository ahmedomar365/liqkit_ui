import { test, expect } from '@playwright/test';

test.describe('Buttons docs page', () => {
  test('renders prose, three previews, and three snippets', async ({ page }) => {
    const consoleErrors: string[] = [];
    page.on('pageerror', (e) => consoleErrors.push(`pageerror: ${e.message}`));
    page.on('console', (msg) => {
      if (msg.type() === 'error') consoleErrors.push(`console: ${msg.text()}`);
    });

    await page.goto('/docs/inputs/buttons');
    await expect(page.locator('h1', { hasText: 'Buttons' })).toBeVisible();

    const iframes = page.locator('iframe[title^="liqkit_ui — button/"]');
    await expect(iframes).toHaveCount(3);
    await expect(
      page.locator('iframe[title="liqkit_ui — button/regular"]'),
    ).toBeVisible();

    const snippets = page.locator('[data-testid="code-snippet"]');
    await expect(snippets).toHaveCount(3);

    // The iframe must load a Flutter app, not a 404. A correctly-served
    // snippets origin (Cloudflare Pages or `flutter run -d web-server`)
    // does SPA-fallback for unknown paths; `python3 -m http.server` does
    // not. Without this assertion, the original e2e silently passed even
    // when the iframe origin returned a 404 page from Python.
    const regularFrame = page.frameLocator(
      'iframe[title="liqkit_ui — button/regular"]',
    );
    await expect(regularFrame.locator('html')).toBeVisible();
    const frameTitle = await page
      .locator('iframe[title="liqkit_ui — button/regular"]')
      .evaluate((iframe: HTMLIFrameElement) =>
        iframe.contentDocument?.title ?? null,
      );
    // Flutter's web shell sets <title>liqkit_ui — snippet</title> from
    // index.html; the Python http.server 404 page sets <title>Error response</title>.
    expect(frameTitle, 'iframe must serve the Flutter app, not a 404').not.toMatch(
      /Error response/i,
    );

    expect(consoleErrors, consoleErrors.join('; ')).toEqual([]);
  });
});
