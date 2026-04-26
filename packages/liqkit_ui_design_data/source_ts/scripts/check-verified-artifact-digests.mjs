import { createHash } from "node:crypto";
import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const verificationPath = resolve(root, "figma-artifacts/verification.json");
const digestPath = resolve(root, "figma-artifacts/ARTIFACT_DIGESTS.json");

if (!existsSync(verificationPath)) {
  throw new Error(`Missing verification ledger: ${verificationPath}`);
}
if (!existsSync(digestPath)) {
  throw new Error(
    `Missing digest ledger: ${digestPath}. Run: npm run artifacts:digests:update`,
  );
}

const verification = JSON.parse(readFileSync(verificationPath, "utf8"));
const digestLedger = JSON.parse(readFileSync(digestPath, "utf8"));
const digestEntries = Array.isArray(digestLedger.entries) ? digestLedger.entries : [];

function hashFile(absPath) {
  const hash = createHash("sha256");
  hash.update(readFileSync(absPath));
  return hash.digest("hex");
}

const expected = [];
for (const [categoryNodeId, component] of Object.entries(verification.components ?? {})) {
  if (!component || component.status !== "verified") {
    continue;
  }
  const componentId = component.id;
  const artifacts = component.artifacts ?? {};
  for (const [artifactType, relPath] of [
    ["designContextPath", artifacts.designContextPath],
    ["screenshotPath", artifacts.screenshotPath],
    ["variableDefsPath", artifacts.variableDefsPath],
  ]) {
    if (!relPath || typeof relPath !== "string") {
      throw new Error(`Verified component ${componentId} missing ${artifactType}`);
    }
    expected.push({
      key: `${componentId}|${artifactType}|${relPath}`,
      componentId,
      categoryNodeId,
      artifactType,
      path: relPath,
    });
  }
}

expected.sort((a, b) => a.key.localeCompare(b.key));

const byKey = new Map();
for (const row of digestEntries) {
  const key = `${row.componentId}|${row.artifactType}|${row.path}`;
  byKey.set(key, row);
}

const errors = [];

for (const item of expected) {
  const row = byKey.get(item.key);
  if (!row) {
    errors.push(`Missing digest entry: ${item.key}`);
    continue;
  }

  const absPath = resolve(root, item.path);
  if (!existsSync(absPath)) {
    errors.push(`Missing artifact file: ${item.path}`);
    continue;
  }

  const currentHash = hashFile(absPath);
  if (currentHash !== row.sha256) {
    errors.push(`Hash mismatch: ${item.key}`);
  }
}

for (const row of digestEntries) {
  const key = `${row.componentId}|${row.artifactType}|${row.path}`;
  if (!expected.find((item) => item.key === key)) {
    errors.push(`Stale digest entry: ${key}`);
  }
}

if (errors.length > 0) {
  console.error("Verified artifact digest check failed:");
  for (const error of errors) {
    console.error(`- ${error}`);
  }
  console.error("Run: npm run artifacts:digests:update");
  process.exit(1);
}

console.log(`Verified artifact digest check passed. entries=${expected.length}`);
