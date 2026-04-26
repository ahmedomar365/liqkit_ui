import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const reportPath = resolve(root, "figma-artifacts/full-metadata-coverage.json");

if (!existsSync(reportPath)) {
  throw new Error(
    "Missing full metadata coverage report: figma-artifacts/full-metadata-coverage.json. Run `npm run report:metadata:full` first.",
  );
}

const report = JSON.parse(readFileSync(reportPath, "utf8"));
const summary = report.summary ?? {};

const componentsWithMissing = Number(summary.componentsWithMissing ?? 0);
if (componentsWithMissing > 0) {
  const top = (report.components ?? [])
    .filter((item) => (item.missingCount ?? 0) > 0)
    .sort((a, b) => (b.missingCount ?? 0) - (a.missingCount ?? 0))
    .slice(0, 5)
    .map((item) => `${item.id}:${item.missingCount}`)
    .join(", ");
  throw new Error(
    `Full metadata coverage check failed. components_with_missing=${componentsWithMissing}. Top gaps: ${top}. See figma-artifacts/FULL_METADATA_COVERAGE.md`,
  );
}

const withoutRootMetadataCount = Number(summary.withoutRootMetadataCount ?? 0);
if (withoutRootMetadataCount > 0) {
  console.warn(
    `Full metadata coverage warning: categories without persisted root metadata=${withoutRootMetadataCount}. See figma-artifacts/FULL_METADATA_COVERAGE.md`,
  );
}

console.log(
  `Full metadata coverage check passed. with_root_metadata=${summary.withRootMetadataCount ?? 0} without_root_metadata=${withoutRootMetadataCount} components_with_missing=${componentsWithMissing}`,
);
