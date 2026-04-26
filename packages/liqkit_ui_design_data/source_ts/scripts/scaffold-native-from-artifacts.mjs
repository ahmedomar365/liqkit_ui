import { existsSync, mkdirSync, readFileSync, readdirSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const verificationPath = resolve(root, "figma-artifacts/verification.json");
const canonicalPath = resolve(root, "figma-artifacts/canonical-nodes.json");
const nativeDir = resolve(root, "figma-artifacts/native");

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function hasQuotaText(text) {
  return text.includes("reached the Figma MCP tool call limit");
}

function hasInvalidSelectionText(text) {
  return text.includes("You currently have nothing selected");
}

function latestValidRawPath(rootDir, nodeId, suffix, validator = null) {
  const dir = resolve(rootDir, "figma-artifacts", "raw", slugNode(nodeId));
  if (!existsSync(dir)) {
    return null;
  }
  const names = readdirSync(dir)
    .filter((name) => name.endsWith(suffix))
    .sort((a, b) => b.localeCompare(a));
  for (const name of names) {
    const rel = `figma-artifacts/raw/${slugNode(nodeId)}/${name}`;
    if (!validator) {
      return rel;
    }
    const content = readFileSync(resolve(rootDir, rel), "utf8");
    if (validator(content)) {
      return rel;
    }
  }
  return null;
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
const verification = JSON.parse(readFileSync(verificationPath, "utf8"));
const canonical = existsSync(canonicalPath)
  ? JSON.parse(readFileSync(canonicalPath, "utf8"))
  : { components: {} };

mkdirSync(nativeDir, { recursive: true });

let created = 0;
let skippedExisting = 0;

for (const item of catalog) {
  const htmlPath = resolve(nativeDir, `${item.id}.html`);
  const cssPath = resolve(nativeDir, `${item.id}.css`);
  if (existsSync(htmlPath) && existsSync(cssPath)) {
    skippedExisting += 1;
    continue;
  }

  const entry = verification.components?.[item.figmaNodeId] ?? {};
  const canonicalNode = canonical.components?.[item.figmaNodeId]?.canonicalNode ?? item.figmaNodeId;

  const verifiedScreenshot = entry.artifacts?.screenshotPath;
  const rawScreenshot = latestValidRawPath(root, canonicalNode, ".get_screenshot.png");
  const screenshotPath = verifiedScreenshot ?? rawScreenshot;

  const verifiedDesign = entry.artifacts?.designContextPath;
  const rawDesign = latestValidRawPath(
    root,
    canonicalNode,
    ".get_design_context.txt",
    (content) => !hasQuotaText(content) && !hasInvalidSelectionText(content) && content.trim().length > 0,
  );
  const designPath = verifiedDesign ?? rawDesign;

  const statusText = screenshotPath
    ? "screenshot-backed"
    : designPath
      ? "design-context-ready"
      : "awaiting-mcp-artifacts";

  const html = screenshotPath
    ? `<section class="ios26-fidelity-native" data-node-id="${escapeHtml(item.figmaNodeId)}" aria-label="${escapeHtml(item.category)}">\n  <figure class="ios26-fidelity-native-frame">\n    <img src="../evidence/${escapeHtml(screenshotPath)}" alt="${escapeHtml(item.category)} screenshot from Figma" />\n    <figcaption>${escapeHtml(item.category)} - ${escapeHtml(statusText)}</figcaption>\n  </figure>\n</section>\n`
    : `<section class="ios26-fidelity-native ios26-fidelity-native--missing" data-node-id="${escapeHtml(item.figmaNodeId)}" aria-label="${escapeHtml(item.category)}">\n  <h3>${escapeHtml(item.category)}</h3>\n  <p>No saved screenshot artifact yet. Status: ${escapeHtml(statusText)}.</p>\n</section>\n`;

  const css = `.ios26-fidelity-native {\n  width: min(1210px, 100%);\n  display: grid;\n  place-items: center;\n}\n\n.ios26-fidelity-native-frame {\n  margin: 0;\n  width: 100%;\n  border: 1px solid #d8dce3;\n  border-radius: 12px;\n  overflow: hidden;\n  background: #fff;\n}\n\n.ios26-fidelity-native-frame img {\n  display: block;\n  width: 100%;\n  height: auto;\n}\n\n.ios26-fidelity-native-frame figcaption {\n  padding: 8px 10px;\n  border-top: 1px solid #e4e7ec;\n  color: #4f5661;\n  font: 400 12px/16px "SF Pro Text", "SF Pro", sans-serif;\n}\n\n.ios26-fidelity-native--missing {\n  border: 1px dashed #c4cad3;\n  border-radius: 12px;\n  background: #fafbfc;\n  padding: 16px;\n  color: #1b1f27;\n  font: 400 14px/20px "SF Pro Text", "SF Pro", sans-serif;\n}\n\n.ios26-fidelity-native--missing h3 {\n  margin: 0 0 8px;\n  font: 590 16px/22px "SF Pro Text", "SF Pro", sans-serif;\n}\n\n.ios26-fidelity-native--missing p {\n  margin: 0;\n}\n`;

  if (!existsSync(htmlPath)) {
    writeFileSync(htmlPath, html, "utf8");
  }
  if (!existsSync(cssPath)) {
    writeFileSync(cssPath, css, "utf8");
  }
  created += 1;
}

console.log(`Native scaffold complete. created=${created} skippedExisting=${skippedExisting}`);
