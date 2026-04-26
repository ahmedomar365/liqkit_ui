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
    if (content.trim().length === 0) {
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
    const stats = statSync(path);
    if (stats.size > 0) {
      return path;
    }
  }
  return null;
}

const args = parseArgs(process.argv);
const categoryNode = args.categoryNode;
if (!categoryNode) {
  throw new Error("Missing --categoryNode");
}
const sourceNode = args.sourceNode ?? categoryNode;

const root = process.cwd();
const verification = JSON.parse(
  readFileSync(resolve(root, "figma-artifacts", "verification.json"), "utf8"),
);
const entry = verification.components?.[categoryNode];
if (!entry) {
  throw new Error(`Unknown category node in verification.json: ${categoryNode}`);
}

const designAbs = latestValidDesignContext(root, sourceNode);
const varsAbs = latestValidVariableDefs(root, sourceNode);
const shotAbs = latestValidScreenshot(root, sourceNode);

if (!designAbs || !varsAbs || !shotAbs) {
  throw new Error(
    `Missing raw artifacts for source node ${sourceNode}. design=${!!designAbs} vars=${!!varsAbs} screenshot=${!!shotAbs}`,
  );
}

const outDir = resolve(root, "figma-artifacts", entry.id);
mkdirSync(outDir, { recursive: true });
const slug = slugNode(sourceNode);
const designRel = `figma-artifacts/${entry.id}/${slug}.design-context.txt`;
const varsRel = `figma-artifacts/${entry.id}/${slug}.variable-defs.json`;
const shotRel = `figma-artifacts/${entry.id}/${slug}.screenshot.png`;

copyFileSync(designAbs, resolve(root, designRel));
copyFileSync(varsAbs, resolve(root, varsRel));
copyFileSync(shotAbs, resolve(root, shotRel));

execFileSync(
  process.execPath,
  [
    resolve(root, "scripts", "record-figma-artifact.mjs"),
    "--categoryNode",
    categoryNode,
    "--status",
    "verified",
    "--designContextPath",
    designRel,
    "--screenshotPath",
    shotRel,
    "--variableDefsPath",
    varsRel,
    "--canonicalNode",
    sourceNode,
    "--fullCoverageConfirmed",
    "true",
  ],
  { stdio: "inherit" },
);

console.log(
  `Finalized category ${categoryNode} from source ${sourceNode}. artifacts=${designRel}, ${varsRel}, ${shotRel}`,
);
