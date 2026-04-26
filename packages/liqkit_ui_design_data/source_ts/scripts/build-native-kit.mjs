import {
  copyFileSync,
  existsSync,
  mkdirSync,
  readFileSync,
  readdirSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { dirname, resolve } from "node:path";

const root = process.cwd();
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const nativeDir = resolve(root, "figma-artifacts/native");
const outDir = resolve(root, "release/native");
const outComponentsDir = resolve(outDir, "components");
const outAssetsDir = resolve(outDir, "assets");

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
if (!Array.isArray(catalog)) {
  throw new Error("catalog.json must be an array");
}

rmSync(outDir, { recursive: true, force: true });
mkdirSync(outComponentsDir, { recursive: true });
mkdirSync(outAssetsDir, { recursive: true });

const bundledAssets = new Set();

function ensureDirForFile(filePath) {
  mkdirSync(dirname(filePath), { recursive: true });
}

function findEvidenceAssetPaths(content) {
  const matches = new Set();
  const pattern = /\/evidence\/figma-artifacts\/assets\/([a-z0-9\-_/\.]+)\b/gi;
  for (const match of content.matchAll(pattern)) {
    const rel = match[1];
    if (rel) {
      matches.add(rel);
    }
  }
  return [...matches];
}

function bundleAndRewriteAssetRefs(content) {
  let output = content;
  const refs = findEvidenceAssetPaths(content);
  for (const ref of refs) {
    const sourceAbs = resolve(root, "figma-artifacts/assets", ref);
    if (!existsSync(sourceAbs)) {
      throw new Error(`missing asset referenced by native source: figma-artifacts/assets/${ref}`);
    }
    const targetAbs = resolve(outAssetsDir, ref);
    ensureDirForFile(targetAbs);
    copyFileSync(sourceAbs, targetAbs);
    bundledAssets.add(`assets/${ref}`);
    output = output.replaceAll(
      `/evidence/figma-artifacts/assets/${ref}`,
      `../assets/${ref}`,
    );
  }
  output = output.replace(/href=(['"])\/evidence\/[^'"]+\1/gi, 'href="#"');
  return output;
}

const sharedFiles = readdirSync(nativeDir)
  .filter((name) => /^shared-.*\.(css|js)$/.test(name))
  .sort((a, b) => a.localeCompare(b));

for (const name of sharedFiles) {
  copyFileSync(resolve(nativeDir, name), resolve(outDir, name));
}

const combinedCssParts = [];
const componentManifest = [];

for (const item of catalog) {
  const htmlName = `${item.id}.html`;
  const cssName = `${item.id}.css`;
  const htmlSrc = resolve(nativeDir, htmlName);
  const cssSrc = resolve(nativeDir, cssName);

  if (!existsSync(htmlSrc) || !existsSync(cssSrc)) {
    throw new Error(`missing native files for ${item.id}`);
  }

  const htmlOut = resolve(outComponentsDir, htmlName);
  const cssOut = resolve(outComponentsDir, cssName);

  const htmlContentRaw = readFileSync(htmlSrc, "utf8");
  const cssContentRaw = readFileSync(cssSrc, "utf8");
  const htmlContent = bundleAndRewriteAssetRefs(htmlContentRaw);
  const cssContent = bundleAndRewriteAssetRefs(cssContentRaw);

  if (htmlContent.includes("/evidence/")) {
    throw new Error(`release HTML still contains /evidence/ paths for ${item.id}`);
  }
  if (cssContent.includes("/evidence/")) {
    throw new Error(`release CSS still contains /evidence/ paths for ${item.id}`);
  }

  writeFileSync(htmlOut, htmlContent, "utf8");
  writeFileSync(cssOut, cssContent, "utf8");

  const cssForBundle = cssContent.trim();
  if (cssForBundle.length > 0) {
    combinedCssParts.push(`/* component:${item.id} */\n${cssForBundle}`);
  }

  componentManifest.push({
    id: item.id,
    category: item.category,
    figmaNodeId: item.figmaNodeId,
    figmaUrl: item.figmaUrl,
    status: item.status,
    coverageNodeId: item.coverageNodeId ?? null,
    htmlPath: `components/${htmlName}`,
    cssPath: `components/${cssName}`,
    designContextPath: item.artifacts?.designContextPath ?? null,
    variableDefsPath: item.artifacts?.variableDefsPath ?? null,
    screenshotPath: item.artifacts?.screenshotPath ?? null,
  });
}

const sharedCssContent = sharedFiles
  .filter((name) => name.endsWith(".css"))
  .map((name) => {
    const content = readFileSync(resolve(nativeDir, name), "utf8").trim();
    return content.length > 0 ? `/* shared:${name} */\n${content}` : "";
  })
  .filter(Boolean)
  .join("\n\n");

const kitCss = [sharedCssContent, ...combinedCssParts].filter(Boolean).join("\n\n");
writeFileSync(resolve(outDir, "kit.css"), `${kitCss}\n`, "utf8");

const manifest = {
  generatedAt: new Date().toISOString(),
  components: componentManifest,
  bundledAssets: [...bundledAssets].sort((a, b) => a.localeCompare(b)),
  sharedFiles,
  kitCssPath: "kit.css",
};

writeFileSync(resolve(outDir, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`, "utf8");

const readme = `# Native Kit Bundle\n\nGenerated at ${manifest.generatedAt}.\n\n## Contents\n- \`kit.css\`: concatenated shared + component CSS bundle\n- \`manifest.json\`: component manifest with Figma mapping and artifact paths\n- \`shared-*.css/js\`: shared runtime and shared style primitives\n- \`components/*.html\`, \`components/*.css\`: per-component native source\n- \`assets/**\`: bundled local assets referenced by component HTML/CSS\n\nTotal components: ${componentManifest.length}\nBundled assets: ${manifest.bundledAssets.length}\n`;

writeFileSync(resolve(outDir, "README.md"), readme, "utf8");

console.log(`Native kit bundle generated: ${outDir}`);
console.log(`components=${componentManifest.length} shared=${sharedFiles.length}`);
