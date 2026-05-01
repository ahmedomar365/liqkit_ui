import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

// Accessibility audit over a representative sample of every Phase-4
// component page using axe-core's WCAG 2.1 A + AA + Best Practices
// rules. Excludes the snippet iframes (cross-origin Flutter) since
// axe can't see into them; the docs site chrome itself is what we
// audit here.

interface PageSpec {
  slug: string;
  title: string;
}

// One page per Phase-4 component (27 total).
const PAGES: PageSpec[] = [
  { slug: 'containers/accordion', title: 'Accordion' },
  { slug: 'foundation/avatar', title: 'Avatar' },
  { slug: 'status/badge', title: 'Badge' },
  { slug: 'containers/card', title: 'Card' },
  { slug: 'inputs/checkbox', title: 'Checkbox' },
  { slug: 'inputs/radio', title: 'Radio' },
  { slug: 'foundation/divider', title: 'Divider' },
  { slug: 'status/skeleton', title: 'Skeleton' },
  { slug: 'navigation/tabs', title: 'Tabs' },
  { slug: 'status/tooltip', title: 'Tooltip' },
  { slug: 'status/toast', title: 'Toast' },
  { slug: 'containers/drawer', title: 'Drawer' },
  { slug: 'containers/dialog', title: 'Dialog' },
  { slug: 'foundation/label', title: 'Label' },
  { slug: 'navigation/breadcrumb', title: 'Breadcrumb' },
  { slug: 'navigation/pagination', title: 'Pagination' },
  { slug: 'inputs/calendar', title: 'Calendar' },
  { slug: 'inputs/time-picker', title: 'Time Picker' },
  { slug: 'inputs/otp', title: 'OTP Input' },
  { slug: 'inputs/number-field', title: 'Number Field' },
  { slug: 'inputs/combobox', title: 'Combobox' },
  { slug: 'inputs/chip', title: 'Chip' },
  { slug: 'navigation/command-palette', title: 'Command Palette' },
  { slug: 'containers/carousel', title: 'Carousel' },
  { slug: 'status/hover-card', title: 'Hover Card' },
  { slug: 'containers/resizable', title: 'Resizable' },
  { slug: 'containers/data-table', title: 'Data Table' },
  // Phase 6
  { slug: 'containers/collapsible', title: 'Collapsible' },
  { slug: 'inputs/toggle-group', title: 'Toggle Group' },
  { slug: 'containers/scroll-area', title: 'Scroll Area' },
  { slug: 'navigation/bottom-nav', title: 'Bottom Navigation' },
  { slug: 'inputs/date-picker-field', title: 'Date Picker Field' },
  { slug: 'inputs/time-field', title: 'Time Field' },
  { slug: 'inputs/textarea', title: 'Textarea' },
];

for (const p of PAGES) {
  test(`a11y: ${p.slug}`, async ({ page }) => {
    await page.goto(`/docs/${p.slug}`);
    await expect(page.locator('h1', { hasText: p.title })).toBeVisible();

    const results = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa', 'best-practice'])
      // Exclude iframes — they're cross-origin Flutter; axe can't enter
      // them and would report a noisy "frame-tested" violation if it
      // tried.
      .exclude('iframe')
      .analyze();

    if (results.violations.length > 0) {
      // Format violations succinctly so test failures are diagnosable.
      const lines = results.violations.map(
        (v) => `  ${v.impact ?? 'info'}: ${v.id} — ${v.help} (${v.nodes.length} node${v.nodes.length === 1 ? '' : 's'})`,
      );
      throw new Error(
        `Found ${results.violations.length} a11y violation${results.violations.length === 1 ? '' : 's'} on /docs/${p.slug}:\n${lines.join('\n')}`,
      );
    }
  });
}
