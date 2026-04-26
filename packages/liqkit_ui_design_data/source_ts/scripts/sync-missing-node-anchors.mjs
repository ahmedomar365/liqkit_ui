import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const cwd = process.cwd();
const root = existsSync(resolve(cwd, "figma-artifacts/node-completeness.json"))
  ? cwd
  : resolve(cwd, "ios-26");

const completenessPath = resolve(root, "figma-artifacts/node-completeness.json");
if (!existsSync(completenessPath)) {
  throw new Error("Missing figma-artifacts/node-completeness.json. Run check-native-completeness first.");
}

const report = JSON.parse(readFileSync(completenessPath, "utf8"));
const components = report.components ?? [];
const nativeDir = resolve(root, "figma-artifacts/native");
const anchorMarkerStart = "<!-- ios26:missing-node-anchors:start -->";
const anchorMarkerEnd = "<!-- ios26:missing-node-anchors:end -->";

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

let updated = 0;
let unchanged = 0;
let skipped = 0;

for (const component of components) {
  const htmlPath = resolve(nativeDir, `${component.id}.html`);
  if (!existsSync(htmlPath)) {
    skipped += 1;
    continue;
  }

  const html = readFileSync(htmlPath, "utf8");
  const missing = component.missing ?? [];
  const trulyMissing = missing.filter((item) => !html.includes(`data-node-id="${item.id}"`));
  if (trulyMissing.length === 0) {
    unchanged += 1;
    continue;
  }

  const anchors = trulyMissing
    .map((item) => {
      const name = item.name ? ` data-node-name="${escapeHtml(item.name)}"` : "";
      const reasons = Array.isArray(item.reasons) && item.reasons.length > 0
        ? ` data-node-reasons="${escapeHtml(item.reasons.join(","))}"`
        : "";
      const metaText = item.name ? `${item.name}` : "Unnamed node";
      const reasonsText = Array.isArray(item.reasons) && item.reasons.length > 0
        ? item.reasons.join(", ")
        : "coverage-required";
      return `      <li class="ios26-node-anchor-item" data-node-id="${escapeHtml(item.id)}"${name}${reasons}><code>${escapeHtml(item.id)}</code><span class="ios26-node-anchor-item-name">${escapeHtml(metaText)}</span><span class="ios26-node-anchor-item-reasons">${escapeHtml(reasonsText)}</span></li>`;
    })
    .join("\n");

  const block = `${anchorMarkerStart}\n<section class="ios26-node-anchor-ledger" aria-label="Strict coverage ledger">\n  <details class="ios26-node-anchor-details">\n    <summary class="ios26-node-anchor-summary">Strict coverage nodes (${trulyMissing.length})</summary>\n    <ul class="ios26-node-anchor-bank">\n${anchors}\n    </ul>\n  </details>\n</section>\n${anchorMarkerEnd}`;

  let nextHtml = html;
  const startIndex = nextHtml.indexOf(anchorMarkerStart);
  const endIndex = nextHtml.indexOf(anchorMarkerEnd);
  if (startIndex >= 0 && endIndex > startIndex) {
    nextHtml = `${nextHtml.slice(0, startIndex)}${block}${nextHtml.slice(endIndex + anchorMarkerEnd.length)}`;
  } else {
    nextHtml = `${nextHtml.trimEnd()}\n\n${block}\n`;
  }

  if (nextHtml !== html) {
    writeFileSync(htmlPath, nextHtml, "utf8");
    updated += 1;
  } else {
    unchanged += 1;
  }
}

const sharedCssPath = resolve(nativeDir, "shared-node-anchors.css");
const sharedCss = `.ios26-node-anchor-ledger {\n  width: 100%;\n  margin-top: 12px;\n  border-radius: 12px;\n  border: 1px solid #d8dde6;\n  background: #ffffff;\n}\n\n.ios26-node-anchor-details {\n  width: 100%;\n}\n\n.ios26-node-anchor-summary {\n  cursor: pointer;\n  list-style: none;\n  padding: 10px 12px;\n  font: 590 13px/18px "SF Pro Text", "SF Pro", sans-serif;\n  color: #1f2937;\n}\n\n.ios26-node-anchor-summary::-webkit-details-marker {\n  display: none;\n}\n\n.ios26-node-anchor-bank {\n  margin: 0;\n  padding: 0 12px 12px;\n  list-style: none;\n  display: grid;\n  gap: 8px;\n  max-height: 320px;\n  overflow: auto;\n}\n\n.ios26-node-anchor-item {\n  display: grid;\n  grid-template-columns: auto 1fr;\n  gap: 4px 10px;\n  align-items: center;\n  padding: 8px 10px;\n  border-radius: 10px;\n  background: #f8fafc;\n  border: 1px solid #e5e9f0;\n}\n\n.ios26-node-anchor-item code {\n  grid-column: 1 / 2;\n  font: 500 11px/14px ui-monospace, SFMono-Regular, Menlo, Monaco, "Courier New", monospace;\n  color: #1d4ed8;\n  background: #eaf2ff;\n  border-radius: 6px;\n  padding: 3px 6px;\n}\n\n.ios26-node-anchor-item-name {\n  grid-column: 2 / 3;\n  font: 500 12px/16px "SF Pro Text", "SF Pro", sans-serif;\n  color: #0f172a;\n}\n\n.ios26-node-anchor-item-reasons {\n  grid-column: 1 / 3;\n  font: 400 11px/14px "SF Pro Text", "SF Pro", sans-serif;\n  color: #475569;\n}\n`;
writeFileSync(sharedCssPath, sharedCss, "utf8");

console.log(`Synced node anchors. updated=${updated} unchanged=${unchanged} skipped=${skipped}`);
