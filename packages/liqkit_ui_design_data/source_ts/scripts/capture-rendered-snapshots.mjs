import { existsSync, mkdirSync, readdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";
import { spawnSync } from "node:child_process";

const cwd = process.cwd();
const root = existsSync(resolve(cwd, "packages/components-html/src/catalog.json"))
  ? cwd
  : resolve(cwd, "ios-26");
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const renderedDir = resolve(root, "preview/rendered");
const snapshotsDir = resolve(renderedDir, "snapshots");
const manifestPath = resolve(snapshotsDir, "index.json");
const reportPath = resolve(snapshotsDir, "SNAPSHOT_REPORT.md");
const baseUrl = process.env.IOS26_PREVIEW_BASE_URL || "http://127.0.0.1:4173";
const browsers = ["webkit", "chromium"];

if (!existsSync(catalogPath)) {
  throw new Error(`Missing catalog: ${catalogPath}`);
}

if (!existsSync(renderedDir)) {
  throw new Error(`Missing rendered dir: ${renderedDir}`);
}

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
if (!Array.isArray(catalog)) {
  throw new Error("catalog.json must be an array");
}

rmSync(snapshotsDir, { recursive: true, force: true });
mkdirSync(snapshotsDir, { recursive: true });

let installLog = null;
if (process.env.IOS26_SKIP_PLAYWRIGHT_INSTALL !== "1") {
  const installProc = spawnSync(
    "npx",
    ["--yes", "playwright", "install", ...browsers],
    {
      cwd: root,
      encoding: "utf8",
    },
  );
  installLog = {
    status: installProc.status,
    stdout: (installProc.stdout || "").trim().slice(0, 12000),
    stderr: (installProc.stderr || "").trim().slice(0, 12000),
  };
}

const entries = [];
for (const item of catalog) {
  const id = String(item.id || "").trim();
  if (!id) {
    continue;
  }

  const renderedHtmlAbs = resolve(renderedDir, `${id}.html`);
  const renderedHtmlRel = `preview/rendered/${id}.html`;
  const pngRel = `preview/rendered/snapshots/${id}.png`;
  const pngAbs = resolve(root, pngRel);
  const url = `${baseUrl}/rendered/${id}.html`;

  const entry = {
    id,
    category: item.category ?? id,
    renderedHtml: renderedHtmlRel,
    screenshot: pngRel,
    url,
    status: "pending",
    browser: null,
    error: null,
  };

  if (!existsSync(renderedHtmlAbs)) {
    entry.status = "missing-rendered-html";
    entries.push(entry);
    continue;
  }

  let captured = false;
  for (const browser of browsers) {
    const proc = spawnSync(
      "npx",
      [
        "--yes",
        "playwright",
        "screenshot",
        "--browser",
        browser,
        "--viewport-size",
        "1512,982",
        "--wait-for-timeout",
        "300",
        "--full-page",
        url,
        pngAbs,
      ],
      {
        cwd: root,
        encoding: "utf8",
      },
    );

    if (proc.status === 0 && existsSync(pngAbs)) {
      entry.status = "ok";
      entry.browser = browser;
      captured = true;
      break;
    }

    entry.error = (proc.stderr || proc.stdout || "").trim().slice(0, 6000);
  }

  if (!captured) {
    entry.status = "capture-failed";
  }

  entries.push(entry);
}

const okCount = entries.filter((entry) => entry.status === "ok").length;
const failCount = entries.length - okCount;

const manifest = {
  generatedAt: new Date().toISOString(),
  root,
  baseUrl,
  installLog,
  total: entries.length,
  ok: okCount,
  failed: failCount,
  entries,
};

writeFileSync(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`, "utf8");

const reportLines = [
  "# Rendered Snapshot Report",
  "",
  `Generated: ${manifest.generatedAt}`,
  `Base URL: ${baseUrl}`,
  `Total: ${manifest.total}`,
  `OK: ${manifest.ok}`,
  `Failed: ${manifest.failed}`,
  "",
  "| Category | Id | Status | Browser | Rendered | Snapshot |",
  "|---|---|---|---|---|---|",
];

for (const entry of entries) {
  const renderedLink = `[open](/${entry.renderedHtml})`;
  const snapshotLink =
    entry.status === "ok" ? `[open](/${entry.screenshot})` : (entry.error ? "`error`" : "`n/a`");
  reportLines.push(
    `| ${String(entry.category)} | \`${entry.id}\` | ${entry.status} | ${entry.browser ?? "-"} | ${renderedLink} | ${snapshotLink} |`,
  );
}

writeFileSync(reportPath, `${reportLines.join("\n")}\n`, "utf8");

console.log(`Rendered snapshots captured. ok=${okCount} failed=${failCount}`);
console.log(`Manifest: ${manifestPath}`);
console.log(`Report: ${reportPath}`);

if (failCount > 0) {
  const failedIds = entries.filter((entry) => entry.status !== "ok").map((entry) => entry.id);
  throw new Error(`Snapshot capture failed for: ${failedIds.join(", ")}`);
}
