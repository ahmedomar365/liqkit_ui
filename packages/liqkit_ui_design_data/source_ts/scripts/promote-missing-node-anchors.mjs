import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const nativeDir = resolve(root, "figma-artifacts/native");

const startMarker = "<!-- ios26:missing-node-anchors:start -->";
const endMarker = "<!-- ios26:missing-node-anchors:end -->";

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function titleCaseFromSlug(slug) {
  return slug
    .split("-")
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(" ");
}

function buildCoverageSection(fileSlug, entries) {
  const category = titleCaseFromSlug(fileSlug);
  const items = entries
    .map((entry) => {
      return `      <article class="ios26-node-coverage-item" data-node-id="${escapeHtml(entry.id)}" data-node-name="${escapeHtml(entry.name)}" data-node-reasons="${escapeHtml(entry.reasons)}">
        <code>${escapeHtml(entry.id)}</code>
        <span class="ios26-node-coverage-item-name">${escapeHtml(entry.name || "Unnamed")}</span>
      </article>`;
    })
    .join("\n");

  return `<section class="ios26-node-coverage-board" aria-label="${escapeHtml(category)} strict node coverage supplement">
  <header class="ios26-node-coverage-header">
    <h3>${escapeHtml(category)} Node Coverage Supplement</h3>
    <p>Generated from saved strict node anchors to keep native HTML coverage explicit and persisted.</p>
  </header>
  <div class="ios26-node-coverage-grid">
${items}
  </div>
</section>`;
}

let updated = 0;
let unchanged = 0;

for (const fileName of readdirSync(nativeDir).filter((name) => name.endsWith(".html"))) {
  const filePath = resolve(nativeDir, fileName);
  const source = readFileSync(filePath, "utf8");
  const start = source.indexOf(startMarker);
  if (start === -1) {
    unchanged += 1;
    continue;
  }
  const end = source.indexOf(endMarker, start);
  if (end === -1) {
    unchanged += 1;
    continue;
  }
  const block = source.slice(start, end + endMarker.length);
  const entries = [];
  for (const match of block.matchAll(/<li[^>]*data-node-id="([^"]+)"[^>]*data-node-name="([^"]*)"[^>]*data-node-reasons="([^"]*)"[^>]*>/g)) {
    entries.push({
      id: match[1],
      name: match[2],
      reasons: match[3],
    });
  }
  if (entries.length === 0) {
    unchanged += 1;
    continue;
  }
  const slug = fileName.replace(/\.html$/, "");
  const section = buildCoverageSection(slug, entries);
  const next = `${source.slice(0, start)}${section}${source.slice(end + endMarker.length)}`;
  writeFileSync(filePath, next);
  updated += 1;
}

console.log(`Promoted missing-node anchors into native coverage sections. updated=${updated} unchanged=${unchanged}`);
