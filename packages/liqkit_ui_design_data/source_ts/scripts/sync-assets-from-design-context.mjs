import { mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i += 1) {
    const key = argv[i];
    if (!key.startsWith("--")) {
      throw new Error(`Unexpected argument: ${key}`);
    }
    const value = argv[i + 1];
    if (!value || value.startsWith("--")) {
      throw new Error(`Missing value for argument: ${key}`);
    }
    args[key.slice(2)] = value;
    i += 1;
  }
  return args;
}

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function latestDesignContextPath(root, nodeId) {
  const dir = resolve(root, "figma-artifacts", "raw", slugNode(nodeId));
  const names = readdirSync(dir)
    .filter((name) => name.endsWith(".get_design_context.txt"))
    .sort();
  if (!names.length) {
    throw new Error(`No design-context files found for node ${nodeId}`);
  }
  return resolve(dir, names[names.length - 1]);
}

function extractAssetConsts(text) {
  const pattern = /^const\s+([A-Za-z0-9_]+)\s*=\s*"([^"]*\/api\/mcp\/asset\/[^"]+)";$/gm;
  const matches = [];
  let match;
  while ((match = pattern.exec(text)) !== null) {
    matches.push({ name: match[1], url: match[2] });
  }
  return matches;
}

function extensionForContentType(contentType) {
  const lower = String(contentType || "").toLowerCase();
  if (lower.includes("image/svg")) {
    return "svg";
  }
  if (lower.includes("image/png")) {
    return "png";
  }
  if (lower.includes("image/jpeg") || lower.includes("image/jpg")) {
    return "jpg";
  }
  if (lower.includes("image/webp")) {
    return "webp";
  }
  return "bin";
}

const args = parseArgs(process.argv);
const nodeId = args.nodeId;
const assetsId = args.assetsId;
if (!nodeId || !assetsId) {
  throw new Error("Usage: --nodeId <figmaNodeId> --assetsId <categorySlug>");
}

const root = process.cwd();
const designPath = latestDesignContextPath(root, nodeId);
const designText = readFileSync(designPath, "utf8");
const assets = extractAssetConsts(designText);
const outDir = resolve(root, "figma-artifacts", "assets", assetsId);
mkdirSync(outDir, { recursive: true });

const results = [];
for (const asset of assets) {
  const id = asset.url.split("/").pop();
  try {
    const response = await fetch(asset.url);
    const contentType = response.headers.get("content-type") || "application/octet-stream";
    const ext = extensionForContentType(contentType);
    const file = `${id}.${ext}`;
    const bytes = Buffer.from(await response.arrayBuffer());
    writeFileSync(resolve(outDir, file), bytes);
    results.push({
      name: asset.name,
      url: asset.url,
      status: "ok",
      contentType,
      file,
      size: bytes.byteLength,
      error: "",
    });
  } catch (error) {
    results.push({
      name: asset.name,
      url: asset.url,
      status: "error",
      contentType: "",
      file: "",
      size: 0,
      error: String(error?.message || error),
    });
  }
}

const manifest = {
  sourceNode: nodeId,
  generatedAt: new Date().toISOString(),
  designContextPath: designPath.replace(`${root}/`, ""),
  assets: results,
};

writeFileSync(resolve(outDir, "asset-map.json"), `${JSON.stringify(manifest, null, 2)}\n`, "utf8");
console.log(
  `Synced assets for ${nodeId} -> figma-artifacts/assets/${assetsId}. count=${results.length}`,
);
