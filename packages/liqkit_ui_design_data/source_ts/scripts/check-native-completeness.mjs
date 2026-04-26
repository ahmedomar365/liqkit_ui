import { existsSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const cwd = process.cwd();
const root = existsSync(resolve(cwd, "packages/components-html/src/catalog.json"))
  ? cwd
  : resolve(cwd, "ios-26");
const catalogPath = resolve(root, "packages/components-html/src/catalog.json");
const canonicalPath = resolve(root, "figma-artifacts/canonical-nodes.json");
const nativeDir = resolve(root, "figma-artifacts/native");
const rawDir = resolve(root, "figma-artifacts/raw");
const outJsonPath = resolve(root, "figma-artifacts/node-completeness.json");
const outMdPath = resolve(root, "figma-artifacts/STRICT_COMPLETENESS.md");

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function latestFile(dir, suffix) {
  if (!existsSync(dir)) {
    return null;
  }
  const names = readdirSync(dir).filter((name) => name.endsWith(suffix)).sort();
  if (names.length === 0) {
    return null;
  }
  return resolve(dir, names[names.length - 1]);
}

function parseAttrs(attrText) {
  const attrs = {};
  const attrRe = /([a-zA-Z_][a-zA-Z0-9_:-]*)="([^"]*)"/g;
  let match = attrRe.exec(attrText);
  while (match) {
    attrs[match[1]] = match[2];
    match = attrRe.exec(attrText);
  }
  return attrs;
}

function parseMetadataNodes(metadataText) {
  const nodes = [];
  const lines = metadataText.split("\n");
  for (const line of lines) {
    const match = line.match(/^(\s*)<(section|frame|symbol|instance)\s+([^>]*?)\/?>\s*$/);
    if (!match) {
      continue;
    }
    const leading = match[1] ?? "";
    const tag = match[2];
    const attrs = parseAttrs(match[3] ?? "");
    if (!attrs.id) {
      continue;
    }
    nodes.push({
      id: attrs.id,
      name: attrs.name ?? "",
      tag,
      depth: Math.floor(leading.length / 2),
    });
  }
  return nodes;
}

function parseNativeNodeIds(htmlText) {
  const ids = new Set();
  const re = /data-node-id="([^"]+)"/g;
  let match = re.exec(htmlText);
  while (match) {
    ids.add(match[1]);
    match = re.exec(htmlText);
  }
  return ids;
}

function isIgnoredName(name) {
  const lower = name.toLowerCase();
  return lower === "header";
}

function isHelperName(name) {
  return name.startsWith("_") || /^overlay\b/i.test(name);
}

function isVariantName(name) {
  return /[A-Za-z][^=]*=/.test(name);
}

function shouldRequireNode(node) {
  const name = (node.name ?? "").trim();
  if (!name || isIgnoredName(name)) {
    return false;
  }
  if (node.depth === 1 && node.tag !== "instance" && !isHelperName(name)) {
    return true;
  }
  if (node.tag === "symbol" && isVariantName(name) && !isHelperName(name)) {
    return true;
  }
  if ((node.tag === "section" || node.tag === "frame") && /examples?/i.test(name)) {
    return true;
  }
  return false;
}

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));
const canonical = existsSync(canonicalPath)
  ? JSON.parse(readFileSync(canonicalPath, "utf8"))
  : { components: {} };

const results = [];
const failures = [];

