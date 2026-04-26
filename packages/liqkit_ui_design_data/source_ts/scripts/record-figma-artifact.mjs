import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const verificationPath = resolve(root, "figma-artifacts/verification.json");
const canonicalPath = resolve(root, "figma-artifacts/canonical-nodes.json");
const workflowPath = resolve(root, "figma-artifacts/full-coverage-workflow.json");

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

function assertFileIfProvided(relPath, label) {
  if (!relPath) {
    return;
  }
  const absPath = resolve(root, relPath);
  if (!existsSync(absPath)) {
    throw new Error(`${label} does not exist: ${relPath}`);
  }
}

const args = parseArgs(process.argv);

const categoryNode = args.categoryNode;
if (!categoryNode) {
  throw new Error("Missing required argument --categoryNode");
}

const status = args.status ?? "unverified";
if (status !== "verified" && status !== "unverified") {
  throw new Error(`Invalid --status: ${status}`);
}

const designContextPath = args.designContextPath ?? null;
const screenshotPath = args.screenshotPath ?? null;
const variableDefsPath = args.variableDefsPath ?? null;
const canonicalNode = args.canonicalNode ?? null;
const fullCoverageConfirmed = args.fullCoverageConfirmed === "true";

assertFileIfProvided(designContextPath, "--designContextPath");
assertFileIfProvided(screenshotPath, "--screenshotPath");
assertFileIfProvided(variableDefsPath, "--variableDefsPath");

const verification = JSON.parse(readFileSync(verificationPath, "utf8"));
const current = verification.components[categoryNode];
if (!current) {
  throw new Error(`Category node not found in verification.json: ${categoryNode}`);
}

if (status === "verified" && (!designContextPath || !screenshotPath || !variableDefsPath)) {
  throw new Error(
    "verified status requires --designContextPath --screenshotPath --variableDefsPath",
  );
}

if (status === "verified" && !fullCoverageConfirmed) {
  throw new Error(
    "full coverage verification requires --fullCoverageConfirmed true",
  );
}

const workflow = existsSync(workflowPath)
  ? JSON.parse(readFileSync(workflowPath, "utf8"))
  : null;

if (status === "verified" && workflow?.activeCategoryNode && workflow.activeCategoryNode !== categoryNode) {
  throw new Error(
    `Cannot verify ${categoryNode}. Active category is ${workflow.activeCategoryNode}`,
  );
}

verification.components[categoryNode] = {
  ...current,
  status,
  verifiedAt: status === "verified" ? new Date().toISOString() : null,
  artifacts: {
    designContextPath,
    screenshotPath,
    variableDefsPath,
  },
};

writeFileSync(verificationPath, `${JSON.stringify(verification, null, 2)}\n`, "utf8");

const canonical = existsSync(canonicalPath)
  ? JSON.parse(readFileSync(canonicalPath, "utf8"))
  : { components: {} };

if (canonicalNode) {
  canonical.components[categoryNode] = {
    canonicalNode,
    updatedAt: new Date().toISOString(),
  };
  writeFileSync(canonicalPath, `${JSON.stringify(canonical, null, 2)}\n`, "utf8");
}

if (status === "verified" && workflow) {
  const completed = new Set(workflow.completedCategoryNodes ?? []);
  completed.add(categoryNode);
  const sequence = Array.isArray(workflow.sequence) ? workflow.sequence : [];
  const next = sequence.find((item) => !completed.has(item.categoryNode)) ?? null;
  workflow.completedCategoryNodes = [...completed];
  workflow.activeCategoryNode = next?.categoryNode ?? null;
  workflow.updatedAt = new Date().toISOString();
  writeFileSync(workflowPath, `${JSON.stringify(workflow, null, 2)}\n`, "utf8");
}

console.log(
  `Artifact recorded for ${categoryNode} status=${status} canonical=${canonicalNode ?? "-"}`,
);
