import { existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";
import { spawnSync } from "node:child_process";

const cwd = process.cwd();
const root = existsSync(resolve(cwd, "packages/components-html/src/catalog.json"))
  ? cwd
  : resolve(cwd, "ios-26");
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const renderedDir = resolve(root, "preview/rendered");
const snapshotsDir = resolve(renderedDir, "fidelity-snapshots");
const manifestPath = resolve(snapshotsDir, "index.json");
const reportPath = resolve(snapshotsDir, "SNAPSHOT_REPORT.md");
const baseUrl = process.env.IOS26_PREVIEW_BASE_URL || "http://127.0.0.1:4173";
const browsers = ["webkit", "chromium"];

if (!existsSync(catalogPath)) {
  throw new Error(`Missing catalog: ${catalogPath}`);
}

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
if (!Array.isArray(catalog)) {
  throw new Error("catalog.json must be an array");
}

rmSync(snapshotsDir, { recursive: true, force: true });
mkdirSync(snapshotsDir, { recursive: true });

let installLog = null;
if (process.env.IOS26_SKIP_PLAYWRIGHT_INSTALL !== "1") {
  const installProc = spawnSync("npx", ["--yes", "playwright", "install", ...browsers], {
    cwd: root,
    encoding: "utf8",
  });
  installLog = {
    status: installProc.status,
    stdout: (installProc.stdout || "").trim().slice(0, 12000),
    stderr: (installProc.stderr || "").trim().slice(0, 12000),
  };
}

const entries = [];
const precisionViewportIds = new Set(["buttons", "examples", "widgets", "windows"]);

function resolveScreenshotSize(screenshotPath) {
  if (!screenshotPath) {
    return null;
  }
  const abs = resolve(root, screenshotPath);
  if (!existsSync(abs)) {
    return null;
  }
  const probe = spawnSync("sips", ["-g", "pixelWidth", "-g", "pixelHeight", abs], {
    cwd: root,
    encoding: "utf8",
  });
  if (probe.status !== 0) {
    return null;
  }
  const output = `${probe.stdout || ""}\n${probe.stderr || ""}`;
  const widthMatch = output.match(/pixelWidth:\s*(\d+)/);
  const heightMatch = output.match(/pixelHeight:\s*(\d+)/);
  if (!widthMatch || !heightMatch) {
    return null;
  }
  const width = Number.parseInt(widthMatch[1], 10);
  const height = Number.parseInt(heightMatch[1], 10);
  if (!Number.isFinite(width) || !Number.isFinite(height) || width <= 0 || height <= 0) {
    return null;
  }
  return { width, height };
}

for (const item of catalog) {
  const id = String(item.id || "").trim();
  if (!id) continue;

  const renderedHtmlAbs = resolve(renderedDir, `${id}.html`);
  const renderedHtmlRel = `preview/rendered/${id}.html`;
  const pngRel = `preview/rendered/fidelity-snapshots/${id}.png`;
  const pngAbs = resolve(root, pngRel);
  const url = `${baseUrl}/rendered/${id}.html?view=fidelity`;
  const usePrecisionViewport = precisionViewportIds.has(id);
  const targetSize = usePrecisionViewport
    ? (resolveScreenshotSize(item?.artifacts?.screenshotPath) ?? { width: 1512, height: 982 })
    : { width: 1512, height: 982 };

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
    const args = [
      "--yes",
      "playwright",
      "screenshot",
      "--browser",
      browser,
      "--viewport-size",
      `${targetSize.width},${targetSize.height}`,
      "--wait-for-selector",
      ".component-root",
      "--wait-for-timeout",
      "1200",
    ];
    if (!usePrecisionViewport) {
      args.push("--full-page");
    }
    args.push(url, pngAbs);
    const proc = spawnSync("npx", args, {
      cwd: root,
      encoding: "utf8",
    });

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
  mode: "fidelity",
  installLog,
  total: entries.length,
  ok: okCount,
  failed: failCount,
  entries,
};

writeFileSync(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`, "utf8");

const reportLines = [
  "# Fidelity Snapshot Report",
  "",
  `Generated: ${manifest.generatedAt}`,
  `Base URL: ${baseUrl}`,
  `Mode: ${manifest.mode}`,
  `Total: ${manifest.total}`,
  `OK: ${manifest.ok}`,
  `Failed: ${manifest.failed}`,
  "",
  "| Category | Id | Status | Browser | Rendered | Fidelity Snapshot |",
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

console.log(`Fidelity snapshots captured. ok=${okCount} failed=${failCount}`);
console.log(`Manifest: ${manifestPath}`);
console.log(`Report: ${reportPath}`);

if (failCount > 0) {
  const failedIds = entries.filter((entry) => entry.status !== "ok").map((entry) => entry.id);
  throw new Error(`Fidelity snapshot capture failed for: ${failedIds.join(", ")}`);
}
