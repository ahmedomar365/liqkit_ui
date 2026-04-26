#!/usr/bin/env node
// One-shot capture of liqkit's TypeScript token modules into JSON.
//
// Run from the liqkit_ui repo root:
//   node tooling/gen/ts_to_json_oneshot.mjs ../liqkit
//
// Writes packages/liqkit_ui_design_data/manifests/tokens.json.

import { execFileSync } from 'node:child_process';
import { mkdirSync, writeFileSync, existsSync, rmSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(here, '..', '..');
const liqkitArg = process.argv[2];
const liqkitPath = liqkitArg
  ? resolve(process.cwd(), liqkitArg)
  : resolve(repoRoot, '..', 'liqkit');

if (!existsSync(resolve(liqkitPath, 'packages/tokens/src/index.ts'))) {
  console.error(`liqkit tokens not found at ${liqkitPath}`);
  process.exit(2);
}

const outPath = resolve(
  repoRoot,
  'packages/liqkit_ui_design_data/manifests/tokens.json',
);
mkdirSync(dirname(outPath), { recursive: true });

const loaderPath = resolve(here, '.capture.mjs');
const loaderSource = [
  `import * as foundation from ${JSON.stringify(`${liqkitPath}/packages/tokens/src/foundation.ts`)};`,
  `import * as semantic from ${JSON.stringify(`${liqkitPath}/packages/tokens/src/semantic.ts`)};`,
  `import * as component from ${JSON.stringify(`${liqkitPath}/packages/tokens/src/component.ts`)};`,
  ``,
  `function pickAllExports(mod) {`,
  `  const out = {};`,
  `  for (const k of Object.keys(mod)) {`,
  `    if (k === 'default') continue;`,
  `    out[k] = mod[k];`,
  `  }`,
  `  return out;`,
  `}`,
  ``,
  `const combined = {`,
  `  capturedAt: new Date().toISOString(),`,
  `  schemaVersion: 1,`,
  `  foundation: pickAllExports(foundation),`,
  `  semantic: pickAllExports(semantic),`,
  `  component: pickAllExports(component),`,
  `};`,
  ``,
  `process.stdout.write(JSON.stringify(combined, null, 2));`,
].join('\n');
writeFileSync(loaderPath, loaderSource);

try {
  const json = execFileSync('npx', ['--yes', 'tsx', loaderPath], {
    cwd: liqkitPath,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'inherit'],
  });
  writeFileSync(outPath, json);
  console.log(`Wrote ${outPath} (${json.length} bytes)`);
} finally {
  rmSync(loaderPath, { force: true });
}
