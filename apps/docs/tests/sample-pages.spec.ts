import { test, expect } from '@playwright/test';

const SAMPLES = [
  { slug: 'foundation/colors', title: 'Colors' },
  { slug: 'inputs/sliders', title: 'Sliders' },
  { slug: 'containers/sheets', title: 'Sheets' },
  { slug: 'navigation/top-bars', title: 'Top Bars' },
  { slug: 'status/face-id', title: 'Face ID' },
  { slug: 'decoration/keyboards', title: 'Keyboards' },
  { slug: 'getting-started/overview', title: 'Overview' },
];

for (const s of SAMPLES) {
  test(`${s.slug} renders`, async ({ page }) => {
    await page.goto(`/docs/${s.slug}`);
    await expect(page.locator('h1', { hasText: s.title })).toBeVisible();
  });
}
