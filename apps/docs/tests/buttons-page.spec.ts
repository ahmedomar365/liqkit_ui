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

    // The iframe must load a Flutter app, not a 404. We can't read the
    // iframe's contentDocument because the snippets origin
    // (NEXT_PUBLIC_SNIPPETS_URL) is a different port than the docs
    // origin, which counts as cross-origin. Instead, fetch the iframe
    // URL directly via the page's request context and assert the
    // response body contains Flutter's web-shell title and not the
    // python http.server 404 page.
    const iframeSrc = await page
      .locator('iframe[title="liqkit_ui — button/regular"]')
      .getAttribute('src');
    expect(iframeSrc).toBeTruthy();
    const iframeResp = await page.request.get(iframeSrc!);
    expect(iframeResp.status()).toBe(200);
    const iframeHtml = await iframeResp.text();
    expect(iframeHtml).toMatch(/liqkit_ui/i);
    expect(iframeHtml).not.toMatch(/Error response/i);

    expect(consoleErrors, consoleErrors.join('; ')).toEqual([]);
  });
});
