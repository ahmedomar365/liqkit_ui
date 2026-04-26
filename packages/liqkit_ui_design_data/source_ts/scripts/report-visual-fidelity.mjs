import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { resolve } from "node:path";

const cwd = process.cwd();
const root = existsSync(resolve(cwd, "package.json")) ? cwd : resolve(cwd, "ios-26");
const inventoryPath = resolve(root, "release/inventory.json");
const outJsonPath = resolve(root, "figma-artifacts/visual-fidelity.json");
const outMdPath = resolve(root, "figma-artifacts/VISUAL_FIDELITY_REPORT.md");

if (!existsSync(inventoryPath)) {
  throw new Error("Missing release/inventory.json. Run `npm run release:inventory` first.");
}

const inventory = JSON.parse(readFileSync(inventoryPath, "utf8"));
const entries = Array.isArray(inventory.entries) ? inventory.entries : [];

function runSsim(renderPath, screenshotPath) {
  const args = [
    "-hide_banner",
    "-nostats",
    "-loop",
    "1",
    "-i",
    renderPath,
    "-loop",
    "1",
    "-i",
    screenshotPath,
    "-filter_complex",
    "[1:v][0:v]scale2ref[ref][render];[render][ref]ssim[out]",
    "-map",
    "[out]",
    "-frames:v",
    "1",
    "-f",
    "null",
    "-",
  ];
  const result = spawnSync("ffmpeg", args, { encoding: "utf8" });
  const combined = `${result.stdout ?? ""}\n${result.stderr ?? ""}`;
  const match = combined.match(/All:([0-9.]+)/);
  return match ? Number(match[1]) : null;
}

function scoreLabel(ssim) {
  if (typeof ssim !== "number") return "missing";
  if (ssim >= 0.8) return "strong";
  if (ssim >= 0.7) return "good";
  if (ssim >= 0.6) return "moderate";
  return "needs-review";
}

const rows = [];
for (const entry of entries) {
  const screenshotRel = entry?.artifacts?.screenshotPath ?? null;
  const fidelityRenderRel = `preview/rendered/fidelity-snapshots/${entry.id}.png`;
  const defaultRenderRel = `preview/rendered/snapshots/${entry.id}.png`;
  const fidelityRenderAbs = resolve(root, fidelityRenderRel);
  const defaultRenderAbs = resolve(root, defaultRenderRel);
  const useFidelitySnapshot = existsSync(fidelityRenderAbs);
  const renderRel = useFidelitySnapshot ? fidelityRenderRel : defaultRenderRel;
  const renderAbs = useFidelitySnapshot ? fidelityRenderAbs : defaultRenderAbs;
  const screenshotAbs = screenshotRel ? resolve(root, screenshotRel) : null;

  const renderExists = existsSync(renderAbs);
  const screenshotExists = screenshotAbs ? existsSync(screenshotAbs) : false;
  const ssim = renderExists && screenshotExists ? runSsim(renderAbs, screenshotAbs) : null;

  rows.push({
    id: entry.id,
    category: entry.category,
    figmaNodeId: entry.figmaNodeId,
    screenshotPath: screenshotRel,
    renderSnapshotPath: renderRel,
    renderSnapshotMode: useFidelitySnapshot ? "fidelity" : "rendered",
    screenshotExists,
    renderExists,
    ssim,
    score: scoreLabel(ssim),
  });
}

rows.sort((a, b) => {
  const as = typeof a.ssim === "number" ? a.ssim : -1;
  const bs = typeof b.ssim === "number" ? b.ssim : -1;
  return as - bs;
});

const summary = {
  generatedAt: new Date().toISOString(),
  total: rows.length,
  compared: rows.filter((row) => typeof row.ssim === "number").length,
  missing: rows.filter((row) => typeof row.ssim !== "number").length,
  strong: rows.filter((row) => row.score === "strong").length,
  good: rows.filter((row) => row.score === "good").length,
  moderate: rows.filter((row) => row.score === "moderate").length,
  needsReview: rows.filter((row) => row.score === "needs-review").length,
};

writeFileSync(outJsonPath, `${JSON.stringify({ summary, rows }, null, 2)}\n`, "utf8");

const md = [
  "# Visual Fidelity Report",
  "",
  `Generated: ${summary.generatedAt}`,
  "",
  `- Total categories: ${summary.total}`,
  `- Compared (render + screenshot present): ${summary.compared}`,
  `- Missing comparisons: ${summary.missing}`,
  `- Strong (SSIM >= 0.80): ${summary.strong}`,
  `- Good (SSIM >= 0.70): ${summary.good}`,
  `- Moderate (SSIM >= 0.60): ${summary.moderate}`,
  `- Needs review (SSIM < 0.60): ${summary.needsReview}`,
  "",
  "> SSIM is a guidance metric only. Use screenshot + rendered pages for final visual sign-off.",
  "",
  "| Category | Id | Node | SSIM | Score | Render Snapshot | Mode | Figma Screenshot |",
  "|---|---|---|---:|---|---|---|---|",
  ...rows.map((row) => {
    const ssimCell = typeof row.ssim === "number" ? row.ssim.toFixed(6) : "n/a";
    const renderCell = row.renderExists ? `\`${row.renderSnapshotPath}\`` : "`missing`";
    const shotCell = row.screenshotExists && row.screenshotPath ? `\`${row.screenshotPath}\`` : "`missing`";
    return `| ${row.category} | \`${row.id}\` | \`${row.figmaNodeId}\` | ${ssimCell} | ${row.score} | ${renderCell} | ${row.renderSnapshotMode} | ${shotCell} |`;
  }),
  "",
].join("\n");

writeFileSync(outMdPath, `${md}\n`, "utf8");

console.log(`Visual fidelity report written: ${outMdPath}`);
console.log(`Visual fidelity json written: ${outJsonPath}`);
