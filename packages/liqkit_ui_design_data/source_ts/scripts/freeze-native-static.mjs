import fs from "node:fs/promises";
import path from "node:path";

const root = "/Users/ahmedomar/Documents/WebCardFight/ios-26";
const nativeDir = path.join(root, "figma-artifacts/native");
const artifactsDir = path.join(root, "figma-artifacts");

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function toIconLabel(iconKey) {
  const normalized = String(iconKey || "")
    .replace(/ITunes/g, "iTunes")
    .replace(/Tv/g, "TV")
    .replace(/Airdrop/g, "AirDrop")
    .replace(/FindMy/g, "Find My")
    .replace(/FaceTime/g, "FaceTime")
    .replace(/VoiceMemos/g, "Voice Memos");
  return normalized
    .replace(/([a-z])([A-Z])/g, "$1 $2")
    .replace(/\bi Tunes\b/g, "iTunes")
    .replace(/\bAir Drop\b/g, "AirDrop")
    .replace(/\bFace Time\b/g, "FaceTime")
    .replace(/\s+/g, " ")
    .trim();
}

function parseIconEntry(name) {
  const match = String(name || "").match(/^imgIcon(.+)Mode(Default|Dark|ClearLight)$/);
  if (!match) return null;
  return {
    iconKey: match[1],
    iconLabel: toIconLabel(match[1]),
    modeKey: match[2],
    modeLabel: match[2] === "Default" ? "Default" : match[2] === "Dark" ? "Dark" : "Clear Light",
  };
}

async function freezeAppIcons() {
  const assetMapPath = path.join(artifactsDir, "assets/app-icons/asset-map.json");
  const raw = JSON.parse(await fs.readFile(assetMapPath, "utf8"));
  const byIcon = new Map();

  for (const asset of raw.assets || []) {
    if (!asset || asset.status !== "ok" || !asset.name || !asset.file) continue;
    const parsed = parseIconEntry(asset.name);
    if (!parsed) continue;
    if (!byIcon.has(parsed.iconKey)) {
      byIcon.set(parsed.iconKey, { key: parsed.iconKey, label: parsed.iconLabel, modes: {} });
    }
    byIcon.get(parsed.iconKey).modes[parsed.modeKey] = {
      file: asset.file,
      label: parsed.modeLabel,
    };
  }

  const icons = [...byIcon.values()].sort((a, b) => a.label.localeCompare(b.label));
  const modeCell = (icon, modeKey) => {
    const mode = icon.modes[modeKey];
    if (!mode) {
      return `<figure class="ios26-app-icons-mode is-missing"><p>Missing</p></figure>`;
    }
    const assetSrc = `/evidence/figma-artifacts/assets/app-icons/${mode.file}`;
    const alt = `${icon.label} ${mode.label}`;
    return [
      `<figure class="ios26-app-icons-mode">`,
      `<img class="ios26-app-icons-image" src="${escapeHtml(assetSrc)}" alt="${escapeHtml(alt)}" loading="lazy" decoding="async" />`,
      `<figcaption>${escapeHtml(mode.label)}</figcaption>`,
      `</figure>`,
    ].join("");
  };

  const cards = icons
    .map(
      (icon) =>
        `<article class="ios26-app-icons-card"><h4>${escapeHtml(icon.label)}</h4><div class="ios26-app-icons-modes">${modeCell(icon, "Default")}${modeCell(icon, "Dark")}${modeCell(icon, "ClearLight")}</div></article>`,
    )
    .join("\n");

  const html = [
    `<section class="ios26-app-icons-root" data-node-id="507:24671" aria-label="App icons">`,
    `<section class="ios26-app-icons-grid" aria-label="App icon variants">${cards}</section>`,
    `</section>`,
    "",
  ].join("\n");

  await fs.writeFile(path.join(nativeDir, "app-icons.html"), html, "utf8");

  let css = await fs.readFile(path.join(nativeDir, "app-icons.css"), "utf8");
  css = css.replace(/\.ios26-app-icons-loading[\s\S]*?}\n\n/g, "");
  css = css.replace(/\.ios26-app-icons-head[\s\S]*?\.ios26-app-icons-links a \{[\s\S]*?}\n\n/, "");
  css = css.replace(/\.ios26-app-icons-mode img \{[\s\S]*?}\n\n/g, "");
  css = css.replace(/\.ios26-app-icons-image \{[\s\S]*?}\n\n/g, "");
  css += `\n.ios26-app-icons-image {\n  width: 66px;\n  height: 66px;\n  border-radius: 14px;\n  display: block;\n  object-fit: cover;\n}\n`;
  await fs.writeFile(path.join(nativeDir, "app-icons.css"), css, "utf8");
}

function parseSections(text) {
  const sections = [...text.matchAll(/<section\s+id="([^"]+)"\s+name="([^"]+)"[^>]*>([\s\S]*?)<\/section>/g)];
  return sections.map((m) => ({ id: m[1], name: m[2], body: m[3] || "" }));
}

function parseNodes(sectionBody) {
  const nodes = [...sectionBody.matchAll(/<(frame|symbol)\s+id="([^"]+)"\s+name="([^"]+)"\s+x="([^"]+)"\s+y="([^"]+)"\s+width="([^"]+)"\s+height="([^"]+)"\s*\/>/g)];
  return nodes.map((m) => ({ kind: m[1], id: m[2], name: m[3], x: m[4], y: m[5], width: m[6], height: m[7] }));
}

