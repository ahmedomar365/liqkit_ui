import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const manifestPath = resolve(root, "FIGMA_NODE_MANIFEST.md");
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");

const manifest = readFileSync(manifestPath, "utf8");
const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));

if (!Array.isArray(catalog)) {
  throw new Error("catalog.json must be an array");
}

const rowRegex = /^\|\s*([^|]+?)\s*\|\s*`(\d+:\d+)`\s*\|\s*(https?:\/\/[^\s|]+)\s*\|$/gm;
const manifestRows = [];
let match;
while ((match = rowRegex.exec(manifest)) !== null) {
  manifestRows.push({
    category: match[1].trim(),
    figmaNodeId: match[2].trim(),
    figmaUrl: match[3].trim(),
  });
}

if (manifestRows.length === 0) {
  throw new Error("No rows parsed from FIGMA_NODE_MANIFEST.md");
}

if (catalog.length !== manifestRows.length) {
  throw new Error(
    `catalog row count mismatch: catalog=${catalog.length} manifest=${manifestRows.length}`,
  );
}

function duplicates(items) {
  const counts = new Map();
  for (const item of items) {
    counts.set(item, (counts.get(item) ?? 0) + 1);
  }
  return [...counts.entries()]
    .filter(([, count]) => count > 1)
    .map(([item]) => item)
    .sort();
}

const ids = catalog.map((item) => item.id);
const nodeIds = catalog.map((item) => item.figmaNodeId);
const urls = catalog.map((item) => item.figmaUrl);

const duplicateIds = duplicates(ids);
const duplicateNodeIds = duplicates(nodeIds);
const duplicateUrls = duplicates(urls);

if (duplicateIds.length > 0 || duplicateNodeIds.length > 0 || duplicateUrls.length > 0) {
  const errors = [];
  if (duplicateIds.length > 0) {
    errors.push(`duplicate ids: ${duplicateIds.join(", ")}`);
  }
  if (duplicateNodeIds.length > 0) {
    errors.push(`duplicate node ids: ${duplicateNodeIds.join(", ")}`);
  }
  if (duplicateUrls.length > 0) {
    errors.push(`duplicate figma urls: ${duplicateUrls.join(", ")}`);
  }
  throw new Error(errors.join("; "));
}

const manifestByNode = new Map(manifestRows.map((row) => [row.figmaNodeId, row]));

for (const item of catalog) {
  const row = manifestByNode.get(item.figmaNodeId);
  if (!row) {
    throw new Error(`catalog node not in manifest: ${item.figmaNodeId}`);
  }

  if (item.figmaUrl !== row.figmaUrl) {
    throw new Error(`catalog URL mismatch for node ${item.figmaNodeId}`);
  }

  if (item.category !== row.category) {
    throw new Error(`catalog category mismatch for node ${item.figmaNodeId}`);
  }

  if (item.status !== "unverified" && item.status !== "verified") {
    throw new Error(`invalid status for ${item.id}: ${item.status}`);
  }

  if (item.status === "verified") {
    const artifactPaths = [
      item.artifacts?.designContextPath,
      item.artifacts?.screenshotPath,
    ];

    for (const relPath of artifactPaths) {
      if (!relPath) {
        throw new Error(`verified component missing artifact path: ${item.id}`);
      }
      const absPath = resolve(root, relPath);
      if (!existsSync(absPath)) {
        throw new Error(`verified component artifact missing on disk: ${absPath}`);
      }
    }
  }
}

console.log(`Strict component catalog check passed. components=${catalog.length}`);
