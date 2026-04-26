import { createHash } from "node:crypto";
import { existsSync, readFileSync, statSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const verificationPath = resolve(root, "figma-artifacts/verification.json");
const snapshotManifestPath = resolve(root, "preview/rendered/snapshots/index.json");
const nativeAuditPath = resolve(root, "NATIVE_IMAGE_AUDIT.md");
const nativeAuditMirrorPath = resolve(root, "preview/evidence/figma-artifacts/NATIVE_IMAGE_AUDIT.md");

const errors = [];

function fileHash(absPath) {
  const hash = createHash("sha256");
  hash.update(readFileSync(absPath));
  return hash.digest("hex");
}

function checkNonEmptyFile(absPath, label) {
  if (!existsSync(absPath)) {
    errors.push(`${label} missing: ${absPath}`);
    return false;
  }
  const size = statSync(absPath).size;
  if (size <= 0) {
    errors.push(`${label} empty: ${absPath}`);
    return false;
  }
  return true;
}

function toMirrorPathFromSourceRel(sourceRelPath) {
  if (!sourceRelPath.startsWith("figma-artifacts/")) {
    return null;
  }
  return sourceRelPath.replace(
    /^figma-artifacts\//,
    "preview/evidence/figma-artifacts/",
  );
}

function checkSourceMirrorPair(sourceRelPath, label) {
  const sourceAbsPath = resolve(root, sourceRelPath);
  if (!checkNonEmptyFile(sourceAbsPath, `${label} source`)) {
    return;
  }

  const mirrorRelPath = toMirrorPathFromSourceRel(sourceRelPath);
  if (!mirrorRelPath) {
    errors.push(`${label} has non-figma source path: ${sourceRelPath}`);
    return;
  }

  const mirrorAbsPath = resolve(root, mirrorRelPath);
  if (!checkNonEmptyFile(mirrorAbsPath, `${label} preview mirror`)) {
    return;
  }

  const sourceHash = fileHash(sourceAbsPath);
  const mirrorHash = fileHash(mirrorAbsPath);
  if (sourceHash !== mirrorHash) {
    errors.push(
      `${label} hash mismatch: ${sourceRelPath} != ${mirrorRelPath}`,
    );
  }
}

if (!existsSync(verificationPath)) {
  errors.push(`Missing verification ledger: ${verificationPath}`);
} else {
  const verification = JSON.parse(readFileSync(verificationPath, "utf8"));
  const components = Object.entries(verification.components ?? {}).filter(
    ([, entry]) => entry && entry.status === "verified",
  );

  const seenArtifactPaths = new Set();
  const seenComponentIds = new Set();

  for (const [nodeId, entry] of components) {
    const componentId = entry.id;
    if (!componentId || typeof componentId !== "string") {
      errors.push(`Verified node ${nodeId} is missing stable component id`);
      continue;
    }

    if (seenComponentIds.has(componentId)) {
      errors.push(`Duplicate verified component id detected: ${componentId}`);
    }
    seenComponentIds.add(componentId);

    const artifacts = entry.artifacts ?? {};
    const requiredArtifacts = [
      ["designContextPath", artifacts.designContextPath],
      ["screenshotPath", artifacts.screenshotPath],
      ["variableDefsPath", artifacts.variableDefsPath],
    ];

    for (const [key, relPath] of requiredArtifacts) {
      if (!relPath || typeof relPath !== "string") {
        errors.push(`Verified component ${componentId} missing ${key}`);
        continue;
      }
      seenArtifactPaths.add(relPath);
      checkSourceMirrorPair(relPath, `${componentId}.${key}`);
    }

    const nativeHtmlPath = resolve(root, `preview/rendered/source/${componentId}.native.html`);
    const nativeCssPath = resolve(root, `preview/rendered/source/${componentId}.native.css`);
    const renderPagePath = resolve(root, `preview/rendered/${componentId}.html`);
    const snapshotPath = resolve(root, `preview/rendered/snapshots/${componentId}.png`);

    checkNonEmptyFile(nativeHtmlPath, `${componentId}.nativeHtml`);
    checkNonEmptyFile(nativeCssPath, `${componentId}.nativeCss`);
    checkNonEmptyFile(renderPagePath, `${componentId}.renderedPage`);
    checkNonEmptyFile(snapshotPath, `${componentId}.renderedSnapshot`);
  }

  checkSourceMirrorPair(
    "figma-artifacts/native/STRICT_EXCEPTIONS.json",
    "native.strictExceptions",
  );

  if (existsSync(nativeAuditPath) || existsSync(nativeAuditMirrorPath)) {
    if (!existsSync(nativeAuditPath) || !existsSync(nativeAuditMirrorPath)) {
      errors.push(
        "Native image audit exists only on one side; run audit + render generation to sync mirrors",
      );
    } else {
      checkNonEmptyFile(nativeAuditPath, "nativeImageAudit.source");
      checkNonEmptyFile(nativeAuditMirrorPath, "nativeImageAudit.previewMirror");
      if (fileHash(nativeAuditPath) !== fileHash(nativeAuditMirrorPath)) {
        errors.push("Native image audit hash mismatch between source and preview mirror");
      }
    }
  }

  if (!checkNonEmptyFile(snapshotManifestPath, "renderedSnapshots.manifest")) {
    // no-op; error already recorded
  } else {
    const manifest = JSON.parse(readFileSync(snapshotManifestPath, "utf8"));
    if (manifest.total !== components.length) {
      errors.push(
        `Snapshot manifest total mismatch: expected ${components.length}, got ${manifest.total}`,
      );
    }
    if (manifest.failed !== 0) {
      errors.push(`Snapshot manifest reports failures: failed=${manifest.failed}`);
    }

    const entryIds = new Set((manifest.entries ?? []).map((entry) => entry.id));
    for (const componentId of seenComponentIds) {
      if (!entryIds.has(componentId)) {
        errors.push(`Snapshot manifest missing component id: ${componentId}`);
      }
    }
  }

  const sourceArtifactCount = seenArtifactPaths.size;
  const verifiedCount = seenComponentIds.size;

  if (errors.length > 0) {
    console.error("Evidence persistence check failed:");
    for (const error of errors) {
      console.error(`- ${error}`);
    }
    process.exit(1);
  }

  console.log(
    `Evidence persistence check passed. verified=${verifiedCount} mirrored_artifacts=${sourceArtifactCount}`,
  );
}
