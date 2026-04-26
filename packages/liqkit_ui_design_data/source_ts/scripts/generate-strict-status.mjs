import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const verificationPath = resolve(root, "figma-artifacts/verification.json");
const canonicalPath = resolve(root, "figma-artifacts/canonical-nodes.json");
const statusPath = resolve(root, "STRICT_STATUS.md");
const fullWorkflowPath = resolve(root, "figma-artifacts/full-coverage-workflow.json");

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
const verification = JSON.parse(readFileSync(verificationPath, "utf8"));
const canonical = existsSync(canonicalPath)
  ? JSON.parse(readFileSync(canonicalPath, "utf8"))
  : { components: {} };
const fullWorkflow = existsSync(fullWorkflowPath)
  ? JSON.parse(readFileSync(fullWorkflowPath, "utf8"))
  : null;
const activeCategoryNode = fullWorkflow?.activeCategoryNode ?? null;
const completedCategoryNodes = new Set(fullWorkflow?.completedCategoryNodes ?? []);

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function artifactPathExists(relPath) {
  if (!relPath) {
    return false;
  }
  return existsSync(resolve(root, relPath));
}

function parseNodeIdFromArtifactPath(relPath) {
  if (!relPath) {
    return null;
  }
  const fileName = relPath.split("/").pop() ?? "";
  const match = fileName.match(/^(\d+)-(\d+)\./);
  if (!match) {
    return null;
  }
  return `${match[1]}:${match[2]}`;
}

function rootMetadataRelPath(component) {
  return `figma-artifacts/${component.id}/${slugNode(component.figmaNodeId)}.metadata.xml`;
}

function coverageLabel(categoryNode, canonicalNode, artifactNode) {
  if (!artifactNode) {
    return "unknown";
  }
  if (artifactNode === categoryNode) {
    return "category root";
  }
  if (artifactNode === canonicalNode) {
    return `canonical child (${artifactNode})`;
  }
  return `other node (${artifactNode})`;
}

const rows = catalog.map((component) => {
  const entry = verification.components[component.figmaNodeId] ?? component;
  const artifacts = entry.artifacts ?? {};
  const artifactCount = [
    artifactPathExists(artifacts.designContextPath),
    artifactPathExists(artifacts.screenshotPath),
    artifactPathExists(artifacts.variableDefsPath),
  ].filter(Boolean).length;
  const rootMetadataExists = artifactPathExists(rootMetadataRelPath(component));
  const canonicalNode = canonical.components[component.figmaNodeId]?.canonicalNode ?? "-";
  const artifactNode = parseNodeIdFromArtifactPath(artifacts.designContextPath)
    ?? parseNodeIdFromArtifactPath(artifacts.screenshotPath)
    ?? parseNodeIdFromArtifactPath(artifacts.variableDefsPath);
  const coverage = coverageLabel(
    component.figmaNodeId,
    canonicalNode === "-" ? component.figmaNodeId : canonicalNode,
    artifactNode,
  );
  let statusLabel = "unverified";
  if (entry.status === "verified") {
    statusLabel = artifactNode === component.figmaNodeId
      ? "verified (category root)"
      : rootMetadataExists
        ? "verified (canonical + root metadata)"
        : "verified (canonical coverage)";
  } else if (component.figmaNodeId === activeCategoryNode) {
    statusLabel = artifactCount === 3
      ? "ready_to_verify (active)"
      : "in_progress (strict sequence)";
  } else if (!completedCategoryNodes.has(component.figmaNodeId) && activeCategoryNode) {
    statusLabel = artifactCount === 3
      ? "ready_to_verify (blocked by active)"
      : "blocked (finish active category first)";
  }
  const rootMetadataLabel = rootMetadataExists ? "yes" : "no";
  return `| ${component.category} | ${component.figmaNodeId} | ${canonicalNode} | ${statusLabel} | ${coverage} | ${rootMetadataLabel} | ${artifactCount}/3 |`;
});

const verifiedCount = catalog.filter(
  (component) => verification.components[component.figmaNodeId]?.status === "verified",
).length;
const verifiedRootCount = catalog.filter((component) => {
  const entry = verification.components[component.figmaNodeId] ?? component;
  if (entry.status !== "verified") {
    return false;
  }
  const artifacts = entry.artifacts ?? {};
  const artifactNode = parseNodeIdFromArtifactPath(artifacts.designContextPath)
    ?? parseNodeIdFromArtifactPath(artifacts.screenshotPath)
    ?? parseNodeIdFromArtifactPath(artifacts.variableDefsPath);
  return artifactNode === component.figmaNodeId || artifactPathExists(rootMetadataRelPath(component));
}).length;

const markdown = `# Strict Verification Status\n\nVerified categories (all): ${verifiedCount}/${catalog.length}\nVerified categories (category root): ${verifiedRootCount}/${catalog.length}\n\nActive category: ${activeCategoryNode ?? "-"}\n\n| Category | Node | Canonical | Status | Coverage | Root metadata | Artifacts |\n|---|---|---|---|---|---|---|\n${rows.join("\n")}\n`;

writeFileSync(statusPath, markdown, "utf8");
console.log(`Strict status generated: ${statusPath}`);
