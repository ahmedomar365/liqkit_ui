import { existsSync, readdirSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const nativeDir = resolve(root, "figma-artifacts/native");

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
const ids = new Set(catalog.map((item) => item.id));

const missing = [];
for (const item of catalog) {
  const htmlPath = resolve(nativeDir, `${item.id}.html`);
  const cssPath = resolve(nativeDir, `${item.id}.css`);
  if (!existsSync(htmlPath) || !existsSync(cssPath)) {
    missing.push(item.id);
  }
}

const orphan = [];
if (existsSync(nativeDir)) {
  const names = readdirSync(nativeDir);
  for (const name of names) {
    if (/^shared-.*\.css$/.test(name)) {
      continue;
    }
    const match = name.match(/^(.*)\.(html|css)$/);
    if (!match) continue;
    const id = match[1];
    if (!ids.has(id)) {
      orphan.push(name);
    }
  }
}

if (missing.length > 0 || orphan.length > 0) {
  const parts = [];
  if (missing.length > 0) {
    parts.push(`missing native html/css pairs: ${missing.join(", ")}`);
  }
  if (orphan.length > 0) {
    parts.push(`orphan native files: ${orphan.join(", ")}`);
  }
  throw new Error(parts.join(" | "));
}

console.log(`Native coverage check passed. components=${catalog.length}`);
