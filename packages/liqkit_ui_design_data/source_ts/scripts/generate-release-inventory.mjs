import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const canonicalPath = resolve(root, "figma-artifacts/canonical-nodes.json");
const contextIndexPath = resolve(root, "figma-artifacts/context-index.json");
const fullWorkflowPath = resolve(root, "figma-artifacts/full-coverage-workflow.json");

const outDir = resolve(root, "release");
const outJsonPath = resolve(outDir, "inventory.json");
const outMdPath = resolve(root, "RELEASE_INVENTORY.md");

mkdirSync(outDir, { recursive: true });

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
if (!Array.isArray(catalog)) {
  throw new Error("catalog.json must be an array");
}

const canonical = existsSync(canonicalPath)
  ? JSON.parse(readFileSync(canonicalPath, "utf8"))
  : { components: {} };

const contextIndex = existsSync(contextIndexPath)
  ? JSON.parse(readFileSync(contextIndexPath, "utf8"))
  : { latestSnapshotId: null, snapshots: [] };

const latestSnapshotId = contextIndex.latestSnapshotId ?? null;
const snapshotRecords = Array.isArray(contextIndex.snapshots) ? contextIndex.snapshots : [];
const latestSnapshot = snapshotRecords.find((item) => item.snapshotId === latestSnapshotId) ?? null;
const fullWorkflow = existsSync(fullWorkflowPath)
  ? JSON.parse(readFileSync(fullWorkflowPath, "utf8"))
  : null;
const activeCategoryNode = fullWorkflow?.activeCategoryNode ?? null;
const completedCategoryNodes = new Set(fullWorkflow?.completedCategoryNodes ?? []);

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

function resolveCoverage(categoryNodeId, canonicalNodeId, artifactNodeId) {
  if (!artifactNodeId) {
    return {
      key: "unknown",
      label: "unknown",
    };
  }
  if (artifactNodeId === categoryNodeId) {
    return {
      key: "category-root",
      label: `category root (${artifactNodeId})`,
    };
  }
  if (artifactNodeId === canonicalNodeId) {
    return {
      key: "canonical-node",
      label: `canonical child (${artifactNodeId})`,
    };
  }
  return {
    key: "other-node",
    label: `other node (${artifactNodeId})`,
  };
}

function relExists(relPath) {
  if (!relPath) {
    return false;
  }
  return existsSync(resolve(root, relPath));
}

const entries = catalog.map((item) => {
  const designContextPath = item.artifacts?.designContextPath ?? null;
  const screenshotPath = item.artifacts?.screenshotPath ?? null;
  const variableDefsPath = item.artifacts?.variableDefsPath ?? null;

  const artifactsExist = {
    designContext: relExists(designContextPath),
    screenshot: relExists(screenshotPath),
    variableDefs: relExists(variableDefsPath),
  };

  const presentArtifactCount = Object.values(artifactsExist).filter(Boolean).length;
  const canonicalNode = canonical.components?.[item.figmaNodeId]?.canonicalNode ?? null;
  const artifactNodeId = parseNodeIdFromArtifactPath(designContextPath)
    ?? parseNodeIdFromArtifactPath(screenshotPath)
    ?? parseNodeIdFromArtifactPath(variableDefsPath);
  const coverage = resolveCoverage(item.figmaNodeId, canonicalNode ?? item.figmaNodeId, artifactNodeId);
  const statusLabelForUnverified = item.figmaNodeId === activeCategoryNode
    ? (presentArtifactCount === 3
      ? "ready_to_verify (active)"
      : "in_progress (strict sequence)")
    : !completedCategoryNodes.has(item.figmaNodeId) && activeCategoryNode
      ? (presentArtifactCount === 3
        ? "ready_to_verify (blocked by active)"
        : "blocked (finish active first)")
      : "unverified";
  const statusLabel = item.status === "verified"
    ? (coverage.key === "category-root"
      ? "verified (category root)"
      : "verified (canonical coverage)")
    : statusLabelForUnverified;

  return {
    id: item.id,
    category: item.category,
    figmaNodeId: item.figmaNodeId,
    figmaUrl: item.figmaUrl,
    status: item.status,
    statusLabel,
    verifiedAt: item.verifiedAt,
    canonicalNode,
    coverage: {
      key: coverage.key,
      label: coverage.label,
      artifactNodeId,
    },
    artifacts: {
      designContextPath,
      screenshotPath,
      variableDefsPath,
      exists: artifactsExist,
      presentCount: presentArtifactCount,
      expectedCount: 3,
    },
    renderPage: relExists(`preview/rendered/${item.id}.html`)
      ? `preview/rendered/${item.id}.html`
      : null,
    nativeSource: {
      htmlPath: `preview/rendered/source/${item.id}.native.html`,
      cssPath: `preview/rendered/source/${item.id}.native.css`,
      exists: {
        html: relExists(`preview/rendered/source/${item.id}.native.html`),
        css: relExists(`preview/rendered/source/${item.id}.native.css`),
      },
    },
    evidenceAnchor: `preview/index.html#${item.id}`,
  };
});

