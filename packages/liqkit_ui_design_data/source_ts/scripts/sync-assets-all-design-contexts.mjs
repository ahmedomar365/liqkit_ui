import { existsSync, mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { basename, resolve } from "node:path";

const cwd = process.cwd();
const root = existsSync(resolve(cwd, "packages/components-html/src/catalog.json"))
  ? cwd
  : resolve(cwd, "ios-26");
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const figmaArtifactsDir = resolve(root, "figma-artifacts");
const assetsRoot = resolve(figmaArtifactsDir, "assets");

const EXCLUDED_DIRS = new Set(["assets", "native", "raw", "snapshots"]);
const ASSET_CONST_RE = /^const\s+([A-Za-z0-9_]+)\s*=\s*"([^"]*\/api\/mcp\/asset\/([^"\/]+))";$/gm;

function extensionForContentType(contentType) {
  const lower = String(contentType || "").toLowerCase();
  if (lower.includes("image/svg")) return "svg";
  if (lower.includes("image/png")) return "png";
  if (lower.includes("image/jpeg") || lower.includes("image/jpg")) return "jpg";
  if (lower.includes("image/webp")) return "webp";
  if (lower.includes("image/gif")) return "gif";
  return "bin";
}

async function fetchWithTimeout(url, timeoutMs = 15000) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(new Error(`timeout ${timeoutMs}ms`)), timeoutMs);
  try {
    return await fetch(url, { signal: controller.signal });
  } finally {
    clearTimeout(timer);
  }
}

function parseAssetConsts(text, sourceRelPath) {
  const items = [];
  let match = ASSET_CONST_RE.exec(text);
  while (match) {
    items.push({
      constName: match[1],
      url: match[2],
      assetId: match[3],
      sourceRelPath,
    });
    match = ASSET_CONST_RE.exec(text);
  }
  return items;
}

function collectCategoryDirs() {
  const catalogIds = existsSync(catalogPath)
    ? new Set(
        (JSON.parse(readFileSync(catalogPath, "utf8")) || [])
          .map((item) => (item && typeof item.id === "string" ? item.id.trim() : ""))
          .filter(Boolean),
      )
    : null;

  return readdirSync(figmaArtifactsDir, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name)
    .filter((name) => !EXCLUDED_DIRS.has(name))
    .filter((name) => (catalogIds ? catalogIds.has(name) : true))
    .sort((a, b) => a.localeCompare(b));
}

function listDesignContextFiles(categoryDirAbs) {
  return readdirSync(categoryDirAbs)
    .filter((name) => name.endsWith(".design-context.txt"))
    .sort((a, b) => a.localeCompare(b));
}

function findExistingAssetFile(outDir, assetId) {
  if (!existsSync(outDir)) return null;
  const found = readdirSync(outDir).find((name) => name === `${assetId}.png` || name === `${assetId}.svg` || name === `${assetId}.jpg` || name === `${assetId}.webp` || name === `${assetId}.gif` || name.startsWith(`${assetId}.`));
  return found ? resolve(outDir, found) : null;
}

