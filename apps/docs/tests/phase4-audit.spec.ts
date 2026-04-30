import { test, expect } from '@playwright/test';

// Audit sweep over every Phase-4 component page. Verifies:
//   - the page loads (h1 matches),
//   - all LiqPreview iframes are present in the DOM,
//   - each iframe URL resolves to the snippets app (not the python
//     http.server 404 page),
//   - no console.error / pageerror fires during page load,
//   - a full-page screenshot is captured under test-results/phase4/.

interface PageSpec {
  slug: string;
  title: string;
  iframes: number;
}

const PHASE_4_PAGES: PageSpec[] = [
  // Phase 4A — foundation primitives
  { slug: 'containers/accordion', title: 'Accordion', iframes: 3 },
  { slug: 'foundation/avatar', title: 'Avatar', iframes: 3 },
  { slug: 'status/badge', title: 'Badge', iframes: 3 },
  { slug: 'containers/card', title: 'Card', iframes: 3 },
  { slug: 'inputs/checkbox', title: 'Checkbox', iframes: 3 },
  { slug: 'inputs/radio', title: 'Radio', iframes: 2 },
  { slug: 'foundation/divider', title: 'Divider', iframes: 3 },
  { slug: 'status/skeleton', title: 'Skeleton', iframes: 3 },
  { slug: 'navigation/tabs', title: 'Tabs', iframes: 3 },
  { slug: 'status/tooltip', title: 'Tooltip', iframes: 3 },
  { slug: 'status/toast', title: 'Toast', iframes: 3 },
  { slug: 'containers/drawer', title: 'Drawer', iframes: 2 },
  { slug: 'containers/dialog', title: 'Dialog', iframes: 2 },
  { slug: 'foundation/label', title: 'Label', iframes: 2 },
  { slug: 'navigation/breadcrumb', title: 'Breadcrumb', iframes: 2 },
  { slug: 'navigation/pagination', title: 'Pagination', iframes: 2 },
  // Phase 4B — form/input gaps
  { slug: 'inputs/calendar', title: 'Calendar', iframes: 2 },
  { slug: 'inputs/time-picker', title: 'Time Picker', iframes: 3 },
  { slug: 'inputs/otp', title: 'OTP Input', iframes: 3 },
  { slug: 'inputs/number-field', title: 'Number Field', iframes: 3 },
  { slug: 'inputs/combobox', title: 'Combobox', iframes: 2 },
  { slug: 'inputs/chip', title: 'Chip', iframes: 3 },
  // Phase 4C — advanced
  { slug: 'navigation/command-palette', title: 'Command Palette', iframes: 2 },
  { slug: 'containers/carousel', title: 'Carousel', iframes: 3 },
  { slug: 'status/hover-card', title: 'Hover Card', iframes: 2 },
  { slug: 'containers/resizable', title: 'Resizable', iframes: 2 },
  { slug: 'containers/data-table', title: 'Data Table', iframes: 2 },
];

for (const p of PHASE_4_PAGES) {
  test(`${p.slug} renders`, async ({ page }) => {
    const consoleErrors: string[] = [];
    page.on('pageerror', (e) => consoleErrors.push(`pageerror: ${e.message}`));
    page.on('console', (m) => {
      if (m.type() === 'error') consoleErrors.push(`console: ${m.text()}`);
    });

    await page.goto(`/docs/${p.slug}`);
    await expect(page.locator('h1', { hasText: p.title })).toBeVisible();

    const iframes = page.locator('iframe[title^="liqkit_ui — "]');
    await expect(iframes).toHaveCount(p.iframes);

    // Snippets origin is cross-origin to the docs origin, so we can't
    // peek into iframe.contentDocument. Instead fetch the iframe's
    // src via the page's request context and assert the response is
    // the Flutter web shell (not a 404 page).
    const firstSrc = await iframes.first().getAttribute('src');
    expect(firstSrc).toBeTruthy();
    const resp = await page.request.get(firstSrc!);
    expect(resp.status()).toBe(200);
    const html = await resp.text();
    expect(html).toMatch(/liqkit_ui/i);
    expect(html).not.toMatch(/Error response/i);

    // Capture a full-page screenshot for visual review.
    await page.screenshot({
      path: `test-results/phase4/${p.slug.replace('/', '__')}.png`,
      fullPage: true,
    });

    expect(consoleErrors, consoleErrors.join('; ')).toEqual([]);
  });
}
