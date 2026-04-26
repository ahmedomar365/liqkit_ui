import { createHash } from "node:crypto";
import { existsSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const verificationPath = resolve(root, "figma-artifacts/verification.json");
const outputPath = resolve(root, "figma-artifacts/ARTIFACT_DIGESTS.json");

if (!existsSync(verificationPath)) {
  throw new Error(`Missing verification ledger: ${verificationPath}`);
}

const verification = JSON.parse(readFileSync(verificationPath, "utf8"));
const components = verification.components ?? {};

function hashFile(absPath) {
  const hash = createHash("sha256");
  hash.update(readFileSync(absPath));
  return hash.digest("hex");
}

const entries = [];

for (const [categoryNodeId, component] of Object.entries(components)) {
  if (!component || component.status !== "verified") {
    continue;
  }

  const componentId = component.id;
  const category = component.category;
  const artifacts = component.artifacts ?? {};
  const artifactPairs = [
    ["designContextPath", artifacts.designContextPath],
    ["screenshotPath", artifacts.screenshotPath],
    ["variableDefsPath", artifacts.variableDefsPath],
  ];

  for (const [artifactType, relPath] of artifactPairs) {
    if (!relPath || typeof relPath !== "string") {
      throw new Error(`Verified component ${componentId} missing ${artifactType}`);
    }

    const absPath = resolve(root, relPath);
    if (!existsSync(absPath)) {
      throw new Error(`Missing artifact for ${componentId}.${artifactType}: ${relPath}`);
    }

    entries.push({
      componentId,
      category,
      categoryNodeId,
      artifactType,
      path: relPath,
      bytes: statSync(absPath).size,
      sha256: hashFile(absPath),
    });
  }
}

entries.sort((a, b) => {
  if (a.componentId !== b.componentId) {
    return a.componentId.localeCompare(b.componentId);
  }
  if (a.artifactType !== b.artifactType) {
    return a.artifactType.localeCompare(b.artifactType);
  }
  return a.path.localeCompare(b.path);
});

const output = {
  generatedAt: new Date().toISOString(),
  source: "figma-artifacts/verification.json",
  entryCount: entries.length,
  entries,
};

writeFileSync(outputPath, `${JSON.stringify(output, null, 2)}\n`, "utf8");
console.log(`Artifact digests updated: ${outputPath} entries=${entries.length}`);
