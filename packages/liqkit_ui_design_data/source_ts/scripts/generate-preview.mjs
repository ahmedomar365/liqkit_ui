import { copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, extname, resolve } from "node:path";

import { componentCatalog, renderGlobalStyles } from "../packages/components-html/dist/index.js";

const previewDir = resolve(process.cwd(), "preview");
const evidenceDir = resolve(previewDir, "evidence");
const outputPath = resolve(previewDir, "index.html");
const fullWorkflowPath = resolve(process.cwd(), "figma-artifacts/full-coverage-workflow.json");
const canonicalPath = resolve(process.cwd(), "figma-artifacts/canonical-nodes.json");
const fullWorkflow = existsSync(fullWorkflowPath)
  ? JSON.parse(readFileSync(fullWorkflowPath, "utf8"))
  : null;
const canonical = existsSync(canonicalPath)
  ? JSON.parse(readFileSync(canonicalPath, "utf8"))
  : { components: {} };
const activeCategoryNode = fullWorkflow?.activeCategoryNode ?? null;
const completedCategoryNodes = new Set(fullWorkflow?.completedCategoryNodes ?? []);

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

function coverageLabel(categoryNodeId, canonicalNodeId, artifactNodeId) {
  if (!artifactNodeId) {
    return "unknown";
  }
  if (artifactNodeId === categoryNodeId) {
    return "category root";
  }
  if (artifactNodeId === canonicalNodeId) {
    return `canonical child (${artifactNodeId})`;
  }
  return `other node (${artifactNodeId})`;
}

function latestRawRelPath(nodeId, suffix) {
  if (!nodeId) {
    return null;
  }
  const slug = slugNode(nodeId);
  const dir = resolve(process.cwd(), "figma-artifacts", "raw", slug);
  if (!existsSync(dir)) {
    return null;
  }
  const latest = readdirSync(dir)
    .filter((name) => name.endsWith(suffix))
    .sort((a, b) => b.localeCompare(a))[0];
  if (!latest) {
    return null;
  }
  return `figma-artifacts/raw/${slug}/${latest}`;
}

function artifactPathExists(relPath) {
  if (!relPath) {
    return false;
  }
  return existsSync(resolve(process.cwd(), relPath));
}

function rootMetadataRelPath(component) {
  return `figma-artifacts/${component.id}/${slugNode(component.figmaNodeId)}.metadata.xml`;
}