for (const component of catalog) {
  const rootNode = component.figmaNodeId;
  const canonicalNode = canonical.components?.[rootNode]?.canonicalNode ?? null;
  const metadataDirectory = resolve(rawDir, slugNode(rootNode));
  const metadataPath = latestFile(metadataDirectory, ".get_metadata.txt");
  const htmlPath = resolve(nativeDir, `${component.id}.html`);
  const htmlText = existsSync(htmlPath) ? readFileSync(htmlPath, "utf8") : "";
  const nativeNodeIds = parseNativeNodeIds(htmlText);

  const requiredById = new Map();

  function markRequired(id, name, reason) {
    if (!id) {
      return;
    }
    if (!requiredById.has(id)) {
      requiredById.set(id, { id, name: name ?? "", reasons: new Set() });
    }
    requiredById.get(id).reasons.add(reason);
  }

  markRequired(rootNode, component.category, "category-root");
  if (canonicalNode && canonicalNode !== rootNode) {
    markRequired(canonicalNode, "", "canonical-node");
  }

  let parsedNodes = [];
  if (metadataPath && existsSync(metadataPath)) {
    const metadataText = readFileSync(metadataPath, "utf8");
    parsedNodes = parseMetadataNodes(metadataText);
    for (const node of parsedNodes) {
      if (shouldRequireNode(node)) {
        markRequired(node.id, node.name, "metadata-required");
      }
    }
  }

  const required = [...requiredById.values()].map((item) => ({
    id: item.id,
    name: item.name,
    reasons: [...item.reasons].sort(),
  }));

  const missing = required.filter((item) => !nativeNodeIds.has(item.id));
  const coveredCount = required.length - missing.length;

  if (!metadataPath || !existsSync(metadataPath)) {
    failures.push(
      `${component.id}: missing root metadata for ${rootNode} (figma-artifacts/raw/${slugNode(rootNode)})`,
    );
  }
  if (missing.length > 0) {
    const short = missing.slice(0, 6).map((m) => `${m.id}${m.name ? ` (${m.name})` : ""}`).join(", ");
    failures.push(`${component.id}: missing required nodes -> ${short}${missing.length > 6 ? ", ..." : ""}`);
  }

  results.push({
    id: component.id,
    category: component.category,
    figmaNodeId: rootNode,
    canonicalNode,
    metadataPath: metadataPath ? metadataPath.replace(`${root}/`, "") : null,
    parsedNodeCount: parsedNodes.length,
    requiredCount: required.length,
    coveredCount,
    missingCount: missing.length,
    required,
    missing,
  });
}

const summary = {
  generatedAt: new Date().toISOString(),
  componentCount: catalog.length,
  missingComponentCount: results.filter((r) => r.missingCount > 0).length,
  totalRequiredNodes: results.reduce((sum, r) => sum + r.requiredCount, 0),
  totalMissingNodes: results.reduce((sum, r) => sum + r.missingCount, 0),
};

writeFileSync(
  outJsonPath,
  `${JSON.stringify({ summary, components: results }, null, 2)}\n`,
  "utf8",
);

const md = [];
md.push("# Strict Completeness");
md.push("");
md.push(`Generated: ${summary.generatedAt}`);
md.push(`Components: ${summary.componentCount}`);
md.push(`Required node IDs: ${summary.totalRequiredNodes}`);
md.push(`Missing required node IDs: ${summary.totalMissingNodes}`);
md.push("");
md.push("| Category | Root | Required | Covered | Missing |");
md.push("|---|---|---:|---:|---:|");
for (const row of results) {
  md.push(
    `| ${row.category} | \`${row.figmaNodeId}\` | ${row.requiredCount} | ${row.coveredCount} | ${row.missingCount} |`,
  );
}

const missingRows = results.filter((row) => row.missingCount > 0);
if (missingRows.length > 0) {
  md.push("");
  md.push("## Missing Nodes");
  for (const row of missingRows) {
    md.push("");
    md.push(`### ${row.category} (\`${row.id}\`)`);
    for (const missing of row.missing) {
      const label = missing.name ? ` ${missing.name}` : "";
      md.push(`- \`${missing.id}\`${label} [${missing.reasons.join(", ")}]`);
    }
  }

  md.push("");
  md.push("## Minimal MCP Queue");
  md.push("Use one metadata call per category root first, then fetch only missing nodes.");
  for (const row of missingRows) {
    md.push("");
    md.push(`### ${row.category} (\`${row.figmaNodeId}\`)`);
    md.push("- `get_metadata` on category root node once");
    for (const missing of row.missing) {
      md.push(`- Missing node \`${missing.id}\`: \`get_design_context\`, \`get_variable_defs\`, \`get_screenshot\``);
    }
  }
}

writeFileSync(outMdPath, `${md.join("\n")}\n`, "utf8");

if (failures.length > 0) {
  const top = failures.slice(0, 20).join(" | ");
  throw new Error(
    `Native completeness check failed. components_with_missing=${summary.missingComponentCount} total_missing_nodes=${summary.totalMissingNodes} :: ${top}. See figma-artifacts/STRICT_COMPLETENESS.md`,
  );
}

console.log(
  `Native completeness check passed. components=${summary.componentCount} required_nodes=${summary.totalRequiredNodes}`,
);
