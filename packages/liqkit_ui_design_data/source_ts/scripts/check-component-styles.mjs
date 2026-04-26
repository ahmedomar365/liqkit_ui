import { readFileSync, readdirSync } from "node:fs";
import { resolve } from "node:path";

const srcRoot = resolve(process.cwd(), "packages/components-html/src");

function walkFiles(dir) {
  const entries = readdirSync(dir, { withFileTypes: true });
  const files = [];
  for (const entry of entries) {
    const fullPath = resolve(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...walkFiles(fullPath));
      continue;
    }
    files.push(fullPath);
  }
  return files;
}

const tsFiles = walkFiles(srcRoot).filter((path) => path.endsWith(".ts") && !path.endsWith(".contract.ts"));
const styleLiteralPattern = /#[0-9a-fA-F]{3,8}\b|rgba?\(|hsla?\(/;

const violations = [];

for (const filePath of tsFiles) {
  const content = readFileSync(filePath, "utf8");
  const match = content.match(styleLiteralPattern);
  if (!match) {
    continue;
  }

  const index = match.index ?? 0;
  const prefix = content.slice(0, index);
  const line = prefix.split("\n").length;

  violations.push(`${filePath}:${line} uses raw color literal \"${match[0]}\"`);
}

if (violations.length > 0) {
  throw new Error(`Raw style literal violations:\n${violations.join("\n")}`);
}

console.log(`Component style check passed. files=${tsFiles.length}`);
