import { test, expect } from '@playwright/test';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

// Drives the showcase's `/buttons/catalog` route and screenshots the
// rendered Flutter button matrix (5 styles × 3 sizes × destructive ×
// enabled). The capture lands in
// __baselines__/<viewport>/buttons-flutter-catalog.png so a follow-up
// SSIM step can diff it against liqkit's rendered/buttons.html
// baseline.

const here = dirname(fileURLToPath(import.meta.url));
const baseUrl = process.env.SHOWCASE_URL ?? 'http://localhost:4173';

test.describe('liqkit_ui Buttons route', () => {
  test('catalog renders without console errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('pageerror', (e) => errors.push(`pageerror: ${e.message}`));
    page.on('console', (msg) => {
      if (msg.type() === 'error') errors.push(`console: ${msg.text()}`);
    });

    await page.goto(`${baseUrl}/#/buttons/catalog`);
    await page.waitForFunction(() => window.liqShowcaseReady === true, null, {
      timeout: 15_000,
    });

    await page.screenshot({
      path: resolve(
        here,
        '..',
        '__baselines__',
        test.info().project.name,
        'buttons-flutter-catalog.png',
      ),
      fullPage: true,
    });

    expect(errors, errors.join('; ')).toEqual([]);
  });
});

declare global {
  interface Window {
    liqShowcaseReady: boolean;
  }
}
