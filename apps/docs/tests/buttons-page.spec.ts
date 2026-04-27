import { test, expect } from '@playwright/test';

test.describe('Buttons docs page', () => {
  test('renders prose, three previews, and three snippets', async ({ page }) => {
    await page.goto('/docs/inputs/buttons');
    await expect(page.locator('h1', { hasText: 'Buttons' })).toBeVisible();

    const iframes = page.locator('iframe[title^="liqkit_ui — button/"]');
    await expect(iframes).toHaveCount(3);
    await expect(
      page.locator('iframe[title="liqkit_ui — button/regular"]'),
    ).toBeVisible();

    const snippets = page.locator('[data-testid="code-snippet"]');
    await expect(snippets).toHaveCount(3);
  });
});
