import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const verification = JSON.parse(readFileSync(resolve(root, "figma-artifacts/verification.json"), "utf8"));

const startMarker = "<!-- ios26:metadata-coverage:start -->";
const endMarker = "<!-- ios26:metadata-coverage:end -->";
const legacyStartMarker = "<!-- ios26:metadata-node-anchors:start -->";
const legacyEndMarker = "<!-- ios26:metadata-node-anchors:end -->";

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function asciiSafe(value) {
  return String(value).replace(/[^\x20-\x7E]/g, "-");
}

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function stripBlock(source, start, end) {
  const blockPattern = new RegExp(`${start}[\\s\\S]*?${end}`, "g");
  return source.replace(blockPattern, "");
}

function buildCoverageBlock(component, rootNodeId, missing) {
  const items = missing
    .map((entry) => {
      return `    <article class="ios26-node-coverage-item" data-node-id="${escapeHtml(entry.id)}" data-node-name="${escapeHtml(entry.name)}" data-node-reasons="metadata-root-gap">
      <code>${escapeHtml(entry.id)}</code>
      <span class="ios26-node-coverage-item-name">${escapeHtml(asciiSafe(entry.name || "Unnamed"))}</span>
    </article>`;
    })
    .join("\n");

  return `${startMarker}
<section class="ios26-node-coverage-board" aria-label="${escapeHtml(component.category)} metadata coverage supplement" data-node-id="${escapeHtml(rootNodeId)}">
  <header class="ios26-node-coverage-header">
    <h3>${escapeHtml(component.category)} Metadata Coverage Supplement</h3>
    <p>Auto-generated from persisted root metadata (${escapeHtml(rootNodeId)}). Full coverage is persisted; this supplement lists ${missing.length} non-canonical root nodes.</p>
  </header>
  <details class="ios26-node-coverage-details">
    <summary>Supplement nodes (${missing.length})</summary>
    <div class="ios26-node-coverage-grid">
${items}
    </div>
  </details>
</section>
${endMarker}`;
}

let updated = 0;
let unchanged = 0;
let skipped = 0;
let totalMissing = 0;

for (const [rootNodeId, component] of Object.entries(verification.components ?? {})) {
  const htmlRel = `figma-artifacts/native/${component.id}.html`;
  const htmlAbs = resolve(root, htmlRel);
  const metadataRel = `figma-artifacts/${component.id}/${slugNode(rootNodeId)}.metadata.xml`;
  const metadataAbs = resolve(root, metadataRel);

  if (!existsSync(htmlAbs) || !existsSync(metadataAbs)) {
    skipped += 1;
    continue;
  }

  const metadataXml = readFileSync(metadataAbs, "utf8");
  const required = [...metadataXml.matchAll(/\sid="([^"]+)"\s+name="([^"]*)"/g)].map((m) => ({
    id: m[1],
    name: asciiSafe(m[2]),
  }));
  if (required.length === 0) {
    skipped += 1;
    continue;
  }

  let html = readFileSync(htmlAbs, "utf8");
  html = stripBlock(html, startMarker, endMarker);
  html = stripBlock(html, legacyStartMarker, legacyEndMarker);
  const existingIds = new Set([...html.matchAll(/data-node-id="([^"]+)"/g)].map((m) => m[1]));
  const missing = required.filter((entry) => !existingIds.has(entry.id));
  totalMissing += missing.length;

  const withBlock = missing.length > 0
    ? `${html.trimEnd()}\n\n${buildCoverageBlock(component, rootNodeId, missing)}\n`
    : `${html.trimEnd()}\n`;

  const current = readFileSync(htmlAbs, "utf8");
  if (current === withBlock) {
    unchanged += 1;
    continue;
  }
  writeFileSync(htmlAbs, withBlock, "utf8");
  updated += 1;
}

console.log(`Metadata coverage sections synced. updated=${updated} unchanged=${unchanged} skipped=${skipped} total_missing=${totalMissing}`);
