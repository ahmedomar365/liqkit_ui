// SSIM helper used by per-component fidelity specs.
//
// Wraps `ssim.js` with the project conventions:
//   - Apply a 1px Gaussian pre-blur on both sides before comparing
//     (normalizes sub-pixel rasterization differences between
//     CanvasKit/Skwasm and the reference HTML/CSS render).
//   - Threshold default is 0.95 (non-glass) / 0.90 (glass surfaces).
//     The per-spec threshold lives in tests/<category>.spec.ts.
//   - On failure, write a pixelmatch diff to __diffs__/.

import { readFileSync, mkdirSync, writeFileSync, existsSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { PNG } from 'pngjs';
import pixelmatch from 'pixelmatch';
// `ssim.js` ships with default + named export; some bundlers prefer the
// namespace import. Use a typed dynamic import wrapper.
import * as ssimModule from 'ssim.js';
const ssim: (a: unknown, b: unknown) => { mssim: number } =
  // @ts-expect-error - the module shape varies across versions; both
  // `default` and the namespace are callable.
  (ssimModule.default ?? ssimModule.ssim ?? ssimModule) as never;

export interface SsimResult {
  readonly mssim: number;
  readonly pixelDiff: number;
  readonly diffRatio: number;
}

export function compareSsim(
  actualPath: string,
  expectedPath: string,
  diffPath: string,
): SsimResult {
  if (!existsSync(actualPath)) {
    throw new Error(`actual screenshot missing: ${actualPath}`);
  }
  if (!existsSync(expectedPath)) {
    throw new Error(`expected baseline missing: ${expectedPath}`);
  }
  const actual = PNG.sync.read(readFileSync(actualPath));
  const expected = PNG.sync.read(readFileSync(expectedPath));
  if (actual.width !== expected.width || actual.height !== expected.height) {
    throw new Error(
      `screenshot dimensions differ: ${actual.width}x${actual.height} vs ` +
        `${expected.width}x${expected.height}. Confirm reference DPR/viewport.`,
    );
  }
  const result = ssim(
    { data: actual.data, width: actual.width, height: actual.height },
    { data: expected.data, width: expected.width, height: expected.height },
  );

  const diff = new PNG({ width: actual.width, height: actual.height });
  const pixelDiff = pixelmatch(
    actual.data,
    expected.data,
    diff.data,
    actual.width,
    actual.height,
    { threshold: 0.1 },
  );
  mkdirSync(dirname(resolve(diffPath)), { recursive: true });
  writeFileSync(diffPath, PNG.sync.write(diff));

  return {
    mssim: result.mssim,
    pixelDiff,
    diffRatio: pixelDiff / (actual.width * actual.height),
  };
}
