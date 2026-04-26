import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const manifestPath = resolve(process.cwd(), "FIGMA_NODE_MANIFEST.md");
const content = readFileSync(manifestPath, "utf8");

const rowRegex = /^\|\s*([^|]+?)\s*\|\s*`([^`]+)`\s*\|\s*(https?:\/\/[^\s|]+)\s*\|$/gm;
const categories = [];
const nodeIds = [];

let match;
while ((match = rowRegex.exec(content)) !== null) {
  categories.push(match[1].trim().toLowerCase());
  nodeIds.push(match[2].trim());
}

if (categories.length === 0) {
  throw new Error("No manifest rows parsed from FIGMA_NODE_MANIFEST.md");
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

const duplicateCategories = duplicates(categories);
const duplicateNodeIds = duplicates(nodeIds);

if (duplicateCategories.length > 0 || duplicateNodeIds.length > 0) {
  const parts = [];
  if (duplicateCategories.length > 0) {
    parts.push(`duplicate categories: ${duplicateCategories.join(", ")}`);
  }
  if (duplicateNodeIds.length > 0) {
    parts.push(`duplicate node ids: ${duplicateNodeIds.join(", ")}`);
  }
  throw new Error(parts.join("; "));
}

console.log(`Manifest check passed. rows=${categories.length}`);
