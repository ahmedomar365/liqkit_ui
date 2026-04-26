import {
  getDuplicateValues,
  type StrictComponentCatalogEntry,
} from "@ios-26/contracts";

import { componentCatalog } from "./catalog.js";

export const componentSpecs: readonly StrictComponentCatalogEntry[] = componentCatalog;

export function assertCatalogIntegrity(): void {
  const ids = componentSpecs.map((component) => component.id);
  const nodeIds = componentSpecs.map((component) => component.figmaNodeId);

  const duplicateIds = getDuplicateValues(ids);
  const duplicateNodeIds = getDuplicateValues(nodeIds);

  if (duplicateIds.length > 0 || duplicateNodeIds.length > 0) {
    const errors: string[] = [];
    if (duplicateIds.length > 0) {
      errors.push(`duplicate ids: ${duplicateIds.join(", ")}`);
    }
    if (duplicateNodeIds.length > 0) {
      errors.push(`duplicate figma node ids: ${duplicateNodeIds.join(", ")}`);
    }
    throw new Error(errors.join("; "));
  }
}

assertCatalogIntegrity();
