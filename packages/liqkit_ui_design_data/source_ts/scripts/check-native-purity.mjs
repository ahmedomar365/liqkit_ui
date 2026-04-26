import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

const cwd = process.cwd();
const root = existsSync(resolve(cwd, "packages/components-html/src/catalog.json"))
  ? cwd
  : resolve(cwd, "ios-26");
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const nativeDir = resolve(root, "figma-artifacts/native");
const exceptionsPath = resolve(root, "figma-artifacts/native/STRICT_EXCEPTIONS.json");

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
if (!Array.isArray(catalog)) {
  throw new Error("catalog.json must be an array");
}

const errors = [];
const runtimeUsage = {
  evidence: false,
  assetGallery: false,
  appIconsRuntime: false,
  examplesRuntime: false,
};

function pushError(filePath, message) {
  errors.push(`${filePath}: ${message}`);
}

function hasPattern(content, pattern) {
  return pattern.test(content);
}

function resolveAllowedPrefixes(exceptionConfig) {
  const allowedPrefixes = [];
  if (!exceptionConfig || typeof exceptionConfig !== "object") {
    return allowedPrefixes;
  }
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
  return allowedPrefixes;
}

function isInlineDataImage(referenced) {
  return /^data:image\/[a-z0-9.+-]+(?:;charset=[^;,]+)?(?:;base64)?,/i.test(String(referenced || "").trim());
}

const exceptionsRaw = existsSync(exceptionsPath)
  ? JSON.parse(readFileSync(exceptionsPath, "utf8"))
  : {};
const assetBackedComponents =
  exceptionsRaw && typeof exceptionsRaw === "object" && exceptionsRaw.assetBackedComponents
    ? exceptionsRaw.assetBackedComponents
    : {};
const allowAssetBackedExceptions = process.env.IOS26_ALLOW_ASSET_BACKED_EXCEPTIONS === "1";

if (!allowAssetBackedExceptions && Object.keys(assetBackedComponents).length > 0) {
  pushError(
    exceptionsPath,
    `strict mode requires zero asset-backed exceptions (found ${Object.keys(assetBackedComponents).length}). ` +
      "Set IOS26_ALLOW_ASSET_BACKED_EXCEPTIONS=1 to bypass intentionally.",
  );
}

const expectedAssetsByComponent = new Map();
for (const [componentId, config] of Object.entries(assetBackedComponents)) {
  if (!config || typeof config !== "object" || typeof config.assetMapPath !== "string") {
    continue;
  }
  const assetMapPath = resolve(root, config.assetMapPath);
  if (!existsSync(assetMapPath)) {
    continue;
  }
  const raw = JSON.parse(readFileSync(assetMapPath, "utf8"));
  const assets = Array.isArray(raw?.assets) ? raw.assets : [];
  expectedAssetsByComponent.set(
    componentId,
    new Set(
      assets
        .filter((asset) => asset && asset.status === "ok" && typeof asset.file === "string")
        .map((asset) => asset.file),
    ),
  );
}

const htmlAssetRefCountByComponent = new Map();

