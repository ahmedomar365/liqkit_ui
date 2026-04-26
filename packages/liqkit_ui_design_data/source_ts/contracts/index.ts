export type FigmaNodeId = `${number}:${number}`;

export type VerificationStatus = "unverified" | "verified";

export interface ComponentArtifacts {
  designContextPath: string | null;
  screenshotPath: string | null;
  variableDefsPath: string | null;
}

export interface StrictComponentCatalogEntry {
  id: string;
  category: string;
  figmaNodeId: FigmaNodeId;
  figmaUrl: string;
  status: VerificationStatus;
  verifiedAt: string | null;
  artifacts: ComponentArtifacts;
}

export function getDuplicateValues(items: readonly string[]): string[] {
  const counts = new Map<string, number>();
  for (const item of items) {
    counts.set(item, (counts.get(item) ?? 0) + 1);
  }

  const duplicates: string[] = [];
  for (const [item, count] of counts.entries()) {
    if (count > 1) {
      duplicates.push(item);
    }
  }
  return duplicates.sort();
}
