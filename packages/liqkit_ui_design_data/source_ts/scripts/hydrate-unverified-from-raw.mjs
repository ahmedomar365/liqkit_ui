import {
  copyFileSync,
  existsSync,
  mkdirSync,
  readdirSync,
  readFileSync,
  statSync,
} from "node:fs";
import { execFileSync } from "node:child_process";
import { resolve } from "node:path";

function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i += 1) {
    const key = argv[i];
    if (!key.startsWith("--")) {
      throw new Error(`Unexpected argument: ${key}`);
    }
    const value = argv[i + 1];
    if (!value || value.startsWith("--")) {
      throw new Error(`Missing value for argument: ${key}`);
    }
    args[key.slice(2)] = value;
    i += 1;
  }
  return args;
}

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function listRawPaths(root, nodeId, suffix) {
  const dir = resolve(root, "figma-artifacts", "raw", slugNode(nodeId));
  if (!existsSync(dir)) {
    return [];
  }
  return readdirSync(dir)
    .filter((name) => name.endsWith(suffix))
    .sort((a, b) => b.localeCompare(a))
    .map((name) => resolve(dir, name));
}

function isQuotaLimitText(content) {
  return content.includes("You've reached the Figma MCP tool call limit");
}

function isInvalidSelectionText(content) {
  return content.includes("You currently have nothing selected");
}

function latestValidDesignContext(root, nodeId) {
  const candidates = listRawPaths(root, nodeId, ".get_design_context.txt");
  for (const path of candidates) {
    const content = readFileSync(path, "utf8");
    if (isQuotaLimitText(content) || isInvalidSelectionText(content)) {
      continue;
    }
    if (!content.trim()) {
      continue;
    }
    return path;
  }
  return null;
}

function latestValidVariableDefs(root, nodeId) {
  const candidates = listRawPaths(root, nodeId, ".get_variable_defs.txt");
  for (const path of candidates) {
    const content = readFileSync(path, "utf8");
    if (isQuotaLimitText(content)) {
      continue;
    }
    try {
      JSON.parse(content);
    } catch {
      continue;
    }
    return path;
  }
  return null;
}

function latestValidScreenshot(root, nodeId) {
  const candidates = listRawPaths(root, nodeId, ".get_screenshot.png");
  for (const path of candidates) {
    if (statSync(path).size > 0) {
      return path;
    }
  }
  return null;
}

function latestScreenshotNote(root, nodeId) {
  const candidates = listRawPaths(root, nodeId, ".get_screenshot.txt");
  return candidates[0] ?? null;
}

function maybeCopy(sourceAbsPath, targetRelPath, root) {
  if (!sourceAbsPath || !targetRelPath) {
    return null;
  }
  const targetAbsPath = resolve(root, targetRelPath);
  mkdirSync(resolve(targetAbsPath, ".."), { recursive: true });
  copyFileSync(sourceAbsPath, targetAbsPath);
  return targetRelPath;
}

const args = parseArgs(process.argv);
const filterCategoryNode = args.categoryNode ?? null;

const root = process.cwd();
const verificationPath = resolve(root, "figma-artifacts", "verification.json");
const canonicalPath = resolve(root, "figma-artifacts", "canonical-nodes.json");
const recordScriptPath = resolve(root, "scripts", "record-figma-artifact.mjs");

const verification = JSON.parse(readFileSync(verificationPath, "utf8"));
const canonical = existsSync(canonicalPath)
  ? JSON.parse(readFileSync(canonicalPath, "utf8"))
  : { components: {} };

const rows = Object.entries(verification.components ?? {})
  .map(([categoryNode, entry]) => ({ categoryNode, entry }))
  .filter(({ categoryNode, entry }) => {
    if (entry.status === "verified") {
      return false;
    }
    if (filterCategoryNode && categoryNode !== filterCategoryNode) {
      return false;
    }
    return true;
  });

let updated = 0;
let skipped = 0;

for (const row of rows) {
  const { categoryNode, entry } = row;
  const sourceNode = canonical.components?.[categoryNode]?.canonicalNode ?? categoryNode;
  const outDir = resolve(root, "figma-artifacts", entry.id);
  mkdirSync(outDir, { recursive: true });
  const slug = slugNode(sourceNode);

  const designAbs = latestValidDesignContext(root, sourceNode);
  const varsAbs = latestValidVariableDefs(root, sourceNode);
  const screenshotAbs = latestValidScreenshot(root, sourceNode);
  const screenshotNoteAbs = latestScreenshotNote(root, sourceNode);

  const designRel = designAbs
    ? `figma-artifacts/${entry.id}/${slug}.design-context.txt`
    : null;
  const varsRel = varsAbs
    ? `figma-artifacts/${entry.id}/${slug}.variable-defs.json`
    : null;
  const screenshotRel = screenshotAbs
    ? `figma-artifacts/${entry.id}/${slug}.screenshot.png`
    : null;
  const screenshotNoteRel = !screenshotAbs && screenshotNoteAbs
    ? `figma-artifacts/${entry.id}/${slug}.screenshot.pending.txt`
    : null;

  maybeCopy(designAbs, designRel, root);
  maybeCopy(varsAbs, varsRel, root);
  maybeCopy(screenshotAbs, screenshotRel, root);
  maybeCopy(screenshotNoteAbs, screenshotNoteRel, root);

  if (!designRel && !varsRel && !screenshotRel) {
    skipped += 1;
    continue;
  }

  const cmdArgs = [
    recordScriptPath,
    "--categoryNode",
    categoryNode,
    "--status",
    "unverified",
    "--canonicalNode",
    sourceNode,
  ];
  if (designRel) {
    cmdArgs.push("--designContextPath", designRel);
  }
  if (screenshotRel) {
    cmdArgs.push("--screenshotPath", screenshotRel);
  }
  if (varsRel) {
    cmdArgs.push("--variableDefsPath", varsRel);
  }

  execFileSync(process.execPath, cmdArgs, { stdio: "inherit" });
  updated += 1;
}

console.log(
  `Hydrated unverified artifacts from raw. updated=${updated} skipped=${skipped}${filterCategoryNode ? ` category=${filterCategoryNode}` : ""}`,
);
