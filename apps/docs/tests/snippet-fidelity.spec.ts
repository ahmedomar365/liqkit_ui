import { test, expect } from '@playwright/test';

// Per-component pixel-golden fidelity tests.
//
// The other e2e suites (phase4-audit, phase4-audit-dark, a11y) verify
// the docs site chrome — page renders, iframes load, no console
// errors, no accessibility violations. They do NOT verify the actual
// Flutter rendering INSIDE the iframes.
//
// This suite navigates directly to the snippets origin
// (http://localhost:4174 by default), waits for Flutter to bootstrap,
// and asserts each snippet route renders to a pixel-stable
// screenshot. Goldens live at tests/snippet-goldens/<slug>.png and
// are regenerated with `pnpm exec playwright test
// tests/snippet-fidelity.spec.ts --update-snapshots`.

const SNIPPETS_BASE = process.env.NEXT_PUBLIC_SNIPPETS_URL ?? 'http://localhost:4174';

// One representative snippet per component — chosen to be the most
// visually-stable variant (no animations, no system-time
// dependencies, no random colors).
const SNIPPETS: Array<{ slug: string; viewport: { width: number; height: number } }> = [
  // Phase 4A
  { slug: 'accordion/single',     viewport: { width: 480, height: 320 } },
  { slug: 'avatar/initials',      viewport: { width: 320, height: 120 } },
  { slug: 'badge/status',         viewport: { width: 480, height: 80  } },
  { slug: 'card/with-header',     viewport: { width: 480, height: 220 } },
  { slug: 'checkbox/checked',     viewport: { width: 200, height: 80  } },
  { slug: 'radio/group',          viewport: { width: 360, height: 220 } },
  { slug: 'divider/with-label',   viewport: { width: 360, height: 80  } },
  { slug: 'skeleton/text',        viewport: { width: 360, height: 200 } },
  { slug: 'tabs/pill',            viewport: { width: 480, height: 100 } },
  { slug: 'toast/success',        viewport: { width: 480, height: 80  } },
  { slug: 'breadcrumb/default',   viewport: { width: 480, height: 80  } },
  { slug: 'pagination/default',   viewport: { width: 480, height: 100 } },
  // Phase 4B
  { slug: 'calendar/default',     viewport: { width: 360, height: 360 } },
  { slug: 'otp/four-digit',       viewport: { width: 480, height: 120 } },
  { slug: 'number-field/default', viewport: { width: 360, height: 100 } },
  { slug: 'chip/single',          viewport: { width: 360, height: 80  } },
  // Phase 4C
  { slug: 'data-table/default',   viewport: { width: 540, height: 240 } },
  // Phase 5
  { slug: 'tree-view/files',      viewport: { width: 360, height: 320 } },
  { slug: 'line-chart/default',   viewport: { width: 540, height: 220 } },
  { slug: 'bar-chart/default',    viewport: { width: 540, height: 240 } },
  // Phase 6
  { slug: 'collapsible/expanded', viewport: { width: 400, height: 200 } },
  { slug: 'toggle-group/labels',  viewport: { width: 400, height: 80  } },
  { slug: 'bottom-nav/four-tabs', viewport: { width: 400, height: 120 } },
  { slug: 'time-field/twenty-four-hour', viewport: { width: 280, height: 100 } },
];

for (const s of SNIPPETS) {
  test(`fidelity: ${s.slug}`, async ({ page }) => {
    await page.setViewportSize(s.viewport);
    await page.goto(`${SNIPPETS_BASE}/?theme=light#/${s.slug}`);

    // Wait for Flutter Web to finish bootstrapping. Flutter inserts a
    // <flutter-view> custom element once the engine is ready; the
    // first paint then takes another frame or two. We wait for the
    // selector AND a short settle interval.
    await page.waitForSelector('flutter-view, flt-glass-pane', {
      timeout: 10_000,
    });
    await page.waitForTimeout(800);

    // Mask cursors / blinking carets — they're animated and would
    // produce noisy diffs.
    await expect(page).toHaveScreenshot(`${s.slug.replace('/', '__')}.png`, {
      maxDiffPixelRatio: 0.02,
      animations: 'disabled',
    });
  });
}
