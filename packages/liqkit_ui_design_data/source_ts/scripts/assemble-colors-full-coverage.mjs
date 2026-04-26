import { copyFileSync, existsSync, mkdirSync, readFileSync, readdirSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const rawRoot = resolve(root, "figma-artifacts", "raw");
const colorsDir = resolve(root, "figma-artifacts", "colors");
const fullCoverageDir = resolve(colorsDir, "full-coverage");
const nodesDir = resolve(fullCoverageDir, "nodes");
const metadataPath = resolve(colorsDir, "0-1746.metadata.xml");
const workflowPath = resolve(root, "figma-artifacts", "full-coverage-workflow.json");

const coverageNodes = [
  { nodeId: "0:1746", role: "category-root", requireDesignContext: false, requireVariableDefs: false, requireScreenshot: true },
  { nodeId: "5707:28659", role: "default-section", requireDesignContext: true, requireVariableDefs: true, requireScreenshot: true },
  { nodeId: "5707:28660", role: "increased-contrast-section", requireDesignContext: true, requireVariableDefs: true, requireScreenshot: true },
  { nodeId: "0:2049", role: "default-colors-frame", requireDesignContext: true, requireVariableDefs: true, requireScreenshot: true },
  { nodeId: "5532:12332", role: "increased-colors-frame", requireDesignContext: true, requireVariableDefs: true, requireScreenshot: true },
  { nodeId: "5532:7800", role: "default-background-grid", requireDesignContext: true, requireVariableDefs: true, requireScreenshot: true },
  { nodeId: "5532:8407", role: "default-fills-grid", requireDesignContext: true, requireVariableDefs: true, requireScreenshot: true },
  { nodeId: "5532:12327", role: "increased-labels-grid", requireDesignContext: true, requireVariableDefs: true, requireScreenshot: true },
  { nodeId: "5532:12331", role: "increased-fills-grid", requireDesignContext: true, requireVariableDefs: true, requireScreenshot: true },
  { nodeId: "0:4207", role: "swatch-color-mode-light", requireDesignContext: true, requireVariableDefs: true, requireScreenshot: true },
];

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function latestRawFile(nodeId, suffix) {
  const dir = resolve(rawRoot, slugNode(nodeId));
  if (!existsSync(dir)) {
    return null;
  }
  const matches = readdirSync(dir)
    .filter((name) => name.endsWith(suffix))
    .sort((a, b) => b.localeCompare(a));
  if (matches.length === 0) {
    return null;
  }
  const fileName = matches[0];
  const absPath = resolve(dir, fileName);
  const relPath = `figma-artifacts/raw/${slugNode(nodeId)}/${fileName}`;
  return { absPath, relPath };
}

function parseVariableDefs(text) {
  const trimmed = text.trim();
  if (!trimmed) {
    return null;
  }
  try {
    const parsed = JSON.parse(trimmed);
    if (parsed && typeof parsed === "object" && !Array.isArray(parsed)) {
      return parsed;
    }
  } catch {
    return null;
  }
  return null;
}

mkdirSync(nodesDir, { recursive: true });

const nodeRecords = [];
const aggregateDesignSections = [];
const aggregateVariables = {
  generatedAt: new Date().toISOString(),
  categoryNode: "0:1746",
  modes: {
    default: {},
    increasedContrast: {},
  },
  nodes: {},
};

if (existsSync(metadataPath)) {
  const metadataOut = resolve(nodesDir, "0-1746.metadata.xml");
  copyFileSync(metadataPath, metadataOut);
}

for (const node of coverageNodes) {
  const slug = slugNode(node.nodeId);
  const designRaw = latestRawFile(node.nodeId, ".get_design_context.txt");
  const screenshotRaw = latestRawFile(node.nodeId, ".get_screenshot.png");
  const variableRaw = latestRawFile(node.nodeId, ".get_variable_defs.txt");

  const rec = {
    nodeId: node.nodeId,
    role: node.role,
    required: {
      designContext: node.requireDesignContext,
      screenshot: node.requireScreenshot,
      variableDefs: node.requireVariableDefs,
    },
    source: {
      designContext: designRaw?.relPath ?? null,
      screenshot: screenshotRaw?.relPath ?? null,
      variableDefs: variableRaw?.relPath ?? null,
    },
    persisted: {
      designContext: null,
      screenshot: null,
      variableDefs: null,
      variableDefsRaw: null,
    },
    parsedVariableDefs: false,
    complete: false,
  };

  if (designRaw) {
    const outRel = `figma-artifacts/colors/full-coverage/nodes/${slug}.design-context.txt`;
    copyFileSync(designRaw.absPath, resolve(root, outRel));
    rec.persisted.designContext = outRel;
    const body = readFileSync(resolve(root, outRel), "utf8");
    aggregateDesignSections.push([
      `=== NODE ${node.nodeId} (${node.role}) ===`,
      `source: ${designRaw.relPath}`,
      body.trim(),
      "",
    ].join("\n"));
  }

  if (screenshotRaw) {
    const outRel = `figma-artifacts/colors/full-coverage/nodes/${slug}.screenshot.png`;
    copyFileSync(screenshotRaw.absPath, resolve(root, outRel));
    rec.persisted.screenshot = outRel;
  }

  if (variableRaw) {
    const rawRel = `figma-artifacts/colors/full-coverage/nodes/${slug}.variable-defs.raw.txt`;
    copyFileSync(variableRaw.absPath, resolve(root, rawRel));
    rec.persisted.variableDefsRaw = rawRel;

    const rawText = readFileSync(resolve(root, rawRel), "utf8");
    const parsed = parseVariableDefs(rawText);
    if (parsed) {
      const jsonRel = `figma-artifacts/colors/full-coverage/nodes/${slug}.variable-defs.json`;
      writeFileSync(resolve(root, jsonRel), `${JSON.stringify(parsed, null, 2)}\n`, "utf8");
      rec.persisted.variableDefs = jsonRel;
      rec.parsedVariableDefs = true;
      aggregateVariables.nodes[node.nodeId] = parsed;
    } else {
      aggregateVariables.nodes[node.nodeId] = null;
    }
  } else {
    aggregateVariables.nodes[node.nodeId] = null;
  }

  const hasDesign = !!rec.persisted.designContext;
  const hasScreenshot = !!rec.persisted.screenshot;
  const hasVariable = !!rec.persisted.variableDefs;
  rec.complete =
    (!node.requireDesignContext || hasDesign) &&
    (!node.requireScreenshot || hasScreenshot) &&
    (!node.requireVariableDefs || hasVariable);

  nodeRecords.push(rec);
}

aggregateVariables.modes.default = aggregateVariables.nodes["5707:28659"] ?? {};
aggregateVariables.modes.increasedContrast = aggregateVariables.nodes["5707:28660"] ?? {};

const aggregateDesignRel = "figma-artifacts/colors/0-1746.design-context.txt";
const aggregateVariablesRel = "figma-artifacts/colors/0-1746.variable-defs.json";
const aggregateScreenshotRel = "figma-artifacts/colors/0-1746.screenshot.png";

const rootShot = nodeRecords.find((item) => item.nodeId === "0:1746")?.persisted.screenshot ?? null;
if (rootShot) {
  copyFileSync(resolve(root, rootShot), resolve(root, aggregateScreenshotRel));
}

const metadataBlock = existsSync(metadataPath)
  ? [
      "=== NODE 0:1746 (category-root metadata) ===",
      `source: figma-artifacts/colors/0-1746.metadata.xml`,
      readFileSync(metadataPath, "utf8").trim(),
      "",
    ].join("\n")
  : "";

const designBody = [metadataBlock, ...aggregateDesignSections].filter(Boolean).join("\n");
writeFileSync(resolve(root, aggregateDesignRel), `${designBody.trim()}\n`, "utf8");
writeFileSync(resolve(root, aggregateVariablesRel), `${JSON.stringify(aggregateVariables, null, 2)}\n`, "utf8");

const missing = nodeRecords.filter((item) => !item.complete).map((item) => item.nodeId);
const coverageManifest = {
  generatedAt: new Date().toISOString(),
  categoryNode: "0:1746",
  mode: "full-coverage-only",
  metadataPath: existsSync(metadataPath) ? "figma-artifacts/colors/0-1746.metadata.xml" : null,
  artifacts: {
    designContextPath: aggregateDesignRel,
    screenshotPath: rootShot ? aggregateScreenshotRel : null,
    variableDefsPath: aggregateVariablesRel,
  },
  coverageNodes: nodeRecords,
  complete: missing.length === 0,
  missing,
};

const coverageManifestRel = "figma-artifacts/colors/full-coverage/coverage-manifest.json";
writeFileSync(resolve(root, coverageManifestRel), `${JSON.stringify(coverageManifest, null, 2)}\n`, "utf8");

if (existsSync(workflowPath)) {
  const workflow = JSON.parse(readFileSync(workflowPath, "utf8"));
  workflow.progress = workflow.progress ?? {};
  workflow.progress["0:1746"] = {
    step: coverageManifest.complete ? "full-coverage-artifacts-ready" : "full-coverage-artifacts-incomplete",
    metadataPath: "figma-artifacts/colors/0-1746.metadata.xml",
    coverageManifestPath: coverageManifestRel,
    artifacts: coverageManifest.artifacts,
    missing,
    updatedAt: new Date().toISOString(),
  };
  workflow.updatedAt = new Date().toISOString();
  writeFileSync(workflowPath, `${JSON.stringify(workflow, null, 2)}\n`, "utf8");
}

console.log(`Colors full coverage assembled: ${coverageManifestRel}`);
console.log(`complete=${coverageManifest.complete} missing=${missing.length}`);
