import { copyFileSync, existsSync, mkdirSync, readFileSync, readdirSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const rawRoot = resolve(root, "figma-artifacts", "raw");
const examplesDir = resolve(root, "figma-artifacts", "examples");
const fullCoverageDir = resolve(examplesDir, "full-coverage");
const nodesDir = resolve(fullCoverageDir, "nodes");
const workflowPath = resolve(root, "figma-artifacts", "full-coverage-workflow.json");

const CATEGORY_NODE = "0:3329";
const SECTION_NODES = ["5742:36225", "5742:36226"];

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

function parseTopLevelNodeIdsFromMetadata(xml) {
  const lines = xml.split(/\r?\n/);
  const ids = new Set();
  for (const line of lines) {
    const match = line.match(/^ {4}<(frame|symbol)\s+id="([^"]+)"/);
    if (match) {
      ids.add(match[2]);
    }
  }
  return [...ids].sort((a, b) => a.localeCompare(b));
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

const metadataRaw = latestRawFile(CATEGORY_NODE, ".get_metadata.txt");
if (!metadataRaw) {
  throw new Error("Missing metadata raw file for Examples (0:3329). Run get_metadata first.");
}

const metadataText = readFileSync(metadataRaw.absPath, "utf8");
const categoryMetadataRel = "figma-artifacts/examples/0-3329.metadata.xml";
writeFileSync(resolve(root, categoryMetadataRel), `${metadataText.trim()}\n`, "utf8");

const coverageNodeIds = parseTopLevelNodeIdsFromMetadata(metadataText);
const coverageNodes = [
  ...SECTION_NODES.map((nodeId) => ({ nodeId, role: "section", required: { designContext: true, screenshot: false } })),
  ...coverageNodeIds.map((nodeId) => ({ nodeId, role: "node", required: { designContext: true, screenshot: false } })),
];

const uniqueCoverage = [];
const seen = new Set();
for (const entry of coverageNodes) {
  if (seen.has(entry.nodeId)) {
    continue;
  }
  seen.add(entry.nodeId);
  uniqueCoverage.push(entry);
}

const nodeRecords = [];
const aggregateDesignSections = [];
const screenshotCandidates = [];

for (const node of uniqueCoverage) {
  const slug = slugNode(node.nodeId);
  const designRaw = latestRawFile(node.nodeId, ".get_design_context.txt");
  const screenshotRaw = latestRawFile(node.nodeId, ".get_screenshot.png");

  const record = {
    nodeId: node.nodeId,
    role: node.role,
    required: node.required,
    source: {
      designContext: designRaw?.relPath ?? null,
      screenshot: screenshotRaw?.relPath ?? null,
    },
    persisted: {
      designContext: null,
      screenshot: null,
    },
    complete: false,
  };

  if (designRaw) {
    const outRel = `figma-artifacts/examples/full-coverage/nodes/${slug}.design-context.txt`;
    copyFileSync(designRaw.absPath, resolve(root, outRel));
    record.persisted.designContext = outRel;
    const body = readFileSync(resolve(root, outRel), "utf8");
    aggregateDesignSections.push([
      `=== NODE ${node.nodeId} (${node.role}) ===`,
      `source: ${designRaw.relPath}`,
      body.trim(),
      "",
    ].join("\n"));
  }

  if (screenshotRaw) {
    const outRel = `figma-artifacts/examples/full-coverage/nodes/${slug}.screenshot.png`;
    copyFileSync(screenshotRaw.absPath, resolve(root, outRel));
    record.persisted.screenshot = outRel;
    screenshotCandidates.push({
      nodeId: node.nodeId,
      path: outRel,
    });
  }

  record.complete = !!record.persisted.designContext;
  nodeRecords.push(record);
}

const variableAggregate = {
  generatedAt: new Date().toISOString(),
  categoryNode: CATEGORY_NODE,
  sections: {},
};

for (const sectionNode of SECTION_NODES) {
  const sectionVarRaw = latestRawFile(sectionNode, ".get_variable_defs.txt");
  if (!sectionVarRaw) {
    variableAggregate.sections[sectionNode] = null;
    continue;
  }
  const rawText = readFileSync(sectionVarRaw.absPath, "utf8");
  const parsed = parseVariableDefs(rawText);
  variableAggregate.sections[sectionNode] = parsed;
}

const designContextRel = "figma-artifacts/examples/0-3329.design-context.txt";
const variableDefsRel = "figma-artifacts/examples/0-3329.variable-defs.json";
const screenshotRel = "figma-artifacts/examples/0-3329.screenshot.png";
const screenshotCandidate = screenshotCandidates[0] ?? null;

const designBody = [
  "=== NODE 0:3329 (category-root metadata) ===",
  `source: ${metadataRaw.relPath}`,
  metadataText.trim(),
  "",
  ...aggregateDesignSections,
].join("\n");
writeFileSync(resolve(root, designContextRel), `${designBody.trim()}\n`, "utf8");
writeFileSync(resolve(root, variableDefsRel), `${JSON.stringify(variableAggregate, null, 2)}\n`, "utf8");

if (screenshotCandidate) {
  copyFileSync(resolve(root, screenshotCandidate.path), resolve(root, screenshotRel));
}

const missingDesignContext = nodeRecords.filter((item) => !item.persisted.designContext).map((item) => item.nodeId);
const missingVariableDefs = SECTION_NODES.filter((nodeId) => !variableAggregate.sections[nodeId]);
const missingScreenshot = screenshotCandidate ? [] : ["no-screenshot-candidate"];

const coverageManifest = {
  generatedAt: new Date().toISOString(),
  categoryNode: CATEGORY_NODE,
  mode: "full-coverage-only",
  metadataPath: categoryMetadataRel,
  artifacts: {
    designContextPath: designContextRel,
    screenshotPath: screenshotCandidate ? screenshotRel : null,
    variableDefsPath: variableDefsRel,
  },
  coverageNodes: nodeRecords,
  summary: {
    totalCoverageNodes: nodeRecords.length,
    designContextReady: nodeRecords.length - missingDesignContext.length,
    screenshotCandidates: screenshotCandidates.length,
  },
  complete:
    missingDesignContext.length === 0 &&
    missingVariableDefs.length === 0 &&
    missingScreenshot.length === 0,
  missing: {
    designContext: missingDesignContext,
    variableDefs: missingVariableDefs,
    screenshot: missingScreenshot,
  },
};

const coverageManifestRel = "figma-artifacts/examples/full-coverage/coverage-manifest.json";
writeFileSync(resolve(root, coverageManifestRel), `${JSON.stringify(coverageManifest, null, 2)}\n`, "utf8");

if (existsSync(workflowPath)) {
  const workflow = JSON.parse(readFileSync(workflowPath, "utf8"));
  workflow.progress = workflow.progress ?? {};
  workflow.progress[CATEGORY_NODE] = {
    step: coverageManifest.complete ? "full-coverage-artifacts-ready" : "full-coverage-artifacts-incomplete",
    metadataPath: categoryMetadataRel,
    coverageManifestPath: coverageManifestRel,
    artifacts: coverageManifest.artifacts,
    missing: coverageManifest.missing,
    updatedAt: new Date().toISOString(),
  };
  workflow.updatedAt = new Date().toISOString();
  writeFileSync(workflowPath, `${JSON.stringify(workflow, null, 2)}\n`, "utf8");
}

console.log(`Examples full coverage assembled: ${coverageManifestRel}`);
console.log(`complete=${coverageManifest.complete}`);
console.log(`missing.designContext=${missingDesignContext.length}`);
console.log(`missing.variableDefs=${missingVariableDefs.length}`);
console.log(`missing.screenshot=${missingScreenshot.length}`);
