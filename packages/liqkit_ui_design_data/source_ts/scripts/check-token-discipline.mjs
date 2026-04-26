import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const semanticPath = resolve(process.cwd(), "packages/tokens/src/semantic.ts");
const componentPath = resolve(process.cwd(), "packages/tokens/src/component.ts");

const semanticContent = readFileSync(semanticPath, "utf8");
const componentContent = readFileSync(componentPath, "utf8");
const rawPattern = /#[0-9a-fA-F]{3,8}\b|rgba?\(|hsla?\(/;

if (rawPattern.test(semanticContent)) {
  throw new Error("semantic.ts must not contain raw color literals; use foundation token references");
}

if (rawPattern.test(componentContent)) {
  throw new Error("component.ts must not contain raw color literals; use semantic CSS variables");
}

console.log("Token discipline check passed.");
