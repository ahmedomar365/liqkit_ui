import { foundationTokens } from "./foundation.js";

export const semanticTokens = {
  "--ui-bg-surface": foundationTokens.color.white,
  "--ui-fg-primary": foundationTokens.color.black,
  "--ui-accent-primary": foundationTokens.color.blue,
  "--ui-success": foundationTokens.color.green,
  "--ui-danger": foundationTokens.color.red,
} as const;
