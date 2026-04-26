import { execFileSync } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
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

function readJson(path) {
  return JSON.parse(readFileSync(path, "utf8"));
}

function artifactExists(root, relPath) {
  if (!relPath) {
    return false;
  }
  return existsSync(resolve(root, relPath));
}

const args = parseArgs(process.argv);
const dryRun = args.dryRun === "true";
const root = process.cwd();

const verificationPath = resolve(root, "figma-artifacts", "verification.json");
const workflowPath = resolve(root, "figma-artifacts", "full-coverage-workflow.json");
const canonicalPath = resolve(root, "figma-artifacts", "canonical-nodes.json");
const recordScriptPath = resolve(root, "scripts", "record-figma-artifact.mjs");

const canonical = readJson(canonicalPath);

function getReadyArtifacts(entry) {
  const artifacts = entry?.artifacts ?? {};
  const ready = artifactExists(root, artifacts.designContextPath)
    && artifactExists(root, artifacts.screenshotPath)
    && artifactExists(root, artifacts.variableDefsPath);
  return {
    ready,
    artifacts,
  };
}

if (dryRun) {
  const verification = readJson(verificationPath);
  const workflow = readJson(workflowPath);
  const sequence = Array.isArray(workflow.sequence) ? workflow.sequence : [];
  const completed = new Set(workflow.completedCategoryNodes ?? []);
  let active = workflow.activeCategoryNode ?? null;
  const wouldVerify = [];

  while (active) {
    const entry = verification.components?.[active];
    if (!entry || entry.status === "verified") {
      break;
    }
    const ready = getReadyArtifacts(entry);
    if (!ready.ready) {
      break;
    }
    wouldVerify.push(active);
    completed.add(active);
    const next = sequence.find((item) => !completed.has(item.categoryNode)) ?? null;
    active = next?.categoryNode ?? null;
  }

  console.log(`Dry run finalize chain. wouldVerify=${wouldVerify.length}`);
  for (const node of wouldVerify) {
    console.log(`- ${node}`);
  }
  process.exit(0);
}

let verifiedCount = 0;
while (true) {
  const verification = readJson(verificationPath);
  const workflow = readJson(workflowPath);
  const active = workflow.activeCategoryNode ?? null;
  if (!active) {
    break;
  }
  const entry = verification.components?.[active];
  if (!entry || entry.status === "verified") {
    break;
  }
  const ready = getReadyArtifacts(entry);
  if (!ready.ready) {
    break;
  }

  const canonicalNode = canonical.components?.[active]?.canonicalNode ?? active;
  execFileSync(
    process.execPath,
    [
      recordScriptPath,
      "--categoryNode",
      active,
      "--status",
      "verified",
      "--designContextPath",
      ready.artifacts.designContextPath,
      "--screenshotPath",
      ready.artifacts.screenshotPath,
      "--variableDefsPath",
      ready.artifacts.variableDefsPath,
      "--canonicalNode",
      canonicalNode,
      "--fullCoverageConfirmed",
      "true",
    ],
    { stdio: "inherit" },
  );
  verifiedCount += 1;
}

console.log(`Finalize ready chain complete. verified=${verifiedCount}`);
