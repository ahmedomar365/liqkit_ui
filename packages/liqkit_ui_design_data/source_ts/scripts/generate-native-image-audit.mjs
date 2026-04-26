import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const cwd = process.cwd();
const root = existsSync(resolve(cwd, "packages/components-html/src/catalog.json"))
  ? cwd
  : resolve(cwd, "ios-26");
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const nativeDir = resolve(root, "figma-artifacts/native");
const exceptionsPath = resolve(root, "figma-artifacts/native/STRICT_EXCEPTIONS.json");
const outputPath = resolve(root, "NATIVE_IMAGE_AUDIT.md");

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
const exceptionsRaw = existsSync(exceptionsPath)
  ? JSON.parse(readFileSync(exceptionsPath, "utf8"))
  : {};
const assetBackedComponents =
  exceptionsRaw && typeof exceptionsRaw === "object" && exceptionsRaw.assetBackedComponents
    ? exceptionsRaw.assetBackedComponents
    : {};

const rows = [];
let totalImg = 0;
let totalSvg = 0;
let totalObject = 0;
let totalHtmlUrl = 0;
let totalCssUrl = 0;

const today = new Date().toISOString().slice(0, 10);

for (const item of catalog) {
  const htmlPath = resolve(nativeDir, `${item.id}.html`);
  const cssPath = resolve(nativeDir, `${item.id}.css`);
  if (!existsSync(htmlPath)) {
    rows.push({
      category: item.category,
      id: item.id,
      imgCount: 0,
      objectCount: 0,
      svgCount: 0,
      htmlUrlCount: 0,
      cssUrlCount: 0,
      exception: "no",
      assets: "missing native html",
    });
    continue;
  }

  const html = readFileSync(htmlPath, "utf8");
  const css = existsSync(cssPath) ? readFileSync(cssPath, "utf8") : "";
  const imgMatches = [...html.matchAll(/<img\b[^>]*\bsrc="([^"]+)"/g)];
  const objectMatches = [...html.matchAll(/<object\b[^>]*\bdata="([^"]+)"/g)];
  const svgMatches = [...html.matchAll(/<svg\b/g)];
  const htmlUrlMatches = [...html.matchAll(/url\(\s*["']?([^"')]+)["']?\s*\)/gi)];
  const cssUrlMatches = [...css.matchAll(/url\(\s*["']?([^"')]+)["']?\s*\)/gi)];

  const imgCount = imgMatches.length;
  const objectCount = objectMatches.length;
  const svgCount = svgMatches.length;
  const htmlUrlCount = htmlUrlMatches.length;
  const cssUrlCount = cssUrlMatches.length;
  totalImg += imgCount;
  totalObject += objectCount;
  totalSvg += svgCount;
  totalHtmlUrl += htmlUrlCount;
  totalCssUrl += cssUrlCount;

  const assets = [...imgMatches, ...objectMatches, ...htmlUrlMatches, ...cssUrlMatches]
    .map((match) => String(match[1] ?? "").trim())
    .filter((value) => value.length > 0)
    .join("<br />");

  const exceptionConfig = assetBackedComponents[item.id] ?? null;
  const allowedPrefixes = [];
  if (exceptionConfig && typeof exceptionConfig === "object") {
    if (typeof exceptionConfig.allowedUrlPrefix === "string" && exceptionConfig.allowedUrlPrefix.length > 0) {
      allowedPrefixes.push(exceptionConfig.allowedUrlPrefix);
    }
    if (Array.isArray(exceptionConfig.allowedUrlPrefixes)) {
      for (const prefix of exceptionConfig.allowedUrlPrefixes) {
        if (typeof prefix === "string" && prefix.length > 0) {
          allowedPrefixes.push(prefix);
        }
      }
    }
  }

  const localAssetRoot =
    exceptionConfig && typeof exceptionConfig.localAssetRoot === "string"
      ? resolve(root, exceptionConfig.localAssetRoot)
      : null;
  const missingAssetRefs = [];
  for (const match of htmlUrlMatches) {
    const value = String(match[1] ?? "").trim();
    const matchedPrefix = allowedPrefixes.find((prefix) => value.startsWith(prefix));
    if (!matchedPrefix || !localAssetRoot) {
      continue;
    }
    const relativePath = value.slice(matchedPrefix.length);
    if (!existsSync(resolve(localAssetRoot, relativePath))) {
      missingAssetRefs.push(relativePath);
    }
  }

  const missingAssetsText = missingAssetRefs.length > 0
    ? `<br /><strong>Missing files:</strong><br />${missingAssetRefs.join("<br />")}`
    : "";

  rows.push({
    category: item.category,
    id: item.id,
    imgCount,
    objectCount,
    svgCount,
    htmlUrlCount,
    cssUrlCount,
    exception: exceptionConfig ? "yes" : "no",
    assets: `${assets || "-"}${missingAssetsText}`,
  });
}

const markdown = `# Native Image Audit

Generated on ${today} from \`figma-artifacts/native/*.html\`.

- Components: ${catalog.length}
- Total \`<img>\` tags: ${totalImg}
- Total \`<object>\` tags: ${totalObject}
- Total inline \`<svg>\` tags: ${totalSvg}
- Total HTML \`url(...)\` refs: ${totalHtmlUrl}
- Total CSS \`url(...)\` refs: ${totalCssUrl}
- Strict exceptions file: \`${existsSync(exceptionsPath) ? "figma-artifacts/native/STRICT_EXCEPTIONS.json" : "none"}\`

| Category | Id | IMG refs | OBJECT refs | Inline SVG | HTML url refs | CSS url refs | Exception | Asset sources |
|---|---|---:|---:|---:|---:|---:|---|---|
${rows
  .map(
    (row) =>
      `| ${row.category} | \`${row.id}\` | ${row.imgCount} | ${row.objectCount} | ${row.svgCount} | ${row.htmlUrlCount} | ${row.cssUrlCount} | ${row.exception} | ${row.assets} |`,
  )
  .join("\n")}
`;

writeFileSync(outputPath, markdown, "utf8");
console.log(`Native image audit written: ${outputPath}`);
