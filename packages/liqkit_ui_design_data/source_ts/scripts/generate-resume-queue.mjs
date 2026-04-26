import { existsSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function readJson(path) {
  return JSON.parse(readFileSync(path, "utf8"));
}

function latestInDir(dir, suffix) {
  if (!existsSync(dir)) {
    return null;
  }
  const names = readdirSync(dir).filter((name) => name.endsWith(suffix)).sort();
  return names.length ? resolve(dir, names[names.length - 1]) : null;
}

function readText(path) {
  if (!path || !existsSync(path)) {
    return "";
  }
  return readFileSync(path, "utf8");
}

function hasQuotaText(text) {
  return text.includes("reached the Figma MCP tool call limit");
}

function hasInvalidSelectionText(text) {
  return text.includes("You currently have nothing selected");
}

function summarizeStateFromStable(artifacts) {
  const designPath = artifacts?.designContextPath ?? null;
  const varsPath = artifacts?.variableDefsPath ?? null;
  const screenshotPath = artifacts?.screenshotPath ?? null;
  return {
    designPath,
    varsPath,
    screenshotPath,
    hasDesign: Boolean(designPath) && existsSync(resolve(root, designPath)),
    hasVars: Boolean(varsPath) && existsSync(resolve(root, varsPath)),
    hasScreenshot: Boolean(screenshotPath) && existsSync(resolve(root, screenshotPath)),
  };
}

function summarizeStateFromRaw(nodeId) {
  const dir = resolve(root, "figma-artifacts", "raw", slugNode(nodeId));
  const designPath = latestInDir(dir, ".get_design_context.txt");
  const varsPath = latestInDir(dir, ".get_variable_defs.txt");
  const screenshotPngPath = latestInDir(dir, ".get_screenshot.png");
  const screenshotTextPath = latestInDir(dir, ".get_screenshot.txt");
  const metadataPath = latestInDir(dir, ".get_metadata.txt");

  const designText = readText(designPath);
  const varsText = readText(varsPath);
  const screenshotText = readText(screenshotTextPath);
  const metadataText = readText(metadataPath);

  return {
    designPath,
    varsPath,
    screenshotPngPath,
    screenshotTextPath,
    metadataPath,
    hasDesign: Boolean(designPath) && !hasQuotaText(designText) && !hasInvalidSelectionText(designText),
    hasVars: Boolean(varsPath) && !hasQuotaText(varsText),
    hasScreenshot: Boolean(screenshotPngPath),
    designQuotaBlocked: hasQuotaText(designText),
    designSelectionMissing: hasInvalidSelectionText(designText),
    varsQuotaBlocked: hasQuotaText(varsText),
    screenshotQuotaBlocked: hasQuotaText(screenshotText),
    metadataQuotaBlocked: hasQuotaText(metadataText),
  };
}

const verification = readJson(resolve(root, "figma-artifacts", "verification.json"));
const canonical = readJson(resolve(root, "figma-artifacts", "canonical-nodes.json"));
const workflow = readJson(resolve(root, "figma-artifacts", "full-coverage-workflow.json"));

const sequence = workflow.sequence ?? [];
const activeNode = workflow.activeCategoryNode ?? null;

const rows = sequence.map((item) => {
  const node = item.categoryNode;
  const category = item.category;
  const verificationEntry = verification.components?.[node] ?? null;
  const status = verificationEntry?.status ?? "unverified";
  const canonicalNode = canonical.components?.[node]?.canonicalNode ?? null;
  const probeNode = canonicalNode ?? node;
  const raw = summarizeStateFromRaw(probeNode);
  const stable = summarizeStateFromStable(verificationEntry?.artifacts ?? null);
  return {
    category,
    node,
    status,
    canonicalNode,
    probeNode,
    stable,
    raw,
  };
});

const pending = rows.filter((row) => row.status !== "verified");
const active = rows.find((row) => row.node === activeNode) ?? pending[0] ?? null;
const maybeQuotaBlocked = pending.some(
  (row) =>
    row.raw.designQuotaBlocked ||
    row.raw.varsQuotaBlocked ||
    row.raw.screenshotQuotaBlocked ||
    row.raw.metadataQuotaBlocked,
);

const lines = [];
lines.push("# Resume Queue");
lines.push("");
lines.push(`Generated: ${new Date().toISOString()}`);
lines.push(`Active category node: ${active?.node ?? "-"}`);
lines.push(`MCP quota blocked signals detected: ${maybeQuotaBlocked ? "yes" : "no"}`);
lines.push("");
lines.push("## Pending Categories");
lines.push("| Category | Node | Canonical | Design | Vars | Screenshot | Notes |");
lines.push("|---|---|---|---|---|---|---|");

for (const row of pending) {
  const canonicalNode = row.canonicalNode ?? "-";
  const hasDesign = row.stable.hasDesign || row.raw.hasDesign;
  const hasVars = row.stable.hasVars || row.raw.hasVars;
  const hasScreenshot = row.stable.hasScreenshot || row.raw.hasScreenshot;
  const design = hasDesign ? "ready" : "missing";
  const vars = hasVars ? "ready" : "missing";
  const shot = hasScreenshot ? "ready" : "missing";
  const notes = [];
  if (!hasDesign && row.raw.designQuotaBlocked) {
    notes.push("design-context quota blocked");
  }
  if (!hasDesign && row.raw.designSelectionMissing) {
    notes.push("design-context returned empty selection");
  }
  if (!hasVars && row.raw.varsQuotaBlocked) {
    notes.push("variable-defs quota blocked");
  }
  if (!hasScreenshot && row.raw.screenshotQuotaBlocked) {
    notes.push("screenshot quota blocked");
  }
  if (row.raw.metadataQuotaBlocked) {
    notes.push("metadata quota blocked");
  }
  const readyCount = [hasDesign, hasVars, hasScreenshot].filter(Boolean).length;
  if (readyCount === 3 && row.node !== activeNode) {
    notes.push("ready to verify once active category is completed");
  }
  lines.push(
    `| ${row.category} | \`${row.node}\` | ${canonicalNode === "-" ? "-" : `\`${canonicalNode}\``} | ${design} | ${vars} | ${shot} | ${notes.join(", ") || "-"} |`,
  );
}

if (active) {
  const sourceNode = active.canonicalNode ?? active.node;
  lines.push("");
  lines.push("## Next Commands (After MCP Reset)");
  lines.push("```bash");
  lines.push(`cd ${root}`);
  lines.push(
    `# 1) Fetch missing MCP artifacts for active category ${active.category} (${active.node}) using node ${sourceNode}`,
  );
  lines.push("# 2) Persist session outputs");
  lines.push("npm run artifacts:extract");
  lines.push("npm run artifacts:extract:text");
  lines.push(`# 3) Finalize active category`);
  lines.push(
    `npm run artifacts:finalize -- --categoryNode ${active.node} --sourceNode ${sourceNode}`,
  );
  lines.push("# 4) Finalize any immediately-ready blocked categories in strict sequence");
  lines.push("npm run artifacts:finalize:ready-chain");
  lines.push("# 5) Regenerate status/preview/inventory");
  lines.push("npm run sync:status");
  lines.push("node scripts/generate-preview.mjs");
  lines.push("node scripts/generate-rendered-html.mjs");
  lines.push("npm run release:inventory");
  lines.push("npm run artifacts:persist");
  lines.push("```");
}

const outPath = resolve(root, "figma-artifacts", "RESUME_QUEUE.md");
writeFileSync(outPath, `${lines.join("\n")}\n`, "utf8");
console.log(`Resume queue generated: ${outPath}`);
