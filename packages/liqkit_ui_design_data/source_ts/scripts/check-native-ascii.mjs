import { readdirSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const nativeDir = resolve(root, "figma-artifacts", "native");

function listNativeFiles() {
  return readdirSync(nativeDir)
    .filter((name) => name.endsWith(".html") || name.endsWith(".css"))
    .sort((a, b) => a.localeCompare(b))
    .map((name) => resolve(nativeDir, name));
}

function nonAsciiLocations(source) {
  const issues = [];
  let line = 1;
  let column = 1;
  for (let i = 0; i < source.length; i += 1) {
    const code = source.charCodeAt(i);
    if (code > 127) {
      issues.push({ line, column, code });
    }
    if (source[i] === "\n") {
      line += 1;
      column = 1;
    } else {
      column += 1;
    }
  }
  return issues;
}

const failures = [];

for (const path of listNativeFiles()) {
  const source = readFileSync(path, "utf8");
  const issues = nonAsciiLocations(source);
  if (issues.length === 0) {
    continue;
  }
  const rel = path.replace(`${root}/`, "");
  const preview = issues
    .slice(0, 5)
    .map((item) => `${item.line}:${item.column} (U+${item.code.toString(16).toUpperCase().padStart(4, "0")})`)
    .join(", ");
  failures.push(`${rel}: ${issues.length} non-ASCII chars at ${preview}`);
}

if (failures.length > 0) {
  throw new Error(`Native ASCII check failed:\n${failures.join("\n")}`);
}

console.log(`Native ASCII check passed. files=${listNativeFiles().length}`);