for (const item of catalog) {
  const htmlPath = resolve(nativeDir, `${item.id}.html`);
  const cssPath = resolve(nativeDir, `${item.id}.css`);

  if (!existsSync(htmlPath) || !existsSync(cssPath)) {
    continue;
  }

  const html = readFileSync(htmlPath, "utf8");
  const css = readFileSync(cssPath, "utf8");

  if (!hasPattern(html, /data-node-id="\d+:\d+"/)) {
    pushError(htmlPath, "missing data-node-id attribute");
  }

  if (hasPattern(html, /https?:\/\//i)) {
    pushError(htmlPath, "native HTML must not reference remote URLs");
  }

  if (hasPattern(html, /&#8984;|&#x2318;|\u2318/i)) {
    pushError(htmlPath, "native HTML must not rely on command glyph text; use inline SVG shortcut icon");
  }

  const inlineSvgBlocks = [...html.matchAll(/<svg\b[\s\S]*?<\/svg>/gi)]
    .map((match) => String(match[0]))
    .filter((svg) => !/<use\b/i.test(svg));
  const inlineSvgCounts = new Map();
  for (const svg of inlineSvgBlocks) {
    const normalized = svg.replace(/\s+/g, " ").trim();
    inlineSvgCounts.set(normalized, (inlineSvgCounts.get(normalized) ?? 0) + 1);
  }
  const duplicateInlineSvgCounts = [...inlineSvgCounts.values()].filter((count) => count > 1);
  if (duplicateInlineSvgCounts.length > 0) {
    const maxRepeat = Math.max(...duplicateInlineSvgCounts);
    pushError(
      htmlPath,
      `duplicate inline SVG blocks detected (${duplicateInlineSvgCounts.length} duplicate kinds, max repeat ${maxRepeat}); move repeated SVG geometry into shared <symbol> defs and use <use>`,
    );
  }

  if (item.id === "menu" || item.id === "context-menu") {
    if (
      hasPattern(
        html,
        /<svg[^>]*class="[^"]*ios26-menu-icon-svg--(?:star|dashed-square|action|chevron|command)[^"]*"[^>]*>\s*<(?:path|rect|circle)\b/is,
      )
    ) {
      pushError(
        htmlPath,
        "menu/context icons must use <use> references to shared symbol defs (no inline geometry in repeated icon svgs)",
      );
    }

    if (!hasPattern(html, /id="ios26-symbol-command"/i)) {
      pushError(htmlPath, "menu/context file missing shared symbol definition: ios26-symbol-command");
    }

    if (item.id === "menu") {
      if (!hasPattern(html, /id="ios26-symbol-star"/i)) {
        pushError(htmlPath, "menu file missing shared symbol definition: ios26-symbol-star");
      }
      if (!hasPattern(html, /id="ios26-symbol-dashed-square"/i)) {
        pushError(htmlPath, "menu file missing shared symbol definition: ios26-symbol-dashed-square");
      }
      if (!hasPattern(html, /id="ios26-symbol-chevron"/i)) {
        pushError(htmlPath, "menu file missing shared symbol definition: ios26-symbol-chevron");
      }
    }

    if (item.id === "context-menu") {
      if (!hasPattern(html, /id="ios26-symbol-action"/i)) {
        pushError(htmlPath, "context-menu file missing shared symbol definition: ios26-symbol-action");
      }
      if (!hasPattern(html, /id="ios26-symbol-chevron"/i)) {
        pushError(htmlPath, "context-menu file missing shared symbol definition: ios26-symbol-chevron");
      }
    }
  }

  if (item.id === "top-bars") {
    if (!hasPattern(html, /id="ios26-topbars-symbol-back"/i)) {
      pushError(htmlPath, "top-bars file missing shared symbol definition: ios26-topbars-symbol-back");
    }
    if (!hasPattern(html, /id="ios26-topbars-symbol-accent-arrow"/i)) {
      pushError(htmlPath, "top-bars file missing shared symbol definition: ios26-topbars-symbol-accent-arrow");
    }
    if (!hasPattern(html, /id="ios26-topbars-symbol-square"/i)) {
      pushError(htmlPath, "top-bars file missing shared symbol definition: ios26-topbars-symbol-square");
    }
    if (!hasPattern(html, /id="ios26-topbars-symbol-square-dot"/i)) {
      pushError(htmlPath, "top-bars file missing shared symbol definition: ios26-topbars-symbol-square-dot");
    }
    if (!hasPattern(html, /id="ios26-topbars-symbol-plus"/i)) {
      pushError(htmlPath, "top-bars file missing shared symbol definition: ios26-topbars-symbol-plus");
    }
    if (!hasPattern(html, /id="ios26-topbars-symbol-triangle"/i)) {
      pushError(htmlPath, "top-bars file missing shared symbol definition: ios26-topbars-symbol-triangle");
    }
    if (
      hasPattern(
        html,
        /<span class="ios26-icon"[^>]*>\s*<svg[^>]*>\s*<(?:path|rect|circle)\b/is,
      )
    ) {
      pushError(
        htmlPath,
        "top-bars button icons must use <use> references to shared symbol defs (no inline geometry in repeated icon svgs)",
      );
    }
  }

  if (item.id === "buttons") {
    if (!hasPattern(html, /id="ios26-buttons-symbol-play"/i)) {
      pushError(htmlPath, "buttons file missing shared symbol definition: ios26-buttons-symbol-play");
    }
    if (hasPattern(html, /<span class="ios26-btn-icon"[^>]*>\s*<svg[^>]*>\s*<(?:path|rect|circle)\b/is)) {
      pushError(
        htmlPath,
        "button icons must use <use> references to shared symbol defs (no inline geometry in repeated icon svgs)",
      );
    }
  }

  if (item.id === "toolbars") {
    for (const symbolId of [
      "ios26-toolbars-symbol-back",
      "ios26-toolbars-symbol-sidebar",
      "ios26-toolbars-symbol-search",
      "ios26-toolbars-symbol-square",
      "ios26-toolbars-symbol-square-fill",
      "ios26-toolbars-symbol-mic",
    ]) {
      if (!hasPattern(html, new RegExp(`id="${symbolId}"`, "i"))) {
        pushError(htmlPath, `toolbars file missing shared symbol definition: ${symbolId}`);
      }
    }
    if (hasPattern(html, /<span class="ios26-icon"[^>]*>\s*<svg[^>]*>\s*<(?:path|rect|circle)\b/is)) {
      pushError(
        htmlPath,
        "toolbar icons must use <use> references to shared symbol defs (no inline geometry in repeated icon svgs)",
      );
    }
  }

  if (item.id === "sidebars") {
    for (const symbolId of [
      "ios26-sidebars-symbol-back",
      "ios26-sidebars-symbol-sidebar",
      "ios26-sidebars-symbol-search-top",
      "ios26-sidebars-symbol-square",
      "ios26-sidebars-symbol-square-fill",
      "ios26-sidebars-symbol-search-sidebar",
      "ios26-sidebars-symbol-mic",
    ]) {
      if (!hasPattern(html, new RegExp(`id="${symbolId}"`, "i"))) {
        pushError(htmlPath, `sidebars file missing shared symbol definition: ${symbolId}`);
      }
    }
    if (hasPattern(html, /<span class="ios26-icon"[^>]*>\s*<svg[^>]*>\s*<(?:path|rect|circle)\b/is)) {
      pushError(
        htmlPath,
        "sidebar icons must use <use> references to shared symbol defs (no inline geometry in repeated icon svgs)",
      );
    }
  }

  const htmlUrlMatches = [...html.matchAll(/url\(\s*["']?([^"')]+)["']?\s*\)/gi)];
  const htmlImgMatches = [...html.matchAll(/<img\b[^>]*\bsrc\s*=\s*["']([^"']+)["'][^>]*>/gi)];
  htmlAssetRefCountByComponent.set(item.id, htmlUrlMatches.length + htmlImgMatches.length);
  const exceptionConfig = assetBackedComponents[item.id] ?? null;
  const allowedPrefixes = resolveAllowedPrefixes(exceptionConfig);
  const referencedExceptionAssets = new Set();
  const recordExceptionReference = (referenced, sourceLabel) => {
    if (isInlineDataImage(referenced)) {
      return;
    }
    if (!exceptionConfig || typeof exceptionConfig !== "object") {
      pushError(htmlPath, `native HTML must not include ${sourceLabel}: ${referenced}`);
      return;
    }
    if (allowedPrefixes.length === 0) {
      pushError(exceptionsPath, `${item.id}: exception must define allowedUrlPrefix or allowedUrlPrefixes`);
      return;
    }
    const matchedPrefix = allowedPrefixes.find((prefix) => referenced.startsWith(prefix));
    if (!matchedPrefix) {
      pushError(htmlPath, `${item.id} ${sourceLabel} is outside allowed exception prefixes: ${referenced}`);
      return;
    }
    if (typeof exceptionConfig.localAssetRoot === "string" && exceptionConfig.localAssetRoot.length > 0) {
      const assetRelative = referenced.slice(matchedPrefix.length);
      referencedExceptionAssets.add(assetRelative);
      const assetPath = resolve(root, exceptionConfig.localAssetRoot, assetRelative);
      if (!existsSync(assetPath)) {
        pushError(htmlPath, `${item.id} asset file missing: ${assetRelative}`);
      }
    }
  };

  for (const match of htmlUrlMatches) {
    const referenced = String(match[1] ?? "").trim();
    recordExceptionReference(referenced, "url(...)");
  }

  for (const match of htmlImgMatches) {
    const referenced = String(match[1] ?? "").trim();
    recordExceptionReference(referenced, "<img src>");
  }

  const expectedAssets = expectedAssetsByComponent.get(item.id) ?? null;
  if (expectedAssets) {
    for (const expected of expectedAssets) {
      if (!referencedExceptionAssets.has(expected)) {
        pushError(htmlPath, `${item.id} asset-map file not referenced in HTML: ${expected}`);
      }
    }
    for (const referenced of referencedExceptionAssets) {
      if (!expectedAssets.has(referenced)) {
        pushError(htmlPath, `${item.id} HTML references stale asset not in asset-map: ${referenced}`);
      }
    }
  }

  if (hasPattern(html, /\bsrc\s*=\s*["']\.\.\/evidence\/figma-artifacts\/assets\//i)) {
    pushError(htmlPath, "native HTML must not depend on figma-artifacts/assets files");
  }

  if (hasPattern(css, /url\(/i)) {
    pushError(cssPath, "native CSS must not include url(...) references");
  }

  if (hasPattern(css, /https?:\/\//i)) {
    pushError(cssPath, "native CSS must not reference remote URLs");
  }

  const isEvidenceComponent = html.includes("ios26-evidence-root");
  const isAssetGalleryComponent = html.includes("ios26-asset-gallery-root");
  const isAppIconsComponent = html.includes("ios26-app-icons-root");
  const isExamplesComponent = html.includes("ios26-examples-root");
  const hasAppIconsRuntime = html.includes("shared-app-icons-catalog.js");
  const hasExamplesRuntime = html.includes("shared-examples-outline.js");
  const hasAppIconsStatic = html.includes("ios26-app-icons-grid") && html.includes("ios26-app-icons-image");
  const hasExamplesStatic = html.includes("ios26-examples-sections") && html.includes("ios26-examples-item");

  runtimeUsage.evidence = runtimeUsage.evidence || isEvidenceComponent;
  runtimeUsage.assetGallery = runtimeUsage.assetGallery || isAssetGalleryComponent;
  runtimeUsage.appIconsRuntime = runtimeUsage.appIconsRuntime || (isAppIconsComponent && hasAppIconsRuntime);
  runtimeUsage.examplesRuntime = runtimeUsage.examplesRuntime || (isExamplesComponent && hasExamplesRuntime);
  if (isEvidenceComponent && !html.includes("shared-evidence.js")) {
    pushError(htmlPath, "evidence component missing shared-evidence.js runtime");
  }

  if (isEvidenceComponent && !html.includes("shared-evidence-entry.js")) {
    pushError(htmlPath, "evidence component missing shared-evidence-entry.js bootstrap");
  }

  if (isEvidenceComponent && hasPattern(html, /window\.IOS26EvidenceRenderer\.renderFromDataset\(/)) {
    pushError(htmlPath, "evidence component must not inline renderer bootstrap logic");
  }

  if (isAssetGalleryComponent && !html.includes("shared-asset-gallery.js")) {
    pushError(htmlPath, "asset gallery component missing shared-asset-gallery.js runtime");
  }

  if (isAssetGalleryComponent && hasPattern(html, /window\.IOS26AssetGallery\.renderFromDataset\(/)) {
    pushError(htmlPath, "asset gallery component must not inline renderer bootstrap logic");
  }

  if (isAppIconsComponent && !hasAppIconsRuntime && !hasAppIconsStatic) {
    pushError(htmlPath, "app-icons component must include runtime bootstrap or static precompiled content");
  }

  if (isAppIconsComponent && hasPattern(html, /window\.IOS26AppIconsCatalog\.renderFromDataset\(/)) {
    pushError(htmlPath, "app-icons component must not inline renderer bootstrap logic");
  }

  if (isExamplesComponent && !hasExamplesRuntime && !hasExamplesStatic) {
    pushError(htmlPath, "examples component must include runtime bootstrap or static precompiled content");
  }

  if (isExamplesComponent && hasPattern(html, /window\.IOS26ExamplesOutline\.renderFromDataset\(/)) {
    pushError(htmlPath, "examples component must not inline renderer bootstrap logic");
  }
}

const catalogIds = new Set(catalog.map((item) => item.id));
for (const componentId of Object.keys(assetBackedComponents)) {
  if (!catalogIds.has(componentId)) {
    pushError(exceptionsPath, `asset-backed exception references unknown component: ${componentId}`);
    continue;
  }
  const count = htmlAssetRefCountByComponent.get(componentId) ?? 0;
  if (count === 0) {
    pushError(
      exceptionsPath,
      `${componentId}: asset-backed exception declared but component has no HTML asset refs (url(...) or <img src>)`,
    );
  }
}

if (runtimeUsage.evidence) {
  const sharedEvidencePath = resolve(nativeDir, "shared-evidence.js");
  if (!existsSync(sharedEvidencePath)) {
    pushError(sharedEvidencePath, "missing shared-evidence.js");
  }

  const sharedEvidenceEntryPath = resolve(nativeDir, "shared-evidence-entry.js");
  if (!existsSync(sharedEvidenceEntryPath)) {
    pushError(sharedEvidenceEntryPath, "missing shared-evidence-entry.js");
  }

  const sharedEvidenceCssPath = resolve(nativeDir, "shared-evidence.css");
  if (!existsSync(sharedEvidenceCssPath)) {
    pushError(sharedEvidenceCssPath, "missing shared-evidence.css");
  }
}

if (runtimeUsage.assetGallery) {
  const sharedAssetGalleryCssPath = resolve(nativeDir, "shared-asset-gallery.css");
  if (!existsSync(sharedAssetGalleryCssPath)) {
    pushError(sharedAssetGalleryCssPath, "missing shared-asset-gallery.css");
  }

  const sharedAssetGalleryJsPath = resolve(nativeDir, "shared-asset-gallery.js");
  if (!existsSync(sharedAssetGalleryJsPath)) {
    pushError(sharedAssetGalleryJsPath, "missing shared-asset-gallery.js");
  }
}

if (runtimeUsage.appIconsRuntime) {
  const sharedAppIconsCatalogPath = resolve(nativeDir, "shared-app-icons-catalog.js");
  if (!existsSync(sharedAppIconsCatalogPath)) {
    pushError(sharedAppIconsCatalogPath, "missing shared-app-icons-catalog.js");
  }
}

if (runtimeUsage.examplesRuntime) {
  const sharedExamplesOutlineCssPath = resolve(nativeDir, "shared-examples-outline.css");
  if (!existsSync(sharedExamplesOutlineCssPath)) {
    pushError(sharedExamplesOutlineCssPath, "missing shared-examples-outline.css");
  }

  const sharedExamplesOutlineJsPath = resolve(nativeDir, "shared-examples-outline.js");
  if (!existsSync(sharedExamplesOutlineJsPath)) {
    pushError(sharedExamplesOutlineJsPath, "missing shared-examples-outline.js");
  }
}

const sharedDeviceCssPath = resolve(nativeDir, "shared-device.css");
if (!existsSync(sharedDeviceCssPath)) {
  pushError(sharedDeviceCssPath, "missing shared-device.css");
}

if (errors.length > 0) {
  throw new Error(`Native purity check failed:\n${errors.join("\n")}`);
}

console.log(`Native purity check passed. components=${catalog.length}`);
