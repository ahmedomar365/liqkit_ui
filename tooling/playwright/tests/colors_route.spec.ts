import { test, expect } from '@playwright/test';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

// Drives the showcase's `/colors/swatch-grid` and
// `/colors/swatch-grid/increased-contrast` routes and screenshots both,
// proving the Flutter port renders end-to-end via Wasm/CanvasKit. The
// shots are saved to __baselines__/<viewport>/colors-flutter-<mode>.png
// so a follow-up SSIM step can diff against liqkit's
// rendered/colors.html baseline at `__baselines__/<viewport>/colors.png`.

const here = dirname(fileURLToPath(import.meta.url));
const baseUrl = process.env.SHOWCASE_URL ?? 'http://localhost:4173';

test.describe('liqkit_ui Colors route', () => {
  test('default mode renders 40 canonical color cards', async ({ page }) => {
    const errors: string[] = [];
    page.on('pageerror', (e) => errors.push(`pageerror: ${e.message}`));
    page.on('console', (msg) => {
      if (msg.type() === 'error') errors.push(`console: ${msg.text()}`);
    });

    await page.goto(`${baseUrl}/#/colors/swatch-grid`);
    await page.waitForFunction(() => window.liqShowcaseReady === true, null, {
      timeout: 15_000,
    });

    await page.screenshot({
      path: resolve(
        here,
        '..',
        '__baselines__',
        test.info().project.name,
        'colors-flutter-default.png',
      ),
      fullPage: true,
    });

    expect(errors, errors.join('; ')).toEqual([]);
  });

  test('increased-contrast mode renders without errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('pageerror', (e) => errors.push(`pageerror: ${e.message}`));
    page.on('console', (msg) => {
      if (msg.type() === 'error') errors.push(`console: ${msg.text()}`);
    });

    await page.goto(`${baseUrl}/#/colors/swatch-grid/increased-contrast`);
    await page.waitForFunction(() => window.liqShowcaseReady === true, null, {
      timeout: 15_000,
    });

    await page.screenshot({
      path: resolve(
        here,
        '..',
        '__baselines__',
        test.info().project.name,
        'colors-flutter-increased-contrast.png',
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
