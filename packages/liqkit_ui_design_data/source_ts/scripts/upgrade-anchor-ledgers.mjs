import { existsSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const nativeDir = resolve(root, "figma-artifacts/native");

const startMarker = "<!-- ios26:missing-node-anchors:start -->";
const endMarker = "<!-- ios26:missing-node-anchors:end -->";

function parseSpanEntry(spanTag) {
  const idMatch = spanTag.match(/data-node-id="([^"]+)"/);
  if (!idMatch) {
    return null;
  }
  const nameMatch = spanTag.match(/data-node-name="([^"]*)"/);
  const reasonsMatch = spanTag.match(/data-node-reasons="([^"]*)"/);
  return {
    id: idMatch[1],
    name: nameMatch ? nameMatch[1] : "Unnamed node",
    reasons: reasonsMatch ? reasonsMatch[1] : "coverage-required",
  };
}

function buildLedger(entries) {
  const list = entries
    .map((entry) => {
      return `      <li class="ios26-node-anchor-item" data-node-id="${entry.id}" data-node-name="${entry.name}" data-node-reasons="${entry.reasons}"><code>${entry.id}</code><span class="ios26-node-anchor-item-name">${entry.name}</span><span class="ios26-node-anchor-item-reasons">${entry.reasons}</span></li>`;
    })
    .join("\n");

  return `${startMarker}
<section class="ios26-node-anchor-ledger" aria-label="Strict coverage ledger">
  <details class="ios26-node-anchor-details">
    <summary class="ios26-node-anchor-summary">Strict coverage nodes (${entries.length})</summary>
    <ul class="ios26-node-anchor-bank">
${list}
    </ul>
  </details>
</section>
${endMarker}`;
}

if (!existsSync(nativeDir)) {
  throw new Error(`Native directory not found: ${nativeDir}`);
}

const htmlFiles = readdirSync(nativeDir).filter((name) => name.endsWith(".html"));
let converted = 0;
let skipped = 0;

for (const fileName of htmlFiles) {
  const filePath = resolve(nativeDir, fileName);
  const source = readFileSync(filePath, "utf8");
  const start = source.indexOf(startMarker);
  const end = source.indexOf(endMarker);
  if (start < 0 || end <= start) {
    skipped += 1;
    continue;
  }

  const block = source.slice(start, end + endMarker.length);
  const spanTags = block.match(/<span class="ios26-node-anchor"[^>]*><\/span>/g) ?? [];
  if (spanTags.length === 0) {
    skipped += 1;
    continue;
  }

  const entries = spanTags.map(parseSpanEntry).filter(Boolean);
  if (entries.length === 0) {
    skipped += 1;
    continue;
  }

  const replacement = buildLedger(entries);
  const next = `${source.slice(0, start)}${replacement}${source.slice(end + endMarker.length)}`;
  writeFileSync(filePath, next, "utf8");
  converted += 1;
}

console.log(`Upgraded anchor ledgers. converted=${converted} skipped=${skipped}`);
