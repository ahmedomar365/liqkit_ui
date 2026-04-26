import { defineConfig, devices } from '@playwright/test';

// Visual-fidelity test config for the liqkit_ui showcase. The actual
// per-component fidelity specs (SSIM compare against
// liqkit_ui_design_data/rendered/fidelity-snapshots/) land in the
// per-component batch plans. This config is the scaffolding.
//
// To run:
//   1. cd ../../apps/showcase && flutter build web --wasm --release
//   2. cd build/web && python3 -m http.server 4173 (or any static server
//      that emits COOP/COEP headers — see docs/COOP_COEP.md, future)
//   3. cd ../../../tooling/playwright && npm test

export default defineConfig({
  testDir: './tests',
  timeout: 30_000,
  expect: { timeout: 10_000 },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 2 : undefined,
  reporter: [
    ['list'],
    ['html', { open: 'never' }],
  ],

  use: {
    baseURL: process.env.SHOWCASE_URL ?? 'http://localhost:4173',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'chromium-iphone',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 393, height: 852 },
        deviceScaleFactor: 3,
      },
    },
    {
      name: 'chromium-ipad',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 1024, height: 768 },
        deviceScaleFactor: 2,
      },
    },
  ],
});
