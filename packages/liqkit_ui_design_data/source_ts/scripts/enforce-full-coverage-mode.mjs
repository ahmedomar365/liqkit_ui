import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const verificationPath = resolve(root, "figma-artifacts/verification.json");
const canonicalPath = resolve(root, "figma-artifacts/canonical-nodes.json");
const manifestPath = resolve(root, "FIGMA_NODE_MANIFEST.md");
const workflowPath = resolve(root, "figma-artifacts/full-coverage-workflow.json");
const historyDir = resolve(root, "figma-artifacts/history");

function nowId() {
  return new Date().toISOString().replaceAll(":", "-").replaceAll(".", "-");
}

if (!existsSync(verificationPath)) {
  throw new Error(`Missing verification file: ${verificationPath}`);
}

const verification = JSON.parse(readFileSync(verificationPath, "utf8"));
const canonical = existsSync(canonicalPath)
  ? JSON.parse(readFileSync(canonicalPath, "utf8"))
  : { components: {} };

mkdirSync(historyDir, { recursive: true });
const snapshotId = nowId();
writeFileSync(
  resolve(historyDir, `pre-full-coverage-${snapshotId}.verification.json`),
  `${JSON.stringify(verification, null, 2)}\n`,
  "utf8",
);
writeFileSync(
  resolve(historyDir, `pre-full-coverage-${snapshotId}.canonical-nodes.json`),
  `${JSON.stringify(canonical, null, 2)}\n`,
  "utf8",
);

let resetCount = 0;
for (const entry of Object.values(verification.components ?? {})) {
  if (entry.status === "verified") {
    resetCount += 1;
  }
  entry.status = "unverified";
  entry.verifiedAt = null;
  entry.artifacts = {
    designContextPath: null,
    screenshotPath: null,
    variableDefsPath: null,
  };
}

verification.mode = "full-coverage-only";
verification.fullCoveragePolicy = "verified means full category coverage only (no canonical sample verification)";
verification.resetAt = new Date().toISOString();
verification.resetFromArchive = `figma-artifacts/history/pre-full-coverage-${snapshotId}.verification.json`;

const manifest = readFileSync(manifestPath, "utf8");
const rowRegex = /^\|\s*([^|]+?)\s*\|\s*`(\d+:\d+)`\s*\|\s*(https?:\/\/[^\s|]+)\s*\|$/gm;
const sequence = [];
let match;
while ((match = rowRegex.exec(manifest)) !== null) {
  sequence.push({
    category: match[1].trim(),
    categoryNode: match[2].trim(),
    figmaUrl: match[3].trim(),
  });
}

const first = sequence[0]?.categoryNode ?? null;

const workflow = {
  mode: "full-coverage-only",
  createdAt: new Date().toISOString(),
  noSamplePolicy: true,
  blocker: "Do not start next category until active category is fully complete and manually verified.",
  sequence,
  activeCategoryNode: first,
  completedCategoryNodes: [],
};

writeFileSync(verificationPath, `${JSON.stringify(verification, null, 2)}\n`, "utf8");
writeFileSync(canonicalPath, `${JSON.stringify({ components: {} }, null, 2)}\n`, "utf8");
writeFileSync(workflowPath, `${JSON.stringify(workflow, null, 2)}\n`, "utf8");

console.log(`Full coverage mode enforced. resetVerified=${resetCount} activeCategory=${first ?? "-"}`);
