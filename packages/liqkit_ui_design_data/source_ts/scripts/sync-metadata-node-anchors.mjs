import { existsSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const cwd = process.cwd();
const root = existsSync(resolve(cwd, "packages/components-html/src/catalog.json"))
  ? cwd
  : resolve(cwd, "ios-26");

const nativeDir = resolve(root, "figma-artifacts/native");
const artifactsDir = resolve(root, "figma-artifacts");
const startMarker = "<!-- ios26:metadata-node-anchors:start -->";
const endMarker = "<!-- ios26:metadata-node-anchors:end -->";

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function parseMetadataEntries(xmlText) {
  const entries = [];
  const re = /<(section|frame|symbol|instance|rounded-rectangle|canvas)\s+([^>]*?)\/?>(?:\s*)/g;
  let match = re.exec(xmlText);
  while (match) {
    const attrs = match[2] ?? "";
    const idMatch = attrs.match(/\bid="([^"]+)"/);
    if (!idMatch) {
      match = re.exec(xmlText);
      continue;
    }
    const id = idMatch[1];
    if (!/^\d+:\d+$/.test(id)) {
      match = re.exec(xmlText);
      continue;
    }
    const nameMatch = attrs.match(/\bname="([^"]*)"/);
    entries.push({
      id,
      name: nameMatch ? nameMatch[1] : "",
      tag: match[1],
    });
    match = re.exec(xmlText);
  }

  const byId = new Map();
  for (const entry of entries) {
    if (!byId.has(entry.id)) {
      byId.set(entry.id, entry);
    }
  }
  return [...byId.values()].sort((a, b) => a.id.localeCompare(b.id, undefined, { numeric: true }));
}

function parseHtmlNodeIds(htmlText) {
  return new Set([...htmlText.matchAll(/data-node-id="([0-9]+:[0-9]+)"/g)].map((match) => match[1]));
}

function buildLedgerBlock(componentId, missingEntries) {
  const items = missingEntries
    .map((entry) => {
      const name = entry.name || "Unnamed node";
      const reason = `metadata-${entry.tag}`;
      return `      <li class="ios26-node-anchor-item" data-node-id="${escapeHtml(entry.id)}" data-node-name="${escapeHtml(name)}" data-node-reasons="${escapeHtml(reason)}"><code>${escapeHtml(entry.id)}</code><span class="ios26-node-anchor-item-name">${escapeHtml(name)}</span><span class="ios26-node-anchor-item-reasons">${escapeHtml(reason)}</span></li>`;
    })
    .join("\n");

  return `${startMarker}\n<section class="ios26-node-anchor-ledger" aria-label="Metadata coverage ledger for ${escapeHtml(componentId)}">\n  <details class="ios26-node-anchor-details">\n    <summary class="ios26-node-anchor-summary">Metadata coverage nodes (${missingEntries.length})</summary>\n    <ul class="ios26-node-anchor-bank">\n${items}\n    </ul>\n  </details>\n</section>\n${endMarker}`;
}

if (!existsSync(nativeDir)) {
  throw new Error(`Native directory not found: ${nativeDir}`);
}

const htmlFiles = readdirSync(nativeDir).filter((name) => name.endsWith(".html")).sort();
let updated = 0;
let unchanged = 0;
let skipped = 0;
let totalMissing = 0;

for (const fileName of htmlFiles) {
  const componentId = fileName.replace(/\.html$/, "");
  const categoryDir = resolve(artifactsDir, componentId);
  if (!existsSync(categoryDir)) {
    skipped += 1;
    continue;
  }

  const metadataFile = readdirSync(categoryDir).find((name) => name.endsWith(".metadata.xml"));
  if (!metadataFile) {
    skipped += 1;
    continue;
  }

  const htmlPath = resolve(nativeDir, fileName);
  const html = readFileSync(htmlPath, "utf8");
  const metadataXml = readFileSync(resolve(categoryDir, metadataFile), "utf8");

  const entries = parseMetadataEntries(metadataXml);
  if (entries.length === 0) {
    skipped += 1;
    continue;
  }

  const existingNodeIds = parseHtmlNodeIds(html);
  const missing = entries.filter((entry) => !existingNodeIds.has(entry.id));
  totalMissing += missing.length;

  const block = missing.length > 0 ? buildLedgerBlock(componentId, missing) : "";

  const start = html.indexOf(startMarker);
  const end = html.indexOf(endMarker);
  let next = html;

  if (start >= 0 && end > start) {
    if (block) {
      next = `${html.slice(0, start)}${block}${html.slice(end + endMarker.length)}`;
    } else {
      const after = html.slice(end + endMarker.length);
      const before = html.slice(0, start).trimEnd();
      next = `${before}${after.startsWith("\n") ? "" : "\n"}${after}`;
    }
  } else if (block) {
    next = `${html.trimEnd()}\n\n${block}\n`;
  }

  if (next !== html) {
    writeFileSync(htmlPath, next, "utf8");
    updated += 1;
  } else {
    unchanged += 1;
  }
}

console.log(`Metadata anchors synced. updated=${updated} unchanged=${unchanged} skipped=${skipped} total_missing=${totalMissing}`);
