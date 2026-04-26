import {
  copyFileSync,
  cpSync,
  existsSync,
  mkdirSync,
  readdirSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const workflowPath = resolve(root, "figma-artifacts/full-coverage-workflow.json");
const canonicalPath = resolve(root, "figma-artifacts/canonical-nodes.json");
const nativeSharedDir = resolve(root, "figma-artifacts/native");
const previewDir = resolve(root, "preview");
const previewEvidenceDir = resolve(previewDir, "evidence");
const previewEvidenceFigmaDir = resolve(previewEvidenceDir, "figma-artifacts");
const previewEvidenceNativeDir = resolve(previewEvidenceFigmaDir, "native");
const strictExceptionsPath = resolve(root, "figma-artifacts/native/STRICT_EXCEPTIONS.json");
const renderedDir = resolve(previewDir, "rendered");
const renderedSourceDir = resolve(renderedDir, "source");
const strictExceptionsSourcePath = resolve(root, "figma-artifacts/native/STRICT_EXCEPTIONS.json");
const nativeAuditSourcePath = resolve(root, "NATIVE_IMAGE_AUDIT.md");
const visualFidelityReportSourcePath = resolve(root, "figma-artifacts/VISUAL_FIDELITY_REPORT.md");
const visualFidelityJsonSourcePath = resolve(root, "figma-artifacts/visual-fidelity.json");
const renderedSnapshotsDir = resolve(renderedDir, "snapshots");
const renderedSnapshotsBackupDir = resolve(previewDir, ".rendered-snapshots-backup");
const fidelitySnapshotsDir = resolve(renderedDir, "fidelity-snapshots");
const fidelitySnapshotsBackupDir = resolve(previewDir, ".fidelity-snapshots-backup");
const strictExceptions = existsSync(strictExceptionsPath)
  ? JSON.parse(readFileSync(strictExceptionsPath, "utf8"))
  : {};
const assetBackedComponents =
  strictExceptions && typeof strictExceptions === "object" && strictExceptions.assetBackedComponents
    ? strictExceptions.assetBackedComponents
    : {};
const workflow = existsSync(workflowPath)
  ? JSON.parse(readFileSync(workflowPath, "utf8"))
  : null;
const activeCategoryNode = workflow?.activeCategoryNode ?? null;
const canonical = existsSync(canonicalPath)
  ? JSON.parse(readFileSync(canonicalPath, "utf8"))
  : { components: {} };
const sharedCss = existsSync(nativeSharedDir)
  ? readdirSync(nativeSharedDir)
    .filter((name) => /^shared-.*\.css$/.test(name))
    .sort((a, b) => a.localeCompare(b))
    .map((name) => readFileSync(resolve(nativeSharedDir, name), "utf8"))
    .join("\n\n")
  : "";

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function cleanDesignContext(source) {
  const styleNotesIndex = source.indexOf("Style notes from MCP:");
  const withoutNotes = styleNotesIndex >= 0 ? source.slice(0, styleNotesIndex) : source;
  return withoutNotes.trim();
}

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function parseNodeIdFromArtifactPath(relPath) {
  if (!relPath) {
    return null;
  }
  const fileName = relPath.split("/").pop() ?? "";
  const match = fileName.match(/^(\d+)-(\d+)\./);
  if (!match) {
    return null;
  }
  return `${match[1]}:${match[2]}`;
}

function rewriteForSourceArtifacts(content) {
  return String(content)
    .replaceAll('src="../evidence/', 'src="../../evidence/')
    .replaceAll("src='../evidence/", "src='../../evidence/")
    .replaceAll('href="../evidence/', 'href="../../evidence/')
    .replaceAll("href='../evidence/", "href='../../evidence/")
    .replaceAll('url("../evidence/', 'url("../../evidence/')
    .replaceAll("url('../evidence/", "url('../../evidence/");
}

function stableScreenshotNotePath(designPath, variableDefsPath) {
  const source = designPath ?? variableDefsPath;
  if (!source) {
    return null;
  }
  const sourceAbs = resolve(root, source);
  const fileName = source.split("/").pop() ?? "";
  const base = fileName
    .replace(".design-context.txt", "")
    .replace(".variable-defs.json", "");
  const dirRel = source.split("/").slice(0, -1).join("/");
  const candidates = [
    `${dirRel}/${base}.screenshot.pending.txt`,
    `${dirRel}/${base}.screenshot.blocked.txt`,
    `${dirRel}/${base}.screenshot.note.txt`,
  ];
  for (const rel of candidates) {
    if (existsSync(resolve(root, rel))) {
      return rel;
    }
  }
  return existsSync(sourceAbs) ? null : null;
}

function describeCoverage(categoryNodeId, canonicalNodeId, artifactNodeId) {
  if (!artifactNodeId) {
    return {
      key: "unknown",
      label: "unknown node coverage",
    };
  }
  if (artifactNodeId === categoryNodeId) {
    return {
      key: "category-root",
      label: `category root (${artifactNodeId})`,
    };
  }
  if (artifactNodeId === canonicalNodeId) {
    return {
      key: "canonical-node",
      label: `canonical child (${artifactNodeId})`,
    };
  }
  return {
    key: "other-node",
    label: `other node (${artifactNodeId})`,
  };
}

function hasQuotaText(text) {
  return text.includes("reached the Figma MCP tool call limit");
}

function hasInvalidSelectionText(text) {
  return text.includes("You currently have nothing selected");
}

function latestRawPath(nodeId, suffix) {
  const dir = resolve(root, "figma-artifacts", "raw", slugNode(nodeId));
  if (!existsSync(dir)) {
    return null;
  }
  const names = readdirSync(dir)
    .filter((name) => name.endsWith(suffix))
    .sort((a, b) => b.localeCompare(a));
  if (names.length === 0) {
    return null;
  }
  return `figma-artifacts/raw/${slugNode(nodeId)}/${names[0]}`;
}

function latestValidRawDesign(nodeId) {
  const dir = resolve(root, "figma-artifacts", "raw", slugNode(nodeId));
  if (!existsSync(dir)) {
    return null;
  }
  const names = readdirSync(dir)
    .filter((name) => name.endsWith(".get_design_context.txt"))
    .sort((a, b) => b.localeCompare(a));
  for (const name of names) {
    const rel = `figma-artifacts/raw/${slugNode(nodeId)}/${name}`;
    const text = readFileSync(resolve(root, rel), "utf8");
    if (hasQuotaText(text) || hasInvalidSelectionText(text)) {
      continue;
    }
    if (!text.trim()) {
      continue;
    }
    return rel;
  }
  return null;
}

function latestValidRawVariableDefs(nodeId) {
  const dir = resolve(root, "figma-artifacts", "raw", slugNode(nodeId));
  if (!existsSync(dir)) {
    return null;
  }
  const names = readdirSync(dir)
    .filter((name) => name.endsWith(".get_variable_defs.txt"))
    .sort((a, b) => b.localeCompare(a));
  for (const name of names) {
    const rel = `figma-artifacts/raw/${slugNode(nodeId)}/${name}`;
    const text = readFileSync(resolve(root, rel), "utf8");
    if (hasQuotaText(text)) {
      continue;
    }
    try {
      JSON.parse(text);
    } catch {
      continue;
    }
    return rel;
  }
  return null;
}

function isColorValue(value) {
  if (typeof value !== "string") {
    return false;
  }
  const trimmed = value.trim();
  return (
    /^#([0-9a-fA-F]{3,8})$/.test(trimmed) ||
    /^rgba?\(/i.test(trimmed) ||
    /^hsla?\(/i.test(trimmed)
  );
}

function parseModeMap(variableDefsRaw) {
  if (!variableDefsRaw || typeof variableDefsRaw !== "object" || Array.isArray(variableDefsRaw)) {
    return null;
  }
  if (
    variableDefsRaw.modes &&
    typeof variableDefsRaw.modes === "object" &&
    !Array.isArray(variableDefsRaw.modes)
  ) {
    const defaultMode = variableDefsRaw.modes.default ?? {};
    const increasedMode = variableDefsRaw.modes.increasedContrast ?? {};
    return {
      default: defaultMode,
      increasedContrast: increasedMode,
    };
  }
  return {
    default: variableDefsRaw,
    increasedContrast: null,
  };
}

function tokenizeCategory(modeMap, key) {
  const result = [];
  for (const [token, value] of Object.entries(modeMap)) {
    if (!isColorValue(value)) {
      continue;
    }
    if (key === "Section") {
      if (!token.startsWith("Section ")) {
        continue;
      }
    } else if (!token.startsWith(`${key}/`)) {
      continue;
    }
    const label = key === "Section" ? token.replace("Section ", "") : token.slice(key.length + 1);
    result.push({
      token,
      label,
      value,
    });
  }
  result.sort((a, b) => a.token.localeCompare(b.token));
  return result;
}

function renderTokenGroup(modeName, category, tokens) {
  if (tokens.length === 0) {
    return "";
  }
  const cards = tokens
    .map((token) => {
      const swatchId = `${modeName}-${category}-${token.token}`;
      return `<article class="ios26-token-card"><div class="ios26-token-swatch-wrap"><span class="ios26-token-swatch" data-token-id="${escapeHtml(
        swatchId,
      )}" style="--token-color:${escapeHtml(token.value)}"></span></div><p class="ios26-token-name">${escapeHtml(
        token.label,
      )}</p><code class="ios26-token-value">${escapeHtml(token.value)}</code></article>`;
    })
    .join("");
  return `<section class="ios26-token-group"><h4>${escapeHtml(category)}</h4><div class="ios26-token-grid">${cards}</div></section>`;
}

function buildColorsRenderer(variableDefsPath) {
  if (!variableDefsPath) {
    return null;
  }
  const abs = resolve(root, variableDefsPath);
  if (!existsSync(abs)) {
    return null;
  }
  let parsed;
  try {
    parsed = JSON.parse(readFileSync(abs, "utf8"));
  } catch {
    return null;
  }
  const modes = parseModeMap(parsed);
  if (!modes) {
    return null;
  }

  const categories = [
    "Accents",
    "Grays",
    "Labels",
    "Backgrounds",
    "Backgrounds (Grouped)",
    "Separators",
    "Section",
  ];

  function renderMode(name, modeMap) {
    if (!modeMap || typeof modeMap !== "object") {
      return "";
    }
    const groups = categories
      .map((category) => renderTokenGroup(name, category, tokenizeCategory(modeMap, category)))
      .filter(Boolean)
      .join("");
    if (!groups) {
      return "";
    }
    return `<section class="ios26-colors-mode"><h3>${escapeHtml(name === "default" ? "Default" : "Increased Contrast")}</h3>${groups}</section>`;
  }

  const html = `<div class="ios26-colors-root">${renderMode("default", modes.default)}${renderMode(
    "increasedContrast",
    modes.increasedContrast,
  )}</div>`;

  const css = `.ios26-colors-root {
  width: 100%;
  display: grid;
  gap: 16px;
}

.ios26-colors-mode {
  border: 1px solid #d8dce3;
  border-radius: 12px;
  padding: 12px;
  background: #f5f5f7;
}

.ios26-colors-mode h3 {
  margin: 0 0 8px;
  font: 590 18px/22px "SF Pro Text", "SF Pro", sans-serif;
}

.ios26-token-group {
  margin: 0 0 10px;
}

.ios26-token-group h4 {
  margin: 0 0 6px;
  font: 590 13px/18px "SF Pro Text", "SF Pro", sans-serif;
}

.ios26-token-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
  gap: 8px;
}

.ios26-token-card {
  border: 1px solid #d8dce3;
  border-radius: 8px;
  padding: 6px;
  background: #fff;
}

.ios26-token-swatch-wrap {
  width: 100%;
  aspect-ratio: 1 / 1;
  border-radius: 6px;
  border: 1px solid #cfd4dc;
  background-image: linear-gradient(45deg, #efefef 25%, transparent 25%),
    linear-gradient(-45deg, #efefef 25%, transparent 25%),
    linear-gradient(45deg, transparent 75%, #efefef 75%),
    linear-gradient(-45deg, transparent 75%, #efefef 75%);
  background-size: 16px 16px;
  background-position: 0 0, 0 8px, 8px -8px, -8px 0;
}

.ios26-token-swatch {
  display: block;
  width: 100%;
  height: 100%;
  border-radius: 6px;
  background: var(--token-color);
}

.ios26-token-name {
  margin: 6px 0 2px;
  font: 400 12px/16px "SF Pro Text", "SF Pro", sans-serif;
  color: #111;
}

.ios26-token-value {
  font: 400 11px/14px "SF Mono", ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  color: #3b4350;
}`;

  return { html, css };
}

function buildNativeFileRenderer(componentId) {
  const baseDir = resolve(root, "figma-artifacts", "native");
  const htmlPath = resolve(baseDir, `${componentId}.html`);
  const cssPath = resolve(baseDir, `${componentId}.css`);
  if (!existsSync(htmlPath) || !existsSync(cssPath)) {
    return null;
  }
  return {
    html: readFileSync(htmlPath, "utf8"),
    css: readFileSync(cssPath, "utf8"),
  };
}

if (existsSync(renderedSnapshotsDir)) {
  rmSync(renderedSnapshotsBackupDir, { recursive: true, force: true });
  cpSync(renderedSnapshotsDir, renderedSnapshotsBackupDir, { recursive: true });
}
if (existsSync(fidelitySnapshotsDir)) {
  rmSync(fidelitySnapshotsBackupDir, { recursive: true, force: true });
  cpSync(fidelitySnapshotsDir, fidelitySnapshotsBackupDir, { recursive: true });
}

rmSync(renderedDir, { recursive: true, force: true });
mkdirSync(renderedDir, { recursive: true });
mkdirSync(renderedSourceDir, { recursive: true });

if (existsSync(renderedSnapshotsBackupDir)) {
  cpSync(renderedSnapshotsBackupDir, renderedSnapshotsDir, { recursive: true });
  rmSync(renderedSnapshotsBackupDir, { recursive: true, force: true });
}
if (existsSync(fidelitySnapshotsBackupDir)) {
  cpSync(fidelitySnapshotsBackupDir, fidelitySnapshotsDir, { recursive: true });
  rmSync(fidelitySnapshotsBackupDir, { recursive: true, force: true });
}

mkdirSync(previewEvidenceFigmaDir, { recursive: true });
mkdirSync(previewEvidenceNativeDir, { recursive: true });
if (existsSync(strictExceptionsSourcePath)) {
  copyFileSync(
    strictExceptionsSourcePath,
    resolve(previewEvidenceNativeDir, "STRICT_EXCEPTIONS.json"),
  );
}
if (existsSync(nativeAuditSourcePath)) {
  copyFileSync(nativeAuditSourcePath, resolve(previewEvidenceFigmaDir, "NATIVE_IMAGE_AUDIT.md"));
}
if (existsSync(visualFidelityReportSourcePath)) {
  copyFileSync(
    visualFidelityReportSourcePath,
    resolve(previewEvidenceFigmaDir, "VISUAL_FIDELITY_REPORT.md"),
  );
}
if (existsSync(visualFidelityJsonSourcePath)) {
  copyFileSync(
    visualFidelityJsonSourcePath,
    resolve(previewEvidenceFigmaDir, "visual-fidelity.json"),
  );
}

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
if (!Array.isArray(catalog)) {
  throw new Error("catalog.json must be an array");
}

const rows = [];

for (const item of catalog) {
  const canonicalNode = canonical.components?.[item.figmaNodeId]?.canonicalNode ?? item.figmaNodeId;
  let designPath = item.artifacts?.designContextPath;
  let screenshotPath = item.artifacts?.screenshotPath;
  let variableDefsPath = item.artifacts?.variableDefsPath;
  let renderState = item.status;

  if (item.status !== "verified") {
    const rawDesignPath = latestValidRawDesign(canonicalNode);
    const rawScreenshotPath = latestRawPath(canonicalNode, ".get_screenshot.png");
    const rawVarsPath = latestValidRawVariableDefs(canonicalNode);
    const stableDesignReady = Boolean(designPath && existsSync(resolve(root, designPath)));
    const stableScreenshotReady = Boolean(screenshotPath && existsSync(resolve(root, screenshotPath)));
    const stableVarsReady = Boolean(variableDefsPath && existsSync(resolve(root, variableDefsPath)));
    const effectiveDesignPath = stableDesignReady ? designPath : rawDesignPath;
    const effectiveScreenshotPath = stableScreenshotReady ? screenshotPath : rawScreenshotPath;
    const effectiveVarsPath = stableVarsReady ? variableDefsPath : rawVarsPath;

    if (effectiveDesignPath) {
      designPath = effectiveDesignPath;
      screenshotPath = effectiveScreenshotPath;
      variableDefsPath = effectiveVarsPath;
      if (item.figmaNodeId === activeCategoryNode) {
        renderState = effectiveScreenshotPath
          ? "in_progress"
          : "in_progress (awaiting screenshot)";
      } else {
        renderState = effectiveScreenshotPath
          ? "unverified (artifacts ready)"
          : "unverified (awaiting screenshot)";
      }
    } else if (item.figmaNodeId === activeCategoryNode) {
      renderState = "in_progress (awaiting MCP artifacts)";
    } else {
      renderState = "unverified (awaiting MCP artifacts)";
    }
  }

  const nativeRenderer = buildNativeFileRenderer(item.id)
    ?? (item.id === "colors" ? buildColorsRenderer(variableDefsPath) : null);
  const hasDesignContext = Boolean(designPath && existsSync(resolve(root, designPath)));
  const screenshotHref = screenshotPath ? `../evidence/${screenshotPath}` : null;
  const screenshotNotePath = stableScreenshotNotePath(designPath, variableDefsPath)
    ?? latestRawPath(canonicalNode, ".get_screenshot.txt");
  const screenshotNoteHref = screenshotNotePath ? `../evidence/${screenshotNotePath}` : null;
  const artifactNodeId = parseNodeIdFromArtifactPath(designPath)
    ?? parseNodeIdFromArtifactPath(screenshotPath)
    ?? parseNodeIdFromArtifactPath(variableDefsPath);
  const coverage = describeCoverage(item.figmaNodeId, canonicalNode, artifactNodeId);
  const strictExceptionLabel = assetBackedComponents[item.id] ? "asset-backed exception" : "none";

  if (!hasDesignContext && !nativeRenderer && !screenshotHref) {
    rows.push(`<tr><td>${escapeHtml(item.category)}</td><td><code>${escapeHtml(item.figmaNodeId)}</code></td><td>${escapeHtml(renderState)}</td><td>${escapeHtml(coverage.label)}</td><td>${escapeHtml(strictExceptionLabel)}</td><td>pending verification</td></tr>`);
    continue;
  }

  const designHref = hasDesignContext ? `../evidence/${designPath}` : null;
  const varsHref = variableDefsPath ? `../evidence/${variableDefsPath}` : null;
  const renderer = nativeRenderer ?? {
    html: screenshotHref
      ? `<figure class="ios26-fidelity-figure"><img class="ios26-fidelity-shot" src="${escapeHtml(
          screenshotHref,
        )}" alt="${escapeHtml(item.category)} screenshot reference" /></figure>`
      : `<p class="ios26-no-render">Awaiting strict native HTML/CSS translation for this category.</p>`,
    css: `.ios26-fidelity-figure {
  margin: 0;
  width: 100%;
  display: grid;
  place-items: center;
}

.ios26-fidelity-shot {
  max-width: 100%;
  border: 1px solid #d8dce3;
  border-radius: 8px;
  background: #fff;
}

.ios26-no-render {
  margin: 0;
  color: #4f5661;
  font: 400 14px/20px "SF Pro Text", "SF Pro", sans-serif;
}`,
  };

  const cleanedContext = hasDesignContext
    ? cleanDesignContext(readFileSync(resolve(root, designPath), "utf8"))
    : "No saved design-context artifact available for this category yet.";
  const artifactLinks = [
    designHref
      ? `<a href="${escapeHtml(designHref)}" target="_blank" rel="noreferrer">Open design-context</a>`
      : null,
    varsHref
      ? `<a href="${escapeHtml(varsHref)}" target="_blank" rel="noreferrer">Open variable-defs</a>`
      : null,
  ].filter(Boolean).join(" · ");

  const pageRelPath = `${item.id}.html`;
  const pageAbsPath = resolve(renderedDir, pageRelPath);

  const htmlSourceRelPath = `source/${item.id}.native.html`;
  const cssSourceRelPath = `source/${item.id}.native.css`;
  const renderedSnapshotRelPath = `snapshots/${item.id}.png`;
  const renderedSnapshotAbsPath = resolve(renderedDir, renderedSnapshotRelPath);
  const hasRenderedSnapshot = existsSync(renderedSnapshotAbsPath);
  const sourceHtml = rewriteForSourceArtifacts(renderer.html);
  const sourceCss = rewriteForSourceArtifacts(renderer.css);
  const composedCss = [sharedCss, sourceCss].filter(Boolean).join("\n\n");
  writeFileSync(resolve(renderedDir, cssSourceRelPath), `${composedCss}\n`, "utf8");
  const sourcePreviewHtml = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${escapeHtml(item.category)} - Native Source Preview</title>
    <style>
      body {
        margin: 0;
        padding: 16px;
        background: #f7f8fa;
        color: #111;
        font-family: "SF Pro Text", "SF Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      }
      .ios26-source-preview {
        min-height: calc(100vh - 32px);
        display: grid;
        place-items: start center;
      }
      ${composedCss}
    </style>
  </head>
  <body>
    <main class="ios26-source-preview">
      ${sourceHtml}
    </main>
  </body>
</html>`;
  writeFileSync(resolve(renderedDir, htmlSourceRelPath), `${sourcePreviewHtml}\n`, "utf8");

  const pageHtml = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${escapeHtml(item.category)} - Native HTML/CSS Render</title>
    <style>
      body { margin: 0; font-family: "SF Pro Text", "Segoe UI", Arial, sans-serif; background: #f7f8fa; color: #111; }
      .layout { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; padding: 20px; }
      .card { background: #fff; border: 1px solid #d8dce3; border-radius: 12px; padding: 14px; }
      h1 { margin: 0 0 8px; font-size: 20px; }
      h2 { margin: 0 0 8px; font-size: 16px; }
      .coverage { margin: 0 0 10px; font-size: 13px; color: #4f5661; }
      pre { margin: 0; white-space: pre-wrap; font-size: 12px; line-height: 1.45; border: 1px solid #d8dce3; border-radius: 8px; padding: 10px; background: #fafbfc; overflow: auto; max-height: 70vh; }
      img { max-width: 100%; border: 1px solid #d8dce3; border-radius: 8px; background: #fff; }
      .component-root { min-height: 140px; display: grid; place-items: center; border: 1px dashed #c4cad3; border-radius: 10px; padding: 12px; background: #fcfdff; overflow: auto; }
      .meta { margin: 0 0 12px; color: #4f5661; font-size: 14px; }
      .links a { margin-right: 10px; }
      body.ios26-fidelity-mode { background: #ffffff; }
      body.ios26-fidelity-mode .layout { display: block; padding: 0; }
      body.ios26-fidelity-mode .card { border: 0; border-radius: 0; background: transparent; padding: 0; box-shadow: none; }
      body.ios26-fidelity-mode .card:first-child { width: fit-content; margin: 0 auto; }
      body.ios26-fidelity-mode .card:last-child { display: none; }
      body.ios26-fidelity-mode h1,
      body.ios26-fidelity-mode h2,
      body.ios26-fidelity-mode .meta,
      body.ios26-fidelity-mode .links,
      body.ios26-fidelity-mode .coverage { display: none; }
      body.ios26-fidelity-mode .component-root {
        min-height: 0;
        border: 0;
        border-radius: 0;
        padding: 0;
        background: transparent;
        overflow: visible;
        display: block;
      }
      body.ios26-fidelity-mode .component-root > * { margin: 0 auto; }
      body.ios26-fidelity-mode .ios26-node-coverage-board,
      body.ios26-fidelity-mode .ios26-node-anchor-ledger,
      body.ios26-fidelity-mode [data-fidelity-ignore="true"] { display: none !important; }
      ${sharedCss}
      ${renderer.css}
      @media (max-width: 960px) { .layout { grid-template-columns: 1fr; } }
    </style>
  </head>
  <body>
    <main class="layout">
      <section class="card">
        <h1>${escapeHtml(item.category)}</h1>
        <p class="meta">Category Node <code>${escapeHtml(item.figmaNodeId)}</code></p>
        <p class="links">
          <a href="${escapeHtml(item.figmaUrl)}" target="_blank" rel="noreferrer">Open in Figma</a>
          <a href="index.html">Back to Render Index</a>
          <a href="../index.html#${escapeHtml(item.id)}">Back to Evidence Index</a>
        </p>
        <h2>${renderState === "verified"
          ? (nativeRenderer ? "Native Render (HTML + CSS)" : "Fidelity Render (Screenshot-backed HTML)")
          : (nativeRenderer ? "Draft Native Render (Unverified)" : "Draft Fidelity Render (Unverified)")}</h2>
        <p class="coverage">Coverage scope: <strong>${escapeHtml(coverage.label)}</strong>${coverage.key === "canonical-node" ? " (not the full category canvas)" : ""}</p>
        <p class="coverage">Strict exception: <strong>${escapeHtml(strictExceptionLabel)}</strong></p>
        <div class="component-root">${renderer.html}</div>
      </section>
      <section class="card">
        <h2>Saved Artifacts</h2>
        ${screenshotHref
          ? `<p><a href="${escapeHtml(screenshotHref)}" target="_blank" rel="noreferrer">Open screenshot</a></p><img src="${escapeHtml(screenshotHref)}" alt="${escapeHtml(item.category)} screenshot" />`
          : screenshotNoteHref
            ? `<p>No screenshot image available. <a href="${escapeHtml(screenshotNoteHref)}" target="_blank" rel="noreferrer">Open screenshot status note</a></p>`
            : "<p>No screenshot artifact available.</p>"}
        ${artifactLinks ? `<p>${artifactLinks}</p>` : "<p>No design-context or variable-defs artifact available.</p>"}
        <p><a href="${escapeHtml(htmlSourceRelPath)}" target="_blank" rel="noreferrer">Open native HTML source</a> · <a href="${escapeHtml(cssSourceRelPath)}" target="_blank" rel="noreferrer">Open native CSS source</a>${hasRenderedSnapshot ? ` · <a href="${escapeHtml(renderedSnapshotRelPath)}" target="_blank" rel="noreferrer">Open local render snapshot</a>` : ""}</p>
        <h2>Saved Figma Code</h2>
        <pre>${escapeHtml(cleanedContext)}</pre>
      </section>
    </main>
    <script>
      (function applyFidelityView() {
        try {
          var params = new URLSearchParams(window.location.search || "");
          if (params.get("view") === "fidelity") {
            document.body.classList.add("ios26-fidelity-mode");
          }
        } catch (_error) {
          // no-op
        }
      })();
    </script>
  </body>
</html>`;

  writeFileSync(pageAbsPath, pageHtml, "utf8");

  const snapshotCell = hasRenderedSnapshot
    ? `<a href="${escapeHtml(renderedSnapshotRelPath)}" target="_blank" rel="noreferrer">open snapshot</a>`
    : "-";
  rows.push(`<tr><td>${escapeHtml(item.category)}</td><td><code>${escapeHtml(item.figmaNodeId)}</code></td><td>${escapeHtml(renderState)}</td><td>${escapeHtml(coverage.label)}</td><td>${escapeHtml(strictExceptionLabel)}</td><td><a href="${escapeHtml(pageRelPath)}">open render</a></td><td>${snapshotCell}</td></tr>`);
}

const indexHtml = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>ios-26 Native Render Index</title>
    <style>
      body { margin: 0; font-family: "SF Pro Text", "Segoe UI", Arial, sans-serif; background: #f7f8fa; color: #111; }
      main { padding: 20px; }
      .card { background: #fff; border: 1px solid #d8dce3; border-radius: 12px; padding: 14px; }
      table { width: 100%; border-collapse: collapse; }
      th, td { text-align: left; padding: 8px; border-bottom: 1px solid #e4e7ec; font-size: 14px; }
      h1 { margin: 0 0 10px; font-size: 20px; }
      p { margin: 0 0 12px; color: #4f5661; }
    </style>
  </head>
  <body>
    <main>
      <section class="card">
        <h1>ios-26 Native HTML/CSS Render Index</h1>
        <p>Verified categories render from saved artifacts. The active in-progress category may also appear as an explicitly marked draft when raw design-context is present, even if screenshot evidence is still pending.</p>
        <p><a href="../index.html">Open evidence index</a></p>
        <p><a href="../docs/STRICT_STATUS.md" target="_blank" rel="noreferrer">Strict status</a> · <a href="../docs/RELEASE_INVENTORY.md" target="_blank" rel="noreferrer">Release inventory</a> · <a href="../docs/RESUME_QUEUE.md" target="_blank" rel="noreferrer">Resume queue</a></p>
        <p><a href="../evidence/figma-artifacts/NATIVE_IMAGE_AUDIT.md" target="_blank" rel="noreferrer">Native image audit</a> · <a href="../evidence/figma-artifacts/native/STRICT_EXCEPTIONS.json" target="_blank" rel="noreferrer">Strict exceptions</a></p>
        <p><a href="snapshots/SNAPSHOT_REPORT.md" target="_blank" rel="noreferrer">Rendered snapshots report</a> · <a href="snapshots/index.json" target="_blank" rel="noreferrer">Rendered snapshots manifest</a> · <a href="fidelity-snapshots/SNAPSHOT_REPORT.md" target="_blank" rel="noreferrer">Fidelity snapshots report</a> · <a href="../evidence/figma-artifacts/VISUAL_FIDELITY_REPORT.md" target="_blank" rel="noreferrer">Visual fidelity report</a></p>
        <table>
          <thead>
            <tr><th>Category</th><th>Node</th><th>Status</th><th>Coverage</th><th>Exception</th><th>Render</th><th>Snapshot</th></tr>
          </thead>
          <tbody>
            ${rows.join("\n")}
          </tbody>
        </table>
      </section>
    </main>
  </body>
</html>`;

writeFileSync(resolve(renderedDir, "index.html"), indexHtml, "utf8");

console.log(`Native rendered HTML pages generated: ${resolve(renderedDir, "index.html")}`);