const total = entries.length;
const verified = entries.filter((item) => item.status === "verified").length;
const verifiedCategoryRoot = entries.filter(
  (item) => item.status === "verified" && item.coverage.key === "category-root",
).length;
const verifiedCanonicalOnly = entries.filter(
  (item) => item.status === "verified" && item.coverage.key === "canonical-node",
).length;
const unverified = total - verified;

const invalidVerified = entries.filter(
  (item) => item.status === "verified" && item.artifacts.presentCount < 3,
);

const releaseInventory = {
  generatedAt: new Date().toISOString(),
  verificationScope: "strict canonical-node evidence, category-root where available",
  source: {
    catalogPath: "packages/components-html/src/catalog.json",
    canonicalPath: "figma-artifacts/canonical-nodes.json",
    contextIndexPath: "figma-artifacts/context-index.json",
  },
  summary: {
    total,
    verified,
    verifiedCategoryRoot,
    verifiedCanonicalOnly,
    unverified,
    verificationPercent: total === 0 ? 0 : Number(((verified / total) * 100).toFixed(2)),
    invalidVerifiedCount: invalidVerified.length,
    releaseReadiness: verified === total && invalidVerified.length === 0 ? "ready" : "in_progress",
  },
  snapshot: {
    latestSnapshotId,
    latestSnapshot,
    totalSnapshots: snapshotRecords.length,
  },
  workflow: {
    activeCategoryNode,
    completedCategoryNodes: [...completedCategoryNodes],
    blocker: fullWorkflow?.blocker ?? null,
  },
  entries,
};

writeFileSync(outJsonPath, `${JSON.stringify(releaseInventory, null, 2)}\n`, "utf8");

const tableRows = entries
  .map((item) => {
    const artifacts = `${item.artifacts.presentCount}/${item.artifacts.expectedCount}`;
    const canonicalNode = item.canonicalNode ?? "-";
    const render = item.renderPage ? `\`${item.renderPage}\`` : "-";
    const nativeSource = item.nativeSource.exists.html && item.nativeSource.exists.css
      ? `\`${item.nativeSource.htmlPath}\` + \`${item.nativeSource.cssPath}\``
      : "-";
    return `| ${item.category} | \`${item.figmaNodeId}\` | ${canonicalNode === "-" ? "-" : `\`${canonicalNode}\``} | ${item.statusLabel} | ${item.coverage.label} | ${artifacts} | ${render} | ${nativeSource} | ${item.figmaUrl} |`;
  })
  .join("\n");

const md = `# Release Inventory\n\nGenerated: ${releaseInventory.generatedAt}\n\n## Summary\n- Total categories: ${total}\n- Verified: ${verified}\n- Verified (category root): ${verifiedCategoryRoot}\n- Verified (canonical child only): ${verifiedCanonicalOnly}\n- Unverified: ${unverified}\n- Verification: ${releaseInventory.summary.verificationPercent}%\n- Verification scope: ${releaseInventory.verificationScope}\n- Release readiness: ${releaseInventory.summary.releaseReadiness}\n- Latest snapshot: ${latestSnapshotId ?? "none"}\n\n## Category Matrix\n| Category | Node | Canonical | Status | Coverage | Artifacts | Render Page | Native Source | Figma URL |\n|---|---|---|---|---|---|---|---|---|\n${tableRows}\n\n## Machine-readable Inventory\n- JSON: \`release/inventory.json\`\n`; 

writeFileSync(outMdPath, md, "utf8");

console.log(`Release inventory generated: ${outJsonPath}`);
console.log(`Release inventory markdown: ${outMdPath}`);
