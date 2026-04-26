import { test, expect } from '@playwright/test';

// Sanity test: the showcase serves a page and the readiness flag flips
// to `true` before the timeout. Per-component fidelity specs land in
// the per-batch plans.
test('showcase loads and signals readiness', async ({ page }) => {
  await page.goto('/');
  await page.waitForFunction(() => window.liqShowcaseReady === true, null, {
    timeout: 10_000,
  });
  expect(await page.evaluate(() => window.liqShowcaseReady)).toBe(true);
});

declare global {
  interface Window {
    liqShowcaseReady: boolean;
  }
}