async function freezeExamples() {
  const text = await fs.readFile(path.join(artifactsDir, "examples/0-3329.design-context.txt"), "utf8");
  const sections = [];
  const seenSectionIds = new Set();
  for (const section of parseSections(text)) {
    if (seenSectionIds.has(section.id)) continue;
    seenSectionIds.add(section.id);
    sections.push(section);
    if (sections.length >= 8) break;
  }

  const sectionHtml = sections
    .map((section) => {
      const nodes = parseNodes(section.body).slice(0, 40);
      const nodesHtml = nodes
        .map(
          (node) =>
            `<article class="ios26-examples-item"><p class="ios26-examples-item-name">${escapeHtml(node.name)}</p><p class="ios26-examples-item-meta"><code>${escapeHtml(node.id)}</code> · ${escapeHtml(node.kind)}</p><p class="ios26-examples-item-meta">x=${escapeHtml(node.x)}, y=${escapeHtml(node.y)}, w=${escapeHtml(node.width)}, h=${escapeHtml(node.height)}</p></article>`,
        )
        .join("");
      return `<section class="ios26-examples-section"><h4>${escapeHtml(section.name)}</h4><p class="ios26-examples-section-meta"><code>${escapeHtml(section.id)}</code> · nodes: ${parseNodes(section.body).length}</p><div class="ios26-examples-grid">${nodesHtml}</div></section>`;
    })
    .join("\n");

  const html = [
    `<section class="ios26-examples-root" data-node-id="0:3329" aria-label="Examples">`,
    `<div class="ios26-examples-sections">${sectionHtml}</div>`,
    `</section>`,
    "",
  ].join("\n");

  await fs.writeFile(path.join(nativeDir, "examples.html"), html, "utf8");
}

function isColorValue(value) {
  if (typeof value !== "string") return false;
  const trimmed = value.trim();
  return /^#([0-9a-fA-F]{3,8})$/.test(trimmed) || /^rgba?\(/i.test(trimmed) || /^hsla?\(/i.test(trimmed);
}

function tokenizeCategory(modeMap, key) {
  const result = [];
  for (const [token, value] of Object.entries(modeMap || {})) {
    if (!isColorValue(value)) continue;
    if (key === "Section") {
      if (!token.startsWith("Section ")) continue;
    } else if (!token.startsWith(key + "/")) {
      continue;
    }
    const label = key === "Section" ? token.replace("Section ", "") : token.slice(key.length + 1);
    result.push({ token, label, value });
  }
  result.sort((a, b) => a.token.localeCompare(b.token));
  return result;
}

function renderColorsMode(name, modeMap) {
  const groups = ["Accents", "Grays", "Labels", "Backgrounds", "Backgrounds (Grouped)", "Separators", "Section"]
    .map((category) => ({ category, items: tokenizeCategory(modeMap, category) }))
    .filter((group) => group.items.length > 0);

  if (!groups.length) return "";
  const groupsHtml = groups
    .map((group) => {
      const items = group.items
        .map(
          (item) =>
            `<article class="ios26-colors-card"><span class="ios26-colors-swatch-wrap"><span class="ios26-colors-swatch" style="--token-color:${escapeHtml(item.value)}"></span></span><p class="ios26-colors-label">${escapeHtml(item.label)}</p><code class="ios26-colors-value">${escapeHtml(item.value)}</code></article>`,
        )
        .join("");
      return `<section class="ios26-colors-group"><h4>${escapeHtml(group.category)}</h4><div class="ios26-colors-grid">${items}</div></section>`;
    })
    .join("");

  const modeTitle = name === "default" ? "Default" : "Increased Contrast";
  return `<section class="ios26-colors-mode"><h3>${modeTitle}</h3>${groupsHtml}</section>`;
}

async function freezeColors() {
  const json = JSON.parse(await fs.readFile(path.join(artifactsDir, "colors/0-1746.variable-defs.json"), "utf8"));
  const modes = json && json.modes ? json.modes : { default: json, increasedContrast: null };
  const html = [
    `<section class="ios26-colors-root" data-node-id="0:1746" aria-label="Colors">`,
    renderColorsMode("default", modes.default),
    renderColorsMode("increasedContrast", modes.increasedContrast),
    `</section>`,
    "",
  ].join("\n");
  await fs.writeFile(path.join(nativeDir, "colors.html"), html, "utf8");
}

async function freezeKitHelpers() {
  const html = `<section class="ios26-kithelpers-page" data-node-id="507:29124" aria-label="Kit Helpers">\n  <div class="ios26-kithelpers-component-header" data-node-id="507:29149">\n    <h3 class="ios26-kithelpers-title" data-node-id="507:29150">Component name</h3>\n    <p class="ios26-kithelpers-description" data-node-id="507:29151">Description</p>\n  </div>\n</section>\n`;
  await fs.writeFile(path.join(nativeDir, "kit-helpers.html"), html, "utf8");

  let css = await fs.readFile(path.join(nativeDir, "kit-helpers.css"), "utf8");
  css = css.replace(/\.ios26-kithelpers-links[\s\S]*$/m, "");
  await fs.writeFile(path.join(nativeDir, "kit-helpers.css"), css, "utf8");
}

await freezeAppIcons();
await freezeExamples();
await freezeColors();
await freezeKitHelpers();

console.log("Frozen native static files: app-icons, examples, colors, kit-helpers");
