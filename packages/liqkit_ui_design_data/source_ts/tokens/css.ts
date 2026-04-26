import { semanticTokens } from "./semantic.js";

export type CssVarMap = Record<string, string>;

export function cssVarBlock(vars: CssVarMap): string {
  return Object.entries(vars)
    .map(([key, value]) => `  ${key}: ${value};`)
    .join("\n");
}

export function rootTokenStyles(): string {
  return `:root {\n${cssVarBlock(semanticTokens)}\n}`;
}
