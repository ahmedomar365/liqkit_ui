import { test, expect } from '@playwright/test';
import { readFileSync, existsSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

// Drives each of liqkit's 37 rendered HTML pages and screenshots them.
// This proves the imported archive is intact and renderable end-to-end,
// independent of our Flutter port. Per-component fidelity tests
// (Flutter showcase vs. these baselines) land later.

const here = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(here, '..', '..', '..');
const auditPath = resolve(
  repoRoot,
  'packages/liqkit_ui_design_data/manifests/audit.json',
);

if (!existsSync(auditPath)) {
  throw new Error(
    `audit.json missing at ${auditPath}. Run \`dart run tooling/scripts/audit_design_data.dart\`.`,
  );
}

interface AuditCategory {
  slug: string;
  display: string;
  renderedHtml: boolean;
}
interface AuditFile {
  categories: AuditCategory[];
}
const audit = JSON.parse(readFileSync(auditPath, 'utf8')) as AuditFile;

const baseUrl = process.env.BASELINE_URL ?? 'http://localhost:4174';

test.describe('liqkit baseline rendering', () => {
  for (const c of audit.categories) {
    test(`${c.slug} renders without console errors`, async ({ page }) => {
      const errors: string[] = [];
      page.on('pageerror', (e) => errors.push(`pageerror: ${e.message}`));
      page.on('console', (msg) => {
        if (msg.type() === 'error') errors.push(`console: ${msg.text()}`);
      });

      const response = await page.goto(`${baseUrl}/${c.slug}.html`, {
        waitUntil: 'networkidle',
      });
      expect(response, `no response for ${c.slug}.html`).not.toBeNull();
      expect(
        response!.status(),
        `${c.slug}.html returned ${response!.status()}`,
      ).toBeLessThan(400);

      // Wait for fonts and any images to settle.
      await page.evaluate(() => document.fonts?.ready);
      await page.waitForTimeout(150);

      // Capture the screenshot under tooling/playwright/__baselines__/<viewport>/<slug>.png.
      // playwright.config.ts gives us iPhone (393x852@3) and iPad/desktop
      // (1024x768@2) viewports as separate projects; the project name
      // is on test.info.
      await page.screenshot({
        path: resolve(
          here,
          '..',
          '__baselines__',
          test.info().project.name,
          `${c.slug}.png`,
        ),
        fullPage: true,
      });

      expect(
        errors,
        `console errors while rendering ${c.slug}: ${errors.join('; ')}`,
      ).toEqual([]);
    });
  }
});