async function syncCategoryAssets(category) {
  const categoryDirAbs = resolve(figmaArtifactsDir, category);
  const outDir = resolve(assetsRoot, category);
  mkdirSync(outDir, { recursive: true });

  const designFiles = listDesignContextFiles(categoryDirAbs);
  const byAssetId = new Map();
  const sourceRelPaths = [];

  for (const fileName of designFiles) {
    const sourceAbsPath = resolve(categoryDirAbs, fileName);
    const sourceRelPath = `figma-artifacts/${category}/${fileName}`;
    sourceRelPaths.push(sourceRelPath);
    const text = readFileSync(sourceAbsPath, "utf8");
    const consts = parseAssetConsts(text, sourceRelPath);
    for (const item of consts) {
      if (!byAssetId.has(item.assetId)) {
        byAssetId.set(item.assetId, {
          assetId: item.assetId,
          urls: new Set(),
          constNames: new Set(),
          sources: new Set(),
        });
      }
      const row = byAssetId.get(item.assetId);
      row.urls.add(item.url);
      row.constNames.add(item.constName);
      row.sources.add(item.sourceRelPath);
    }
  }

  const results = [];
  let downloaded = 0;
  let existing = 0;
  let failed = 0;

  const assets = [...byAssetId.values()].sort((a, b) => a.assetId.localeCompare(b.assetId));
  for (const asset of assets) {
    const urls = [...asset.urls];
    const primaryUrl = urls[0] || "";
    const existingFileAbs = findExistingAssetFile(outDir, asset.assetId);
    if (existingFileAbs) {
      const size = statSync(existingFileAbs).size;
      existing += 1;
      results.push({
        id: asset.assetId,
        status: "ok",
        syncStatus: "existing",
        file: basename(existingFileAbs),
        filePath: existingFileAbs.replace(`${root}/`, ""),
        size,
        contentType: "",
        url: primaryUrl,
        urls,
        constNames: [...asset.constNames].sort(),
        sources: [...asset.sources].sort(),
        error: "",
      });
      continue;
    }

    try {
      const response = await fetchWithTimeout(primaryUrl, 15000);
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      const contentType = response.headers.get("content-type") || "application/octet-stream";
      const ext = extensionForContentType(contentType);
      const outRel = `figma-artifacts/assets/${category}/${asset.assetId}.${ext}`;
      const outAbs = resolve(root, outRel);
      const bytes = Buffer.from(await response.arrayBuffer());
      writeFileSync(outAbs, bytes);
      downloaded += 1;
      results.push({
        id: asset.assetId,
        status: "ok",
        syncStatus: "downloaded",
        file: `${asset.assetId}.${ext}`,
        filePath: outRel,
        size: bytes.byteLength,
        contentType,
        url: primaryUrl,
        urls,
        constNames: [...asset.constNames].sort(),
        sources: [...asset.sources].sort(),
        error: "",
      });
    } catch (error) {
      failed += 1;
      results.push({
        id: asset.assetId,
        status: "error",
        file: "",
        size: 0,
        contentType: "",
        url: primaryUrl,
        urls,
        constNames: [...asset.constNames].sort(),
        sources: [...asset.sources].sort(),
        error: String(error?.message || error),
      });
    }
  }

  const manifest = {
    category,
    generatedAt: new Date().toISOString(),
    sourceFiles: sourceRelPaths,
    totalAssets: results.length,
    downloaded,
    existing,
    failed,
    assets: results,
  };
  writeFileSync(resolve(outDir, "asset-map.json"), `${JSON.stringify(manifest, null, 2)}\n`, "utf8");

  return manifest;
}

const categories = collectCategoryDirs();
const manifests = [];
for (const category of categories) {
  const manifest = await syncCategoryAssets(category);
  manifests.push(manifest);
  console.log(
    `assets:${category} total=${manifest.totalAssets} downloaded=${manifest.downloaded} existing=${manifest.existing} failed=${manifest.failed}`,
  );
}

const totalAssets = manifests.reduce((sum, item) => sum + item.totalAssets, 0);
const totalDownloaded = manifests.reduce((sum, item) => sum + item.downloaded, 0);
const totalExisting = manifests.reduce((sum, item) => sum + item.existing, 0);
const totalFailed = manifests.reduce((sum, item) => sum + item.failed, 0);

const summary = {
  generatedAt: new Date().toISOString(),
  categories: manifests.length,
  totalAssets,
  downloaded: totalDownloaded,
  existing: totalExisting,
  failed: totalFailed,
  manifests: manifests.map((item) => ({
    category: item.category,
    totalAssets: item.totalAssets,
    downloaded: item.downloaded,
    existing: item.existing,
    failed: item.failed,
    manifestPath: `figma-artifacts/assets/${item.category}/asset-map.json`,
  })),
};
writeFileSync(resolve(assetsRoot, "asset-sync-summary.json"), `${JSON.stringify(summary, null, 2)}\n`, "utf8");

const mdLines = [
  "# Asset Sync Summary",
  "",
  `Generated: ${summary.generatedAt}`,
  `Categories: ${summary.categories}`,
  `Total assets: ${summary.totalAssets}`,
  `Downloaded now: ${summary.downloaded}`,
  `Already existing: ${summary.existing}`,
  `Failed: ${summary.failed}`,
  "",
  "| Category | Total | Downloaded | Existing | Failed | Manifest |",
  "|---|---:|---:|---:|---:|---|",
];

for (const row of summary.manifests.sort((a, b) => a.category.localeCompare(b.category))) {
  mdLines.push(
    `| ${row.category} | ${row.totalAssets} | ${row.downloaded} | ${row.existing} | ${row.failed} | \`${row.manifestPath}\` |`,
  );
}

writeFileSync(resolve(assetsRoot, "ASSET_SYNC_SUMMARY.md"), `${mdLines.join("\n")}\n`, "utf8");

console.log(
  `Asset sync complete. categories=${summary.categories} total=${summary.totalAssets} downloaded=${summary.downloaded} existing=${summary.existing} failed=${summary.failed}`,
);