function escapeHtml(value) {
  const normalized = value ?? "";
  return normalized
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function getArtifactKind(path) {
  const ext = extname(path).toLowerCase();
  if (ext === ".png" || ext === ".jpg" || ext === ".jpeg" || ext === ".gif" || ext === ".webp" || ext === ".svg") {
    return "image";
  }
  return "text";
}

function materializeArtifact(relPath) {
  if (!relPath) {
    return null;
  }

  const sourcePath = resolve(process.cwd(), relPath);
  if (!existsSync(sourcePath)) {
    return {
      relPath,
      previewPath: null,
      kind: "text",
      content: `Missing artifact file: ${relPath}`,
    };
  }

  const kind = getArtifactKind(sourcePath);
  const targetPath = resolve(evidenceDir, relPath);
  mkdirSync(dirname(targetPath), { recursive: true });
  copyFileSync(sourcePath, targetPath);

  return {
    relPath,
    previewPath: `evidence/${relPath}`,
    kind,
    content: kind === "text" ? readFileSync(sourcePath, "utf8") : null,
  };
}

function renderArtifact(name, artifact) {
  if (!artifact) {
    return `<p><strong>${name}:</strong> missing</p>`;
  }

  const link = artifact.previewPath
    ? `<a href="${artifact.previewPath}" target="_blank" rel="noreferrer">open file</a>`
    : "not available";
  if (artifact.kind === "image" && artifact.previewPath) {
    return `<details class="artifact" open><summary>${name} <code>${artifact.relPath}</code> (${link})</summary><img class="artifact-image" src="${artifact.previewPath}" alt="${escapeHtml(name)}" loading="lazy" /></details>`;
  }
  const body = escapeHtml(artifact.content ?? "");
  return `<details class="artifact"><summary>${name} <code>${artifact.relPath}</code> (${link})</summary><pre>${body}</pre></details>`;
}

function mirrorEvidenceTree(relDir) {
  const sourceRoot = resolve(process.cwd(), relDir);
  if (!existsSync(sourceRoot)) {
    return;
  }

  function walk(currentRel) {
    const currentSrc = resolve(sourceRoot, currentRel);
    const entries = readdirSync(currentSrc, { withFileTypes: true });
    for (const entry of entries) {
      const nextRel = currentRel ? `${currentRel}/${entry.name}` : entry.name;
      if (entry.isDirectory()) {
        walk(nextRel);
        continue;
      }
      if (!entry.isFile()) {
        continue;
      }
      const sourcePath = resolve(sourceRoot, nextRel);
      const targetPath = resolve(evidenceDir, relDir, nextRel);
      mkdirSync(dirname(targetPath), { recursive: true });
      copyFileSync(sourcePath, targetPath);
    }
  }

  walk("");
}

function mirrorNativeSharedRuntime() {
  const sourceDir = resolve(process.cwd(), "figma-artifacts", "native");
  if (!existsSync(sourceDir)) {
    return;
  }
  const names = readdirSync(sourceDir)
    .filter((name) => /^shared-.*\.(css|js)$/.test(name))
    .sort((a, b) => a.localeCompare(b));
  for (const name of names) {
    const sourcePath = resolve(sourceDir, name);
    const targetPath = resolve(evidenceDir, "figma-artifacts", "native", name);
    mkdirSync(dirname(targetPath), { recursive: true });
    copyFileSync(sourcePath, targetPath);
  }
}

function mirrorProjectDoc(relPath, outRelPath = relPath) {
  const sourcePath = resolve(process.cwd(), relPath);
  if (!existsSync(sourcePath)) {
    return null;
  }
  const targetPath = resolve(previewDir, outRelPath);
  mkdirSync(dirname(targetPath), { recursive: true });
  copyFileSync(sourcePath, targetPath);
  return outRelPath;
}

function mirrorAbsoluteDirectory(sourceRoot, outRelDir) {
  if (!existsSync(sourceRoot)) {
    return null;
  }

  function walk(currentRel) {
    const currentSrc = resolve(sourceRoot, currentRel);
    const entries = readdirSync(currentSrc, { withFileTypes: true });
    for (const entry of entries) {
      const nextRel = currentRel ? `${currentRel}/${entry.name}` : entry.name;
      if (entry.isDirectory()) {
        walk(nextRel);
        continue;
      }
      if (!entry.isFile()) {
        continue;
      }
      const sourcePath = resolve(sourceRoot, nextRel);
      const targetPath = resolve(previewDir, outRelDir, nextRel);
      mkdirSync(dirname(targetPath), { recursive: true });
      copyFileSync(sourcePath, targetPath);
    }
  }

  walk("");
  return `${outRelDir}/index.html`;
}

mkdirSync(previewDir, { recursive: true });
mkdirSync(evidenceDir, { recursive: true });
mirrorEvidenceTree("figma-artifacts/assets");
mirrorEvidenceTree("figma-artifacts/text-fields/states");
mirrorEvidenceTree("figma-artifacts/toggles/states");
mirrorNativeSharedRuntime();
const strictStatusDoc = mirrorProjectDoc("STRICT_STATUS.md", "docs/STRICT_STATUS.md");
const releaseInventoryDoc = mirrorProjectDoc("RELEASE_INVENTORY.md", "docs/RELEASE_INVENTORY.md");
const resumeQueueDoc = mirrorProjectDoc("figma-artifacts/RESUME_QUEUE.md", "docs/RESUME_QUEUE.md");
const mcpRecaptureQueueDoc = mirrorProjectDoc(
  "figma-artifacts/MCP_RECAPTURE_QUEUE.md",
  "docs/MCP_RECAPTURE_QUEUE.md",
);
const nativeImageAuditDoc = mirrorProjectDoc("NATIVE_IMAGE_AUDIT.md", "docs/NATIVE_IMAGE_AUDIT.md");
const fullMetadataCoverageDoc = mirrorProjectDoc(
  "figma-artifacts/FULL_METADATA_COVERAGE.md",
  "docs/FULL_METADATA_COVERAGE.md",
);
const evidenceCompletenessDoc = mirrorProjectDoc(
  "figma-artifacts/EVIDENCE_COMPLETENESS.md",
  "docs/EVIDENCE_COMPLETENESS.md",
);
const assetSyncSummaryDoc = mirrorProjectDoc(
  "figma-artifacts/assets/ASSET_SYNC_SUMMARY.md",
  "docs/ASSET_SYNC_SUMMARY.md",
);
const appleSolidDemo = mirrorProjectDoc(
  "AppleDesignDemo/plain-demo.html",
  "apple-design/plain.html",
);
const appleSharedCss = mirrorProjectDoc(
  "AppleDesignDemo/reader-shared.css",
  "apple-design/reader-shared.css",
);
const appleSharedJs = mirrorProjectDoc(
  "AppleDesignDemo/reader-shared.js",
  "apple-design/reader-shared.js",
);
const flutterShowcaseDemo = mirrorAbsoluteDirectory(
  resolve(process.cwd(), "../demos_code/flutter/build/web"),
  "flutter-showcase",
);
const reactShowcaseDemo = mirrorAbsoluteDirectory(
  resolve(process.cwd(), "../demos_code/react/dist"),
  "react-showcase",
);

const rows = componentCatalog
  .map((item) => {
    const figmaLink = `<a href="${item.figmaUrl}" target="_blank" rel="noreferrer">open figma</a>`;
    const evidenceLink = `<a href="#${item.id}-evidence">open evidence</a>`;
    const renderLink = `<a href="rendered/${item.id}.html" target="_blank" rel="noreferrer">open html</a>`;
    const canonicalNode = canonical.components?.[item.figmaNodeId]?.canonicalNode ?? item.figmaNodeId;
    const artifacts = item.artifacts ?? {};
    const artifactNode = parseNodeIdFromArtifactPath(artifacts.designContextPath)
      ?? parseNodeIdFromArtifactPath(artifacts.screenshotPath)
      ?? parseNodeIdFromArtifactPath(artifacts.variableDefsPath);
    const coverage = coverageLabel(item.figmaNodeId, canonicalNode, artifactNode);
    const artifactCount = [
      artifactPathExists(artifacts.designContextPath),
      artifactPathExists(artifacts.screenshotPath),
      artifactPathExists(artifacts.variableDefsPath),
    ].filter(Boolean).length;
    const rootMetadataExists = artifactPathExists(rootMetadataRelPath(item));
    let statusLabel = "unverified";
    if (item.status === "verified") {
      statusLabel = artifactNode === item.figmaNodeId
        ? "verified (category root)"
        : rootMetadataExists
          ? "verified (canonical + root metadata)"
          : "verified (canonical coverage)";
    } else if (item.figmaNodeId === activeCategoryNode) {
      statusLabel = artifactCount === 3
        ? "ready_to_verify (active)"
        : "in_progress (strict sequence)";
    } else if (!completedCategoryNodes.has(item.figmaNodeId) && activeCategoryNode) {
      statusLabel = artifactCount === 3
        ? "ready_to_verify (blocked by active)"
        : "blocked (finish active first)";
    }
    const rootMetadataLabel = rootMetadataExists ? "yes" : "no";
    return `<tr><td><a href="#${item.id}">${item.category}</a></td><td><code>${item.figmaNodeId}</code></td><td>${statusLabel}</td><td>${coverage}</td><td>${rootMetadataLabel}</td><td>${figmaLink}</td><td>${evidenceLink}</td><td>${renderLink}</td></tr>`;
  })
  .join("\n");

const links = componentCatalog
  .map((item) => `<a href="#${item.id}">${item.category}</a>`)
  .join("\n");

const sections = componentCatalog
  .map((item) => {
    const verified = item.status === "verified";
    const contextArtifact = materializeArtifact(item.artifacts.designContextPath);
    const screenshotArtifact = materializeArtifact(item.artifacts.screenshotPath);
    const variablesArtifact = materializeArtifact(item.artifacts.variableDefsPath);
    const canonicalNode = canonical.components?.[item.figmaNodeId]?.canonicalNode ?? item.figmaNodeId;

    const rawMetadataArtifact = materializeArtifact(
      latestRawRelPath(item.figmaNodeId, ".get_metadata.txt"),
    );
    const rawContextArtifact = materializeArtifact(
      latestRawRelPath(canonicalNode, ".get_design_context.txt"),
    );
    const rawScreenshotArtifact = materializeArtifact(
      latestRawRelPath(canonicalNode, ".get_screenshot.png"),
    );
    const rawScreenshotNoteArtifact = materializeArtifact(
      latestRawRelPath(canonicalNode, ".get_screenshot.txt"),
    );
    const rawVariablesArtifact = materializeArtifact(
      latestRawRelPath(canonicalNode, ".get_variable_defs.txt"),
    );

    const artifacts = verified
      ? `${renderArtifact("Design context", contextArtifact)}${renderArtifact("Screenshot evidence", screenshotArtifact)}${renderArtifact("Variable definitions", variablesArtifact)}`
      : `<p><strong>Strict Mode:</strong> pending full verification (no assumed UI rendered).</p>
<p><strong>Canonical node:</strong> <code>${escapeHtml(canonicalNode)}</code></p>
${renderArtifact("Raw metadata", rawMetadataArtifact)}
${renderArtifact("Raw design-context candidate", rawContextArtifact)}
${renderArtifact("Raw screenshot candidate", rawScreenshotArtifact)}
${renderArtifact("Raw screenshot note", rawScreenshotNoteArtifact)}
${renderArtifact("Raw variable-defs candidate", rawVariablesArtifact)}`;

    return `<section id="${item.id}" class="section"><h2>${item.category}</h2><p>Node <code>${item.figmaNodeId}</code></p><p><a href="${item.figmaUrl}" target="_blank" rel="noreferrer">Open in Figma</a> • <a id="${item.id}-evidence" href="#${item.id}-evidence">Evidence anchor</a></p>${artifacts}</section>`;
  })
  .join("\n");

const styles = `
${renderGlobalStyles()}

* { box-sizing: border-box; }
body {
  color-scheme: light;
  margin: 0;
  background:
    radial-gradient(1200px 680px at 15% 0%, #e8f0ff 0%, transparent 60%),
    radial-gradient(1200px 740px at 90% 0%, #f2e7ff 0%, transparent 62%),
    #f6f8fc;
  color: #111;
  font-family: "SF Pro Text", "Segoe UI", Arial, sans-serif;
}
.layout {
  display: grid;
  grid-template-columns: minmax(260px, 300px) minmax(0, 1fr);
  min-height: 100vh;
}
.sidebar {
  position: sticky;
  top: 0;
  height: 100vh;
  overflow: auto;
  border-right: 1px solid #d8dce3;
  background: #fff;
  padding: 20px;
}
.sidebar h1 { margin: 0 0 8px; font-size: 20px; }
.sidebar p { margin: 0 0 14px; color: #4f5661; font-size: 14px; }
.sidebar a { display: block; margin: 0 0 7px; color: #1357d7; text-decoration: none; }
.content {
  padding: 24px;
  min-width: 0;
}
.section {
  background: #fff;
  border: 1px solid #d8dce3;
  border-radius: 14px;
  padding: 16px;
  margin-bottom: 14px;
}
.section h2 { margin: 0 0 8px; font-size: 17px; }
.launch-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 10px;
}
.launch-card {
  border: 1px solid #d8dce3;
  border-radius: 12px;
  background: #fafbfc;
  padding: 12px;
  display: grid;
  gap: 8px;
}
.launch-card h3 {
  margin: 0;
  font-size: 15px;
}
.launch-card p {
  margin: 0;
  color: #4f5661;
  font-size: 13px;
}
.launch-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 36px;
  border-radius: 999px;
  border: 0;
  padding: 0 14px;
  text-decoration: none;
  font: 590 13px/1 "SF Pro Text", "Segoe UI", Arial, sans-serif;
}
.launch-btn--primary {
  color: #fff;
  background: #0a84ff;
}
.launch-btn--neutral {
  color: #111;
  background: #eef1f5;
}
.launch-btn--dark {
  color: #fff;
  background: #1f2430;
}
.status-wrap {
  width: 100%;
  overflow-x: auto;
  border: 1px solid #e4e7ec;
  border-radius: 10px;
  background: #fff;
}
.status {
  width: 100%;
  min-width: 980px;
  border-collapse: collapse;
}
.status th, .status td {
  border-bottom: 1px solid #e4e7ec;
  text-align: left;
  padding: 8px;
  font-size: 14px;
}
.artifact { margin: 10px 0; }
.artifact summary { cursor: pointer; }
.artifact pre {
  margin: 10px 0 0;
  padding: 10px;
  border: 1px solid #d8dce3;
  background: #fafbfc;
  border-radius: 8px;
  overflow: auto;
  white-space: pre-wrap;
  font-size: 12px;
  line-height: 1.4;
}
.artifact-image {
  display: block;
  margin-top: 10px;
  max-width: 100%;
  border: 1px solid #d8dce3;
  border-radius: 8px;
  background: #fff;
}

@media (max-width: 920px) {
  .layout { grid-template-columns: 1fr; }
  .sidebar {
    position: static;
    height: auto;
    border-right: 0;
    border-bottom: 1px solid #d8dce3;
  }
}
`;

const verifiedCount = componentCatalog.filter((item) => item.status === "verified").length;
const verifiedRootCount = componentCatalog.filter((item) => {
  if (item.status !== "verified") {
    return false;
  }
  const artifacts = item.artifacts ?? {};
  const artifactNode = parseNodeIdFromArtifactPath(artifacts.designContextPath)
    ?? parseNodeIdFromArtifactPath(artifacts.screenshotPath)
    ?? parseNodeIdFromArtifactPath(artifacts.variableDefsPath);
  return artifactNode === item.figmaNodeId || artifactPathExists(rootMetadataRelPath(item));
}).length;

const html = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>ios-26 Strict Mode</title>
    <style>${styles}</style>
  </head>
  <body>
    <div class="layout">
      <aside class="sidebar">
        <h1>ios-26 Strict</h1>
        <p>Verified categories (all): ${verifiedCount}/${componentCatalog.length}</p>
        <p>Verified category-root: ${verifiedRootCount}/${componentCatalog.length}</p>
        <p>Active category: <code>${activeCategoryNode ?? "-"}</code></p>
        <a href="#launch">Demos</a>
        <a href="#status">Status</a>
        <a href="rendered/index.html" target="_blank" rel="noreferrer">Rendered HTML</a>
        ${appleSolidDemo ? `<a href="${appleSolidDemo}" target="_blank" rel="noreferrer">Apple Design: Solid</a>` : ""}
        ${flutterShowcaseDemo ? `<a href="${flutterShowcaseDemo}" target="_blank" rel="noreferrer">Flutter Showcase (Wasm)</a>` : ""}
        ${reactShowcaseDemo ? `<a href="${reactShowcaseDemo}" target="_blank" rel="noreferrer">React Showcase</a>` : ""}
        ${strictStatusDoc ? `<a href="${strictStatusDoc}" target="_blank" rel="noreferrer">Strict Status Doc</a>` : ""}
        ${releaseInventoryDoc ? `<a href="${releaseInventoryDoc}" target="_blank" rel="noreferrer">Release Inventory Doc</a>` : ""}
        ${resumeQueueDoc ? `<a href="${resumeQueueDoc}" target="_blank" rel="noreferrer">Resume Queue Doc</a>` : ""}
        ${mcpRecaptureQueueDoc ? `<a href="${mcpRecaptureQueueDoc}" target="_blank" rel="noreferrer">MCP Recapture Queue</a>` : ""}
        ${nativeImageAuditDoc ? `<a href="${nativeImageAuditDoc}" target="_blank" rel="noreferrer">Native Image Audit</a>` : ""}
        ${fullMetadataCoverageDoc ? `<a href="${fullMetadataCoverageDoc}" target="_blank" rel="noreferrer">Full Metadata Coverage</a>` : ""}
        ${evidenceCompletenessDoc ? `<a href="${evidenceCompletenessDoc}" target="_blank" rel="noreferrer">Evidence Completeness</a>` : ""}
        ${assetSyncSummaryDoc ? `<a href="${assetSyncSummaryDoc}" target="_blank" rel="noreferrer">Asset Sync Summary</a>` : ""}
        ${links}
      </aside>
      <main class="content">
        <section id="launch" class="section">
          <h2>Demos</h2>
          <div class="launch-grid">
            <article class="launch-card">
              <h3>Strict Evidence Index</h3>
              <p>Current page with full verification matrix, evidence files, and category navigation.</p>
              <a class="launch-btn launch-btn--neutral" href="#status">Open Here</a>
            </article>
            ${appleSolidDemo ? `<article class="launch-card">
              <h3>Apple Design (Solid)</h3>
              <p>Solid Apple-style cards, controls, and sheets.</p>
              <a class="launch-btn launch-btn--primary" href="${appleSolidDemo}" target="_blank" rel="noreferrer">Open Solid Demo</a>
            </article>` : ""}
            ${flutterShowcaseDemo ? `<article class="launch-card">
              <h3>Flutter Showcase (Wasm)</h3>
              <p>Standalone Flutter variant with component catalog, demos, and light/dark/system themes.</p>
              <a class="launch-btn launch-btn--dark" href="${flutterShowcaseDemo}" target="_blank" rel="noreferrer">Open Flutter Demo</a>
            </article>` : ""}
            ${reactShowcaseDemo ? `<article class="launch-card">
              <h3>React Showcase</h3>
              <p>Comprehensive React variant with full component coverage, evidence links, and standalone demos.</p>
              <a class="launch-btn launch-btn--dark" href="${reactShowcaseDemo}" target="_blank" rel="noreferrer">Open React Demo</a>
            </article>` : ""}
          </div>
        </section>
        <section id="status" class="section">
          <h2>Verification Matrix</h2>
          <div class="status-wrap">
            <table class="status">
              <thead>
                <tr><th>Category</th><th>Node</th><th>Status</th><th>Coverage</th><th>Root metadata</th><th>Figma</th><th>Evidence</th><th>Render</th></tr>
              </thead>
              <tbody>
                ${rows}
              </tbody>
            </table>
          </div>
        </section>
        ${sections}
      </main>
    </div>
  </body>
</html>`;

writeFileSync(outputPath, html, "utf8");

console.log(`Strict preview generated: ${outputPath}`);
