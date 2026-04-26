import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const manifestPath = resolve(root, "FIGMA_NODE_MANIFEST.md");
const catalogJsonPath = resolve(root, "packages/components-html/src/catalog.json");
const catalogTsPath = resolve(root, "packages/components-html/src/catalog.ts");
const verificationPath = resolve(root, "figma-artifacts/verification.json");

const manifest = readFileSync(manifestPath, "utf8");
const rowRegex = /^\|\s*([^|]+?)\s*\|\s*`(\d+:\d+)`\s*\|\s*(https?:\/\/[^\s|]+)\s*\|$/gm;

function slugify(value) {
  return value
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .replace(/-{2,}/g, "-");
}

const rows = [];
let match;
while ((match = rowRegex.exec(manifest)) !== null) {
  rows.push({
    category: match[1].trim(),
    figmaNodeId: match[2].trim(),
    figmaUrl: match[3].trim(),
  });
}

if (rows.length === 0) {
  throw new Error("No manifest rows parsed from FIGMA_NODE_MANIFEST.md");
}

const usedIds = new Map();
const verification = existsSync(verificationPath)
  ? JSON.parse(readFileSync(verificationPath, "utf8"))
  : { components: {} };

const components = rows.map((row) => {
  const baseId = slugify(row.category);
  const next = (usedIds.get(baseId) ?? 0) + 1;
  usedIds.set(baseId, next);
  const id = next === 1 ? baseId : `${baseId}-${next}`;

  const prev = verification.components[row.figmaNodeId] ?? {};

  return {
    id,
    category: row.category,
    figmaNodeId: row.figmaNodeId,
    figmaUrl: row.figmaUrl,
    status: prev.status === "verified" ? "verified" : "unverified",
    verifiedAt: prev.verifiedAt ?? null,
    artifacts: {
      designContextPath: prev.artifacts?.designContextPath ?? null,
      screenshotPath: prev.artifacts?.screenshotPath ?? null,
      variableDefsPath: prev.artifacts?.variableDefsPath ?? null,
    },
  };
});

const nextVerification = {
  components: Object.fromEntries(
    components.map((component) => [
      component.figmaNodeId,
      {
        id: component.id,
        category: component.category,
        status: component.status,
        verifiedAt: component.verifiedAt,
        artifacts: component.artifacts,
      },
    ]),
  ),
};

mkdirSync(resolve(root, "figma-artifacts"), { recursive: true });
writeFileSync(verificationPath, `${JSON.stringify(nextVerification, null, 2)}\n`, "utf8");
writeFileSync(catalogJsonPath, `${JSON.stringify(components, null, 2)}\n`, "utf8");

const tsLiteral = JSON.stringify(components, null, 2);
const catalogTs = `import type { StrictComponentCatalogEntry } from "@ios-26/contracts";\n\nexport const componentCatalog = ${tsLiteral} as readonly StrictComponentCatalogEntry[];\n`;
writeFileSync(catalogTsPath, catalogTs, "utf8");

console.log(`Strict catalog synced. components=${components.length}`);
