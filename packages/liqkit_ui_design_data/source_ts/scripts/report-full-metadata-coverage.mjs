import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const verificationPath = resolve(root, "figma-artifacts/verification.json");
const outputMdPath = resolve(root, "figma-artifacts/FULL_METADATA_COVERAGE.md");
const outputJsonPath = resolve(root, "figma-artifacts/full-metadata-coverage.json");

const verification = JSON.parse(readFileSync(verificationPath, "utf8"));

function stripLedgerBlocks(html) {
  return html
    .replace(/<!-- ios26:missing-node-anchors:start -->[\s\S]*?<!-- ios26:missing-node-anchors:end -->/g, "")
    .replace(/<!-- ios26:metadata-node-anchors:start -->[\s\S]*?<!-- ios26:metadata-node-anchors:end -->/g, "");
}

const components = [];
for (const [rootNodeId, component] of Object.entries(verification.components ?? {})) {
  const slug = rootNodeId.replaceAll(":", "-");
  const metadataRel = `figma-artifacts/${component.id}/${slug}.metadata.xml`;
  const htmlRel = `figma-artifacts/native/${component.id}.html`;
  const metadataPath = resolve(root, metadataRel);
  const htmlPath = resolve(root, htmlRel);

  if (!existsSync(metadataPath) || !existsSync(htmlPath)) {
    components.push({
      id: component.id,
      category: component.category,
      rootNodeId,
      hasRootMetadata: false,
      metadataPath: existsSync(metadataPath) ? metadataRel : null,
      htmlPath: existsSync(htmlPath) ? htmlRel : null,
      requiredCount: 0,
      coveredCount: 0,
      missingCount: 0,
      missing: [],
    });
    continue;
  }

  const metadataXml = readFileSync(metadataPath, "utf8");
  const html = stripLedgerBlocks(readFileSync(htmlPath, "utf8"));
  const required = [...metadataXml.matchAll(/\sid="([^"]+)"\s+name="([^"]*)"/g)].map((m) => ({
    id: m[1],
    name: m[2],
  }));
  const coveredNodeIds = new Set([...html.matchAll(/data-node-id="([^"]+)"/g)].map((m) => m[1]));
  const missing = required.filter((entry) => !coveredNodeIds.has(entry.id));

  components.push({
    id: component.id,
    category: component.category,
    rootNodeId,
    hasRootMetadata: true,
    metadataPath: metadataRel,
    htmlPath: htmlRel,
    requiredCount: required.length,
    coveredCount: coveredNodeIds.size,
    missingCount: missing.length,
    missing: missing.slice(0, 32),
  });
}

components.sort((a, b) => b.missingCount - a.missingCount || a.id.localeCompare(b.id));

const withMetadata = components.filter((item) => item.hasRootMetadata);
const withoutMetadata = components.filter((item) => !item.hasRootMetadata);
const summary = {
  generatedAt: new Date().toISOString(),
  componentCount: components.length,
  withRootMetadataCount: withMetadata.length,
  withoutRootMetadataCount: withoutMetadata.length,
  componentsWithMissing: withMetadata.filter((item) => item.missingCount > 0).length,
  totalMissing: withMetadata.reduce((sum, item) => sum + item.missingCount, 0),
};

const md = [];
md.push("# Full Metadata Coverage");
md.push("");
md.push(`Generated: ${summary.generatedAt}`);
md.push("");
md.push(`- Components: ${summary.componentCount}`);
md.push(`- Components with root metadata persisted: ${summary.withRootMetadataCount}`);
md.push(`- Components without root metadata persisted: ${summary.withoutRootMetadataCount}`);
md.push(`- Components with missing node IDs (among persisted root metadata): ${summary.componentsWithMissing}`);
md.push(`- Total missing node IDs (among persisted root metadata): ${summary.totalMissing}`);
md.push("");
md.push("| Category | Id | Root Node | Root Metadata | Required | Covered | Missing |");
md.push("|---|---|---|---|---:|---:|---:|");
for (const item of components) {
  md.push(
    `| ${item.category} | \`${item.id}\` | \`${item.rootNodeId}\` | ${item.hasRootMetadata ? "yes" : "no"} | ${item.requiredCount} | ${item.coveredCount} | ${item.missingCount} |`,
  );
}

if (summary.componentsWithMissing > 0) {
  md.push("");
  md.push("## Missing Node Details");
  for (const item of withMetadata.filter((entry) => entry.missingCount > 0)) {
    md.push("");
    md.push(`### ${item.category} (\`${item.id}\`)`);
    for (const missing of item.missing) {
      md.push(`- \`${missing.id}\` ${missing.name}`);
    }
  }
}

if (withoutMetadata.length > 0) {
  md.push("");
  md.push("## Categories Without Root Metadata");
  for (const item of withoutMetadata) {
    md.push(`- ${item.category} (\`${item.id}\`) root \`${item.rootNodeId}\``);
  }
}

writeFileSync(outputMdPath, `${md.join("\n")}\n`, "utf8");
writeFileSync(
  outputJsonPath,
  `${JSON.stringify({ summary, components }, null, 2)}\n`,
  "utf8",
);
console.log(`Full metadata coverage report written: ${outputMdPath}`);
