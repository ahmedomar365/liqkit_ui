import fs from "node:fs";
import path from "node:path";

const rootDir = process.cwd();
const htmlPath = path.join(rootDir, "figma-artifacts/native/buttons.html");
const metadataPath = path.join(rootDir, "figma-artifacts/buttons/507-24673.metadata.xml");

const generatedStart = "<!-- ios26:buttons-generated-coverage:start -->";
const generatedEnd = "<!-- ios26:buttons-generated-coverage:end -->";
const missingAnchorStart = "<!-- ios26:missing-node-anchors:start -->";
const missingAnchorEnd = "<!-- ios26:missing-node-anchors:end -->";
const metadataAnchorStart = "<!-- ios26:metadata-node-anchors:start -->";
const metadataAnchorEnd = "<!-- ios26:metadata-node-anchors:end -->";

const styleMap = new Map([
  ["Bordered - Prominent", "bordered-prominent"],
  ["Bordered", "bordered"],
  ["Bordered - Secondary", "bordered-secondary"],
  ["Borderless", "borderless"],
  ["Liquid", "liquid"],
]);

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function stripRange(source, startMarker, endMarker) {
  const start = source.indexOf(startMarker);
  if (start === -1) {
    return source;
  }
  const end = source.indexOf(endMarker, start);
  if (end === -1) {
    return source;
  }
  return `${source.slice(0, start)}${source.slice(end + endMarker.length)}`;
}

