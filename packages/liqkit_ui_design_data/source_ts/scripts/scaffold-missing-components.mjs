import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const srcRoot = resolve(root, "packages/components-html/src");
const registryPath = resolve(srcRoot, "registry.ts");
const registryContent = readFileSync(registryPath, "utf8");

const specs = [
  { id: "example-showcase", nodeId: "0:3329", title: "Example Showcase", description: "Representative examples and composition samples." },
  { id: "color-palette", nodeId: "0:1746", title: "Color Palette", description: "Semantic and tonal color presentation surface." },
  { id: "material-surface", nodeId: "215:105157", title: "Material Surface", description: "Layer, elevation, and material treatment sample." },
  { id: "text-style", nodeId: "0:2194", title: "Text Style", description: "Typography hierarchy and style showcase." },
  { id: "bezel", nodeId: "507:24672", title: "Bezel", description: "Device frame and boundary treatment." },
  { id: "system-ui", nodeId: "507:24688", title: "System UI", description: "Core system-level container patterns." },
  { id: "activity-view", nodeId: "507:24670", title: "Activity View", description: "Share and action destination panel style." },
  { id: "app-icon", nodeId: "507:24671", title: "App Icon", description: "Application icon tile and size presentation." },
  { id: "color-picker", nodeId: "507:26010", title: "Color Picker", description: "Color selection control surface." },
  { id: "empty-state", nodeId: "5518:18111", title: "Empty State", description: "No-content placeholder with guidance copy." },
  { id: "face-id", nodeId: "507:26011", title: "Face ID", description: "Authentication prompt surface and affordance." },
  { id: "keyboard", nodeId: "507:24674", title: "Keyboard", description: "On-screen key layout and interaction area." },
  { id: "list-view", nodeId: "507:24675", title: "List View", description: "Structured row and section list pattern." },
  { id: "picker", nodeId: "507:24680", title: "Picker", description: "Value chooser and option column surface." },
  { id: "popup-button", nodeId: "507:26009", title: "Popup Button", description: "Button with attached popup affordance." },
  { id: "sidebar", nodeId: "507:26013", title: "Sidebar", description: "Persistent navigation rail and grouping surface." },
  { id: "widget", nodeId: "507:26511", title: "Widget", description: "Compact glanceable information module." },
  { id: "window-surface", nodeId: "5413:10149", title: "Window Surface", description: "Window-level container chrome and framing." },
  { id: "kit-helper", nodeId: "507:29124", title: "Kit Helper", description: "Design kit guidance and helper surface." },
];

function toPascal(input) {
  return input
    .split("-")
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join("");
}

for (const spec of specs) {
  const contractMarker = `id: \"${spec.id}\"`;
  if (registryContent.includes(contractMarker)) {
    continue;
  }

  const dir = resolve(srcRoot, spec.id);
  mkdirSync(dir, { recursive: true });

  const pascal = toPascal(spec.id);
  const camel = pascal.charAt(0).toLowerCase() + pascal.slice(1);

  const contractExport = `${camel}Contract`;
  const styleExport = `${camel}Styles`;
  const renderFn = `render${pascal}`;
  const propsType = `${pascal}Props`;
  const variantsType = `${pascal}Variants`;

  const contractCode = `import { defineComponentContract } from \"@ios-26/contracts\";

export const ${contractExport} = defineComponentContract({
  id: \"${spec.id}\",
  figmaNodeId: \"${spec.nodeId}\",
  slots: [\"root\", \"title\", \"body\", \"actions\"],
  variants: {
    size: [\"sm\", \"md\", \"lg\"],
    emphasis: [\"default\", \"tinted\"],
  },
  states: [\"default\", \"hover\", \"active\", \"focus-visible\", \"disabled\"],
  tokens: [\"--ui-bg-surface\", \"--ui-fg-primary\", \"--ui-accent-primary\"],
} as const);
`;

  const cssCode = `export const ${styleExport} = \`
.ios26-${spec.id} {
  display: grid;
  gap: 8px;
  width: min(100%, 360px);
  border: 1px solid var(--ui-accent-primary);
  border-radius: 12px;
  background: var(--ui-bg-surface);
  color: var(--ui-fg-primary);
  padding: 12px;
}

.ios26-${spec.id}[data-size=\"sm\"] {
  min-height: 72px;
}

.ios26-${spec.id}[data-size=\"md\"] {
  min-height: 92px;
}

.ios26-${spec.id}[data-size=\"lg\"] {
  min-height: 112px;
}

.ios26-${spec.id}[data-emphasis=\"tinted\"] {
  box-shadow: 0 6px 14px -12px var(--ui-accent-primary);
}

.ios26-${spec.id}__title {
  margin: 0;
  font-weight: 600;
}

.ios26-${spec.id}__body {
  margin: 0;
  opacity: 0.85;
}
\`;
`;

  const tsCode = `import { selectVariant, type VariantProps } from \"@ios-26/contracts\";

import { cx } from \"../shared/classname.js\";
import { escapeHtml } from \"../shared/html.js\";
import { ${contractExport} } from \"./${spec.id}.contract.js\";

export type ${variantsType} = VariantProps<typeof ${contractExport}.variants>;

export interface ${propsType} extends ${variantsType} {
  title?: string;
  body?: string;
  className?: string;
}

const defaultVariants = {
  size: \"md\",
  emphasis: \"default\",
} as const satisfies Required<${variantsType}>;

export function ${renderFn}(props: ${propsType} = {}): string {
  const size = selectVariant(
    ${contractExport}.variants.size,
    props.size,
    defaultVariants.size,
  );
  const emphasis = selectVariant(
    ${contractExport}.variants.emphasis,
    props.emphasis,
    defaultVariants.emphasis,
  );

  const title = escapeHtml(props.title ?? \"${spec.title}\");
  const body = escapeHtml(props.body ?? \"${spec.description}\");

  return \`<section class=\"\${cx(\"ios26-${spec.id}\", props.className)}\" data-size=\"\${size}\" data-emphasis=\"\${emphasis}\"><h4 class=\"ios26-${spec.id}__title\">\${title}</h4><p class=\"ios26-${spec.id}__body\">\${body}</p></section>\`;
}
`;

  const indexCode = `export { ${contractExport} } from \"./${spec.id}.contract.js\";
export { ${styleExport} } from \"./${spec.id}.css.js\";
export { ${renderFn} } from \"./${spec.id}.js\";
export type { ${propsType}, ${variantsType} } from \"./${spec.id}.js\";
`;

  writeFileSync(resolve(dir, `${spec.id}.contract.ts`), contractCode, "utf8");
  writeFileSync(resolve(dir, `${spec.id}.css.ts`), cssCode, "utf8");
  writeFileSync(resolve(dir, `${spec.id}.ts`), tsCode, "utf8");
  writeFileSync(resolve(dir, "index.ts"), indexCode, "utf8");
}

console.log("Scaffolded missing generic components.");
