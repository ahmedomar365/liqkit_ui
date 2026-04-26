import { createHash } from "node:crypto";
import {
  copyFileSync,
  existsSync,
  mkdirSync,
  readdirSync,
  readFileSync,
  writeFileSync,
} from "node:fs";
import { dirname, resolve } from "node:path";

const root = process.cwd();
const artifactsRoot = resolve(root, "figma-artifacts");
const verificationPath = resolve(artifactsRoot, "verification.json");
const canonicalPath = resolve(artifactsRoot, "canonical-nodes.json");
const screenshotIndexPath = resolve(artifactsRoot, "screenshot-index.json");
const strictProgressPath = resolve(artifactsRoot, "STRICT_PROGRESS.md");
const contextIndexPath = resolve(artifactsRoot, "context-index.json");

if (!existsSync(verificationPath)) {
  throw new Error(`Missing verification file: ${verificationPath}`);
}

const verification = JSON.parse(readFileSync(verificationPath, "utf8"));
const components = verification.components ?? {};

const artifactOwners = new Map();
const componentById = new Map(
  Object.entries(components).map(([categoryNode, entry]) => [
    entry.id,
    {
      categoryNode,
      id: entry.id,
      category: entry.category,
      status: entry.status,
    },
  ]),
);

function collectArtifactFiles(dir, acc) {
  const entries = readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const absPath = resolve(dir, entry.name);
    if (entry.isDirectory()) {
      if (absPath.includes("/figma-artifacts/snapshots")) {
        continue;
      }
      collectArtifactFiles(absPath, acc);
      continue;
    }
    if (entry.isFile()) {
      const relPath = absPath.replace(`${root}/`, "");
      acc.add(relPath);
    }
  }
}

const trackedRelPaths = new Set();
collectArtifactFiles(artifactsRoot, trackedRelPaths);

function collectPath(relPath, acc) {
  const absPath = resolve(root, relPath);
  if (!existsSync(absPath)) {
    return;
  }

  const stats = readdirSync(absPath, { withFileTypes: true });
  for (const entry of stats) {
    const entryAbs = resolve(absPath, entry.name);
    const entryRel = entryAbs.replace(`${root}/`, "");
    if (entry.isDirectory()) {
      if (entryAbs.includes("/figma-artifacts/snapshots")) {
        continue;
      }
      collectPath(entryRel, acc);
      continue;
    }
    if (entry.isFile()) {
      acc.add(entryRel);
    }
  }
}

const additionalFiles = [
  "README.md",
  "LICENSE",
  "COMPREHENSIVE_PLAN.md",
  "FIGMA_NODE_MANIFEST.md",
  "ENGINEERING_GUARDRAILS.md",
  "STRICT_STATUS.md",
  "RELEASE_INVENTORY.md",
  "package.json",
  "preview/index.html",
  "release/inventory.json",
];

for (const relPath of additionalFiles) {
  const absPath = resolve(root, relPath);
  if (existsSync(absPath)) {
    trackedRelPaths.add(relPath);
  }
}

collectPath("preview/rendered", trackedRelPaths);
collectPath("scripts", trackedRelPaths);
collectPath("packages/components-html/src", trackedRelPaths);

for (const [categoryNode, entry] of Object.entries(components)) {
  const paths = [
    entry?.artifacts?.designContextPath,
    entry?.artifacts?.screenshotPath,
    entry?.artifacts?.variableDefsPath,
  ].filter((value) => typeof value === "string");

  for (const relPath of paths) {
    trackedRelPaths.add(relPath);
    const owners = artifactOwners.get(relPath) ?? [];
    owners.push({
      categoryNode,
      id: entry.id,
      category: entry.category,
      status: entry.status,
    });
    artifactOwners.set(relPath, owners);
  }
}

function sha256(buffer) {
  return createHash("sha256").update(buffer).digest("hex");
}

function inferGeneratedOwners(relPath) {
  const sourceMatch = relPath.match(/^preview\/rendered\/source\/(.+)\.native\.(html|css)$/);
  if (sourceMatch) {
    const id = sourceMatch[1];
    const owner = componentById.get(id);
    if (owner) {
      return [owner];
    }
  }

  const renderMatch = relPath.match(/^preview\/rendered\/(.+)\.html$/);
  if (renderMatch && renderMatch[1] !== "index") {
    const id = renderMatch[1];
    const owner = componentById.get(id);
    if (owner) {
      return [owner];
    }
  }

  return [];
}

function normalizeSnapshotId(date) {
  return date.toISOString().replaceAll(":", "-").replaceAll(".", "-");
}

const snapshotId = normalizeSnapshotId(new Date());
const snapshotRoot = resolve(artifactsRoot, "snapshots", snapshotId);
mkdirSync(snapshotRoot, { recursive: true });

const present = [];
const missing = [];

for (const relPath of [...trackedRelPaths].sort()) {
  const absPath = resolve(root, relPath);
  if (!existsSync(absPath)) {
    missing.push(relPath);
    continue;
  }

  const content = readFileSync(absPath);
  const targetPath = resolve(snapshotRoot, relPath);
  mkdirSync(dirname(targetPath), { recursive: true });
  copyFileSync(absPath, targetPath);

  const figmaOwners = artifactOwners.get(relPath) ?? [];
  const generatedOwners = inferGeneratedOwners(relPath);
  const owners = figmaOwners.length > 0 ? figmaOwners : generatedOwners;
  const sourceType = figmaOwners.length > 0 ? "figma" : generatedOwners.length > 0 ? "generated" : "project";

  present.push({
    path: relPath,
    sha256: sha256(content),
    bytes: content.byteLength,
    sourceType,
    owners,
  });
}

const snapshotManifest = {
  snapshotId,
  generatedAt: new Date().toISOString(),
  sourceRoot: root,
  files: present,
  missing,
};

writeFileSync(
  resolve(snapshotRoot, "snapshot-manifest.json"),
  `${JSON.stringify(snapshotManifest, null, 2)}\n`,
  "utf8",
);

const contextIndex = existsSync(contextIndexPath)
  ? JSON.parse(readFileSync(contextIndexPath, "utf8"))
  : { latestSnapshotId: null, snapshots: [] };

const nextSnapshots = Array.isArray(contextIndex.snapshots)
  ? contextIndex.snapshots
  : [];
nextSnapshots.push({
  snapshotId,
  generatedAt: snapshotManifest.generatedAt,
  fileCount: present.length,
  missingCount: missing.length,
  path: `figma-artifacts/snapshots/${snapshotId}`,
});

const nextIndex = {
  latestSnapshotId: snapshotId,
  snapshots: nextSnapshots,
};

writeFileSync(contextIndexPath, `${JSON.stringify(nextIndex, null, 2)}\n`, "utf8");

const latestPointer = [
  `snapshotId=${snapshotId}`,
  `generatedAt=${snapshotManifest.generatedAt}`,
  `path=figma-artifacts/snapshots/${snapshotId}`,
].join("\n");
writeFileSync(resolve(artifactsRoot, "LATEST_SNAPSHOT"), `${latestPointer}\n`, "utf8");

const optionalState = [canonicalPath, screenshotIndexPath, strictProgressPath].filter((path) =>
  existsSync(path),
);

console.log(
  `Persisted Figma context snapshot. snapshot=${snapshotId} files=${present.length} missing=${missing.length} optionalState=${optionalState.length}`,
);