function parseMetadataEntries(xml) {
  const entries = [];
  const pattern =
    /<(canvas|frame|section|symbol|instance)\s+id="([^"]+)"\s+name="([^"]*)"[^>]*?\sx="([^"]+)"\s+y="([^"]+)"\s+width="([^"]+)"\s+height="([^"]+)"[^>]*\/?>/g;
  for (const match of xml.matchAll(pattern)) {
    entries.push({
      tag: match[1],
      id: match[2],
      name: match[3],
      x: Number.parseFloat(match[4]),
      y: Number.parseFloat(match[5]),
      width: Number.parseFloat(match[6]),
      height: Number.parseFloat(match[7]),
    });
  }
  return entries;
}

function parseVariantName(name) {
  if (!name.includes("Size=") || !name.includes("Style=")) {
    return null;
  }
  const parts = name.split(",").map((part) => part.trim()).filter(Boolean);
  const values = {};
  for (const part of parts) {
    const splitIndex = part.indexOf("=");
    if (splitIndex === -1) {
      continue;
    }
    const key = part.slice(0, splitIndex).trim();
    const value = part.slice(splitIndex + 1).trim();
    values[key] = value;
  }

  const labelType = values["Label Type"] ?? "Text";
  const styleToken = values.Style ?? "Borderless";
  const style = styleMap.get(styleToken) ?? "borderless";
  const sizeToken = values.Size ?? "Medium";
  const size = sizeToken.toLowerCase() === "large"
    ? "large"
    : sizeToken.toLowerCase() === "small"
      ? "small"
      : "medium";
  const enabled = (values.Enabled ?? "True").toLowerCase() === "true";
  const destructive = (values.Destructive ?? "False").toLowerCase() === "true";

  let labelClass = "ios26-btn--text";
  if (labelType === "Symbol") {
    labelClass = "ios26-btn--symbol";
  } else if (labelType === "Symbol + Text") {
    labelClass = "ios26-btn--symbol-plus-text";
  }

  return {
    labelType,
    style,
    size,
    enabled,
    destructive,
    labelClass,
  };
}

function buildButtonContent(variant) {
  const icon = `<span class="ios26-btn-icon" aria-hidden="true"><svg viewBox="0 0 20 20" fill="none"><use href="#ios26-buttons-symbol-play" xlink:href="#ios26-buttons-symbol-play"></use></svg></span>`;
  const label = `<span class="ios26-btn-label">Label</span>`;
  if (variant.labelType === "Symbol") {
    return `<span class="ios26-btn-inner">${icon}</span>`;
  }
  if (variant.labelType === "Symbol + Text") {
    return `<span class="ios26-btn-inner">${icon}${label}</span>`;
  }
  return `<span class="ios26-btn-inner">${label}</span>`;
}

function buildButtonMarkup(entry, variant) {
  const disabledAttr = variant.enabled ? "" : " disabled";
  const enabledClass = variant.enabled ? "is-enabled" : "is-disabled";
  const destructiveClass = variant.destructive ? "is-destructive" : "is-normal";
  const styleClass = `ios26-btn--${variant.style}`;
  const sizeClass = `ios26-btn--${variant.size}`;
  return `<button type="button" class="ios26-btn ${styleClass} ${sizeClass} ${variant.labelClass} ${enabledClass} ${destructiveClass}" data-node-id="${escapeHtml(entry.id)}" data-name="${escapeHtml(entry.name)}" style="--btn-w:${entry.width}px;--btn-h:${entry.height}px;"${disabledAttr}>${buildButtonContent(variant)}</button>`;
}

function isButtonLikeEntry(entry) {
  const lowerName = entry.name.toLowerCase();
  const isReasonableButtonSize = entry.width <= 140 && entry.height <= 72;
  if (entry.name.includes("Size=")) {
    return isReasonableButtonSize;
  }
  if (entry.name === "Button") {
    return isReasonableButtonSize;
  }
  if (lowerName.includes("button - liquid glass")) {
    return isReasonableButtonSize;
  }
  return false;
}

function buildSpatialKey(entry) {
  const x = Math.round(entry.x * 10) / 10;
  const y = Math.round(entry.y * 10) / 10;
  const w = Math.round(entry.width * 10) / 10;
  const h = Math.round(entry.height * 10) / 10;
  return `${entry.tag}|${entry.name}|${x}|${y}|${w}|${h}`;
}

function findNearestVariant(entry, variantRefs) {
  const direct = parseVariantName(entry.name);
  if (direct) {
    return direct;
  }

  const exactSize = variantRefs.filter((candidate) => {
    return Math.abs(candidate.width - entry.width) < 0.6 && Math.abs(candidate.height - entry.height) < 0.6;
  });
  const pool = exactSize.length > 0 ? exactSize : variantRefs;
  if (pool.length === 0) {
    return {
      labelType: "Text",
      style: "borderless",
      size: "medium",
      enabled: true,
      destructive: false,
      labelClass: "ios26-btn--text",
    };
  }
  let best = pool[0];
  let bestScore = Number.POSITIVE_INFINITY;
  for (const candidate of pool) {
    const dx = candidate.x - entry.x;
    const dy = candidate.y - entry.y;
    const score = (dx * dx) + (dy * dy);
    if (score < bestScore) {
      best = candidate;
      bestScore = score;
    }
  }
  return best.variant;
}

function buildButtonSupplementCard(entry, variantRefs) {
  const lowerName = entry.name.toLowerCase();
  const variant = findNearestVariant(entry, variantRefs);
  if (lowerName.includes("liquid glass")) {
    variant.style = "liquid";
    if (lowerName.includes("symbol")) {
      variant.labelType = "Symbol";
      variant.labelClass = "ios26-btn--symbol";
    }
    if (lowerName.includes("text")) {
      variant.labelType = "Text";
      variant.labelClass = "ios26-btn--text";
    }
  }
  return `      <article class="ios26-buttons-supplement-button" data-node-id="${escapeHtml(entry.id)}" data-node-name="${escapeHtml(entry.name)}">
        <div class="ios26-buttons-supplement-button-preview">${buildButtonMarkup(entry, variant)}</div>
        <code>${escapeHtml(entry.id)}</code>
        <p>${escapeHtml(entry.name)}</p>
      </article>`;
}

function buildMetadataSupplementCard(entry) {
  return `      <article class="ios26-buttons-supplement-meta-item" data-node-id="${escapeHtml(entry.id)}" data-node-name="${escapeHtml(entry.name)}">
        <code>${escapeHtml(entry.id)}</code>
        <span>${escapeHtml(entry.name)}</span>
      </article>`;
}

const metadataXml = fs.readFileSync(metadataPath, "utf8");
const entries = parseMetadataEntries(metadataXml);

let html = fs.readFileSync(htmlPath, "utf8");
html = stripRange(html, generatedStart, generatedEnd);
html = stripRange(html, missingAnchorStart, missingAnchorEnd);
html = stripRange(html, metadataAnchorStart, metadataAnchorEnd);

const existingIds = new Set(
  [...html.matchAll(/data-node-id="([^"]+)"/g)].map((match) => match[1]),
);
const missingEntries = entries.filter((entry) => !existingIds.has(entry.id));
const uniqueMissingEntries = [];
const seenSpatial = new Set();
const seenButtonGeometry = new Set();
for (const entry of missingEntries) {
  const isButtonLike = isButtonLikeEntry(entry);
  if (isButtonLike) {
    const gx = Math.round(entry.x * 10) / 10;
    const gy = Math.round(entry.y * 10) / 10;
    const gw = Math.round(entry.width * 10) / 10;
    const gh = Math.round(entry.height * 10) / 10;
    const geometryKey = `${gx}|${gy}|${gw}|${gh}`;
    if (seenButtonGeometry.has(geometryKey)) {
      continue;
    }
    seenButtonGeometry.add(geometryKey);
  }
  const spatialKey = buildSpatialKey(entry);
  if (seenSpatial.has(spatialKey)) {
    continue;
  }
  seenSpatial.add(spatialKey);
  uniqueMissingEntries.push(entry);
}
const variantRefs = entries
  .map((entry) => ({ ...entry, variant: parseVariantName(entry.name) }))
  .filter((entry) => entry.variant !== null);

if (uniqueMissingEntries.length === 0) {
  fs.writeFileSync(htmlPath, html);
  console.log("Buttons metadata coverage sync: no missing nodes.");
  process.exit(0);
}

const missingButtonEntries = uniqueMissingEntries
  .filter((entry) => isButtonLikeEntry(entry))
  .sort((a, b) => (a.y - b.y) || (a.x - b.x));
const missingMetadataEntries = uniqueMissingEntries
  .filter((entry) => !isButtonLikeEntry(entry))
  .sort((a, b) => (a.y - b.y) || (a.x - b.x))
  .slice(0, 240);

const buttonsBody = missingButtonEntries
  .map((entry) => buildButtonSupplementCard(entry, variantRefs))
  .join("\n");

const metadataBody = missingMetadataEntries
  .map((entry) => buildMetadataSupplementCard(entry))
  .join("\n");

const missingById = new Map();
for (const entry of missingEntries) {
  if (!missingById.has(entry.id)) {
    missingById.set(entry.id, entry);
  }
}

const metadataAnchorBody = [...missingById.values()]
  .sort((a, b) => a.id.localeCompare(b.id))
  .map((entry) => `    <span class="ios26-buttons-metadata-anchor" hidden aria-hidden="true" data-node-id="${escapeHtml(entry.id)}" data-node-name="${escapeHtml(entry.name)}"></span>`)
  .join("\n");

const metadataNote = missingMetadataEntries.length === 240
  ? `<p>Showing first ${missingMetadataEntries.length} metadata-only nodes to keep the page responsive.</p>`
  : "";

const generatedBlock = `
  ${generatedStart}
  <article class="ios26-buttons-panel ios26-buttons-panel--supplement" data-node-id="548:35177">
    <header class="ios26-buttons-header">
      <h2>Metadata Sticker Sheet Coverage</h2>
      <p>Auto-generated from saved Figma metadata nodes not already represented in the primary matrix. Missing buttons: ${missingButtonEntries.length}. Metadata-only nodes: ${missingMetadataEntries.length}.</p>
    </header>
    <details class="ios26-buttons-supplement-details">
      <summary>Supplement button nodes (${missingButtonEntries.length})</summary>
      <div class="ios26-buttons-supplement-board">
${buttonsBody}
      </div>
    </details>
    <details class="ios26-buttons-supplement-meta">
      <summary>Metadata-only nodes (${missingMetadataEntries.length})</summary>
      ${metadataNote}
      <div class="ios26-buttons-supplement-meta-grid">
${metadataBody}
      </div>
    </details>
  </article>
  ${generatedEnd}
`;

const metadataAnchorBlock = `
  ${metadataAnchorStart}
${metadataAnchorBody}
  ${metadataAnchorEnd}
`;

const rootCloseIndex = html.lastIndexOf("</section>");
if (rootCloseIndex === -1) {
  throw new Error("Buttons root closing tag not found");
}
const updatedHtml = `${html.slice(0, rootCloseIndex)}${generatedBlock}${metadataAnchorBlock}\n${html.slice(rootCloseIndex)}`;
fs.writeFileSync(htmlPath, updatedHtml);
console.log(`Buttons metadata coverage synced. inserted_nodes=${uniqueMissingEntries.length}`);
