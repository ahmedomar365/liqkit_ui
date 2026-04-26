import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const srcRoot = resolve(root, "packages/components-html/src");
const entries = readdirSync(srcRoot, { withFileTypes: true })
  .filter((entry) => entry.isDirectory() && entry.name !== "shared")
  .map((entry) => entry.name)
  .sort();

const componentMeta = [];
for (const dir of entries) {
  const contractPath = resolve(srcRoot, dir, `${dir}.contract.ts`);
  const cssPath = resolve(srcRoot, dir, `${dir}.css.ts`);

  const contractText = readFileSync(contractPath, "utf8");
  const cssText = readFileSync(cssPath, "utf8");

  const contractMatch = contractText.match(/export\s+const\s+(\w+)\s*=\s*defineComponentContract/);
  const styleMatch = cssText.match(/export\s+const\s+(\w+Styles)\s*=/);

  if (!contractMatch || !styleMatch) {
    throw new Error(`Failed to parse contract/style export in ${dir}`);
  }

  componentMeta.push({
    dir,
    contractExport: contractMatch[1],
    styleExport: styleMatch[1],
  });
}

const registryImports = componentMeta
  .map((meta) => `import { ${meta.contractExport} } from \"./${meta.dir}/${meta.dir}.contract.js\";`)
  .join("\n");
const registryArray = componentMeta
  .map((meta) => `  ${meta.contractExport},`)
  .join("\n");

const registryText = `import { getDuplicateValues } from \"@ios-26/contracts\";

${registryImports}

export const componentContracts = [
${registryArray}
] as const;

export function assertUniqueComponentContracts(): void {
  const ids = componentContracts.map((contract) => contract.id);
  const figmaNodeIds = componentContracts.map((contract) => contract.figmaNodeId);

  const duplicateIds = getDuplicateValues(ids);
  const duplicateNodeIds = getDuplicateValues(figmaNodeIds);

  if (duplicateIds.length > 0 || duplicateNodeIds.length > 0) {
    const messages: string[] = [];
    if (duplicateIds.length > 0) {
      messages.push(\`duplicate contract ids: \${duplicateIds.join(\", \")}\`);
    }
    if (duplicateNodeIds.length > 0) {
      messages.push(\`duplicate figma node ids: \${duplicateNodeIds.join(\", \")}\`);
    }
    throw new Error(messages.join(\"; \"));
  }
}

assertUniqueComponentContracts();
`;

const styleImports = componentMeta
  .map((meta) => `import { ${meta.styleExport} } from \"./${meta.dir}/${meta.dir}.css.js\";`)
  .join("\n");
const styleJoin = componentMeta.map((meta) => `    ${meta.styleExport},`).join("\n");

const stylesText = `${styleImports}
import { rootTokenStyles } from \"@ios-26/tokens\";

export function renderGlobalStyles(): string {
  return [
    rootTokenStyles(),
${styleJoin}
  ].join("\\n\\n");
}
`;

const indexExports = componentMeta
  .map((meta) => `export * from \"./${meta.dir}/index.js\";`)
  .join("\n");

const indexText = `${indexExports}

export { componentContracts } from \"./registry.js\";
export { renderGlobalStyles } from \"./styles.js\";
`;

writeFileSync(resolve(srcRoot, "registry.ts"), registryText, "utf8");
writeFileSync(resolve(srcRoot, "styles.ts"), stylesText, "utf8");
writeFileSync(resolve(srcRoot, "index.ts"), indexText, "utf8");

console.log(`Synced component surface. components=${componentMeta.length}`);
