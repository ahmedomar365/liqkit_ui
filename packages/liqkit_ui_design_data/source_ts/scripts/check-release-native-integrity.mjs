import { existsSync, readFileSync, readdirSync, statSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const manifestPath = resolve(root, "release/native/manifest.json");
const componentsDir = resolve(root, "release/native/components");
const assetsDir = resolve(root, "release/native/assets");
const kitCssPath = resolve(root, "release/native/kit.css");

const errors = [];

function requireFile(path, label) {
  if (!existsSync(path)) {
    errors.push(`Missing ${label}: ${path}`);
    return false;
  }
  const size = statSync(path).size;
  if (size <= 0) {
    errors.push(`Empty ${label}: ${path}`);
    return false;
  }
  return true;
}

function hasForbiddenRef(text) {
  const patterns = [
    /\/evidence\//i,
    /https?:\/\//i,
    /\.figma\.com\//i,
    /127\.0\.0\.1:4173/i,
  ];
  return patterns.some((pattern) => pattern.test(text));
}

if (!requireFile(catalogPath, "catalog")) {
  process.exit(1);
}

if (!requireFile(manifestPath, "release manifest")) {
  process.exit(1);
}

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
const manifest = JSON.parse(readFileSync(manifestPath, "utf8"));

if (!Array.isArray(catalog)) {
  errors.push("catalog.json must be an array");
}
if (!Array.isArray(manifest.components)) {
  errors.push("release/native/manifest.json.components must be an array");
}
if (!Array.isArray(manifest.bundledAssets)) {
  errors.push("release/native/manifest.json.bundledAssets must be an array");
}
if (!Array.isArray(manifest.sharedFiles)) {
  errors.push("release/native/manifest.json.sharedFiles must be an array");
}

if (errors.length > 0) {
  console.error("Release native integrity check failed:");
  for (const error of errors) {
    console.error(`- ${error}`);
  }
  process.exit(1);
}

const catalogIds = new Set(catalog.map((item) => item.id));
const manifestById = new Map(manifest.components.map((item) => [item.id, item]));

if (manifest.components.length !== catalog.length) {
  errors.push(
    `Component count mismatch: catalog=${catalog.length} manifest=${manifest.components.length}`,
  );
}

for (const id of catalogIds) {
  if (!manifestById.has(id)) {
    errors.push(`Manifest missing component: ${id}`);
  }
}
for (const id of manifestById.keys()) {
  if (!catalogIds.has(id)) {
    errors.push(`Manifest has unknown component: ${id}`);
  }
}

if (!existsSync(componentsDir)) {
  errors.push(`Missing components directory: ${componentsDir}`);
} else {
  const files = readdirSync(componentsDir).filter((name) => /\.(html|css)$/.test(name));
  const htmlFiles = files.filter((name) => name.endsWith(".html"));
  const cssFiles = files.filter((name) => name.endsWith(".css"));

  if (htmlFiles.length !== catalog.length) {
    errors.push(`HTML file count mismatch: expected ${catalog.length}, got ${htmlFiles.length}`);
  }
  if (cssFiles.length !== catalog.length) {
    errors.push(`CSS file count mismatch: expected ${catalog.length}, got ${cssFiles.length}`);
  }

  for (const item of catalog) {
    const htmlPath = resolve(componentsDir, `${item.id}.html`);
    const cssPath = resolve(componentsDir, `${item.id}.css`);

    if (!requireFile(htmlPath, `component html (${item.id})`)) {
      continue;
    }
    requireFile(cssPath, `component css (${item.id})`);

    const html = readFileSync(htmlPath, "utf8");
    const css = readFileSync(cssPath, "utf8");

    if (hasForbiddenRef(html)) {
      errors.push(`Forbidden reference detected in ${item.id}.html`);
    }
    if (hasForbiddenRef(css)) {
      errors.push(`Forbidden reference detected in ${item.id}.css`);
    }
  }
}

if (!requireFile(kitCssPath, "kit.css")) {
  // keep collecting other errors
} else {
  const kitCss = readFileSync(kitCssPath, "utf8");
  for (const item of catalog) {
    if (!kitCss.includes(`/* component:${item.id} */`)) {
      errors.push(`kit.css missing component marker for: ${item.id}`);
    }
  }
}

for (const sharedName of manifest.sharedFiles) {
  const sharedPath = resolve(root, "release/native", sharedName);
  requireFile(sharedPath, `shared file (${sharedName})`);
}

const seenAssets = new Set();
for (const assetRel of manifest.bundledAssets) {
  if (typeof assetRel !== "string" || assetRel.length === 0) {
    errors.push("Invalid asset path in manifest.bundledAssets");
    continue;
  }
  if (seenAssets.has(assetRel)) {
    errors.push(`Duplicate bundled asset entry: ${assetRel}`);
  }
  seenAssets.add(assetRel);
  const assetPath = resolve(root, "release/native", assetRel);
  requireFile(assetPath, `bundled asset (${assetRel})`);
}

if (existsSync(assetsDir)) {
  const stack = [assetsDir];
  while (stack.length > 0) {
    const dir = stack.pop();
    for (const name of readdirSync(dir)) {
      const abs = resolve(dir, name);
      const rel = abs.replace(`${resolve(root, "release/native")}/`, "");
      const stat = statSync(abs);
      if (stat.isDirectory()) {
        stack.push(abs);
      } else {
        if (!seenAssets.has(rel)) {
          errors.push(`Asset exists on disk but missing in manifest.bundledAssets: ${rel}`);
        }
      }
    }
  }
}

if (errors.length > 0) {
  console.error("Release native integrity check failed:");
  for (const error of errors) {
    console.error(`- ${error}`);
  }
  process.exit(1);
}

console.log(
  `Release native integrity check passed. components=${catalog.length} assets=${manifest.bundledAssets.length}`,
);
