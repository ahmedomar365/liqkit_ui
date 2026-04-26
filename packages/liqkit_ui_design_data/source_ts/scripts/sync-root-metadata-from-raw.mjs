import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const verification = JSON.parse(readFileSync(resolve(root, "figma-artifacts/verification.json"), "utf8"));

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function normalizeMetadata(text) {
  const withoutImportant = text.split("\nIMPORTANT:")[0].trim();
  if (!withoutImportant.includes("<canvas") && !withoutImportant.includes("<frame") && !withoutImportant.includes("<section")) {
    return null;
  }
  return `${withoutImportant}\n`;
}

function latestValidRawMetadata(nodeId) {
  const dirRel = `figma-artifacts/raw/${slugNode(nodeId)}`;
  const dirAbs = resolve(root, dirRel);
  if (!existsSync(dirAbs)) {
    return null;
  }
  const candidates = readdirSync(dirAbs)
    .filter((name) => name.endsWith(".get_metadata.txt"))
    .sort((a, b) => b.localeCompare(a));
  for (const fileName of candidates) {
    const rel = `${dirRel}/${fileName}`;
    const normalized = normalizeMetadata(readFileSync(resolve(root, rel), "utf8"));
    if (normalized) {
      return { rel, normalized };
    }
  }
  return null;
}

let updated = 0;
let unchanged = 0;
let skipped = 0;

for (const [rootNodeId, component] of Object.entries(verification.components ?? {})) {
  const source = latestValidRawMetadata(rootNodeId);
  if (!source) {
    skipped += 1;
    continue;
  }
  const normalized = source.normalized;

  const dirRel = `figma-artifacts/${component.id}`;
  const dirAbs = resolve(root, dirRel);
  mkdirSync(dirAbs, { recursive: true });
  const targetRel = `${dirRel}/${slugNode(rootNodeId)}.metadata.xml`;
  const targetAbs = resolve(root, targetRel);

  if (existsSync(targetAbs)) {
    const current = readFileSync(targetAbs, "utf8");
    if (current === normalized) {
      unchanged += 1;
      continue;
    }
  }

  writeFileSync(targetAbs, normalized, "utf8");
  updated += 1;
}

console.log(`Root metadata sync complete. updated=${updated} unchanged=${unchanged} skipped=${skipped}`);
