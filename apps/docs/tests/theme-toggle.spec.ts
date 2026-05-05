import { expect, test } from '@playwright/test';

test('docs theme toggle is light/dark only on first load', async ({ page }) => {
  await page.goto('/docs');

  await expect(
    page.locator(
      'button[aria-label="Switch to light"], button[aria-label="Switch to dark"]',
    ).first(),
  ).toBeVisible();

  await expect(page.locator('button[aria-label="Toggle Theme"]')).toHaveCount(0);
  await expect(page.locator('button[aria-label="System"]')).toHaveCount(0);
  await expect(page.locator('button[aria-label="system"]')).toHaveCount(0);
});
