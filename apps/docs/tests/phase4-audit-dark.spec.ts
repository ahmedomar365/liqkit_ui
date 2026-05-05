import { test, expect, devices } from '@playwright/test';

// Dark-mode pixel sweep over every Phase-4 page. Mirrors
// phase4-audit.spec.ts but forces prefers-color-scheme: dark so
// next-themes flips the docs site to dark and LiqPreview asks the
// snippets app for the dark Flutter theme.

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
  // Phase 4B
  { slug: 'inputs/calendar', title: 'Calendar', iframes: 2 },
  { slug: 'inputs/time-picker', title: 'Time Picker', iframes: 3 },
  { slug: 'inputs/otp', title: 'OTP Input', iframes: 3 },
  { slug: 'inputs/number-field', title: 'Number Field', iframes: 3 },
  { slug: 'inputs/combobox', title: 'Combobox', iframes: 2 },
  { slug: 'inputs/chip', title: 'Chip', iframes: 3 },
  // Phase 4C
  { slug: 'navigation/command-palette', title: 'Command Palette', iframes: 2 },
  { slug: 'containers/carousel', title: 'Carousel', iframes: 3 },
  { slug: 'status/hover-card', title: 'Hover Card', iframes: 2 },
  { slug: 'containers/resizable', title: 'Resizable', iframes: 2 },
  { slug: 'containers/data-table', title: 'Data Table', iframes: 2 },
  // Phase 6
  { slug: 'containers/collapsible', title: 'Collapsible', iframes: 2 },
  { slug: 'inputs/toggle-group', title: 'Toggle Group', iframes: 2 },
  { slug: 'containers/scroll-area', title: 'Scroll Area', iframes: 2 },
  { slug: 'navigation/bottom-nav', title: 'Bottom Navigation', iframes: 2 },
  { slug: 'inputs/date-picker-field', title: 'Date Picker Field', iframes: 2 },
  { slug: 'inputs/time-field', title: 'Time Field', iframes: 2 },
  { slug: 'inputs/textarea', title: 'Textarea', iframes: 2 },
];

// The docs theme control is intentionally two-state: light and dark.
// Force dark by clicking our custom toolbar button only when a page
// starts in light; the Fumadocs three-state system toggle is disabled.
test.use({ colorScheme: 'light' });

for (const p of PHASE_4_PAGES) {
  test(`dark: ${p.slug} renders`, async ({ page }) => {
    const consoleErrors: string[] = [];
    page.on('pageerror', (e) => consoleErrors.push(`pageerror: ${e.message}`));
    page.on('console', (m) => {
      if (m.type() === 'error') consoleErrors.push(`console: ${m.text()}`);
    });

    await page.goto(`/docs/${p.slug}`);
    await expect(page.locator('h1', { hasText: p.title })).toBeVisible();

    const switchToDark = page
      .locator('button[aria-label="Switch to dark"]')
      .first();
    if (await switchToDark.isVisible().catch(() => false)) {
      await switchToDark.click();
    }
    // Confirm next-themes flipped <html> to the dark class.
    await expect
      .poll(async () => page.locator('html').getAttribute('class'), {
        timeout: 4000,
      })
      .toMatch(/dark/);

    const iframes = page.locator('iframe[title^="liqkit_ui — "]');
    await expect(iframes).toHaveCount(p.iframes);

    // Iframe URL should now carry ?theme=dark. LiqPreview SSRs with
    // theme=light by default and only flips after hydration when
    // useTheme resolves to dark — wait for that update before
    // asserting.
    await expect
      .poll(async () => iframes.first().getAttribute('src'), {
        timeout: 4000,
      })
      .toContain('theme=dark');
    const firstSrc = await iframes.first().getAttribute('src');
    expect(firstSrc).toBeTruthy();
    const resp = await page.request.get(firstSrc!);
    expect(resp.status()).toBe(200);
    const html = await resp.text();
    expect(html).toMatch(/liqkit_ui/i);
    expect(html).not.toMatch(/Error response/i);

    await page.screenshot({
      path: `test-results/phase4-dark/${p.slug.replace('/', '__')}.png`,
      fullPage: true,
    });

    expect(consoleErrors, consoleErrors.join('; ')).toEqual([]);
  });
}
