import { test, expect } from '@playwright/test';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const baseUrl = process.env.SHOWCASE_URL ?? 'http://localhost:4173';

test.describe('liqkit_ui Page Controls route', () => {
  test('catalog renders without console errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('pageerror', (e) => errors.push(`pageerror: ${e.message}`));
    page.on('console', (msg) => {
      if (msg.type() === 'error') errors.push(`console: ${msg.text()}`);
    });

    await page.goto(`${baseUrl}/#/page-controls/catalog`);
    await page.waitForFunction(() => window.liqShowcaseReady === true, null, {
      timeout: 15_000,
    });

    await page.screenshot({
      path: resolve(
        here,
        '..',
        '__baselines__',
        test.info().project.name,
        'page-controls-flutter-catalog.png',
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
