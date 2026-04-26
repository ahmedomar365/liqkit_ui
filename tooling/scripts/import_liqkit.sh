#!/usr/bin/env bash
# Copies the entire liqkit/ workspace into
# packages/liqkit_ui_design_data/ and writes PROVENANCE.md (sha256 of
# every copied file).

set -euo pipefail

SRC="${1:-../liqkit}"
if [[ ! -d "$SRC" ]]; then
  echo "import_liqkit: source $SRC does not exist." >&2
  exit 2
fi
SRC_ABS="$(cd "$SRC" && pwd)"

REPO="$(git rev-parse --show-toplevel)"
DEST="$REPO/packages/liqkit_ui_design_data"
cd "$REPO"

mkdir -p \
  "$DEST/figma_artifacts" \
  "$DEST/native" \
  "$DEST/rendered" \
  "$DEST/manifests" \
  "$DEST/docs" \
  "$DEST/docs/figma-artifacts" \
  "$DEST/docs/preview" \
  "$DEST/source_ts/tokens" \
  "$DEST/source_ts/contracts" \
  "$DEST/source_ts/components_html" \
  "$DEST/source_ts/scripts" \
  "$DEST/snapshots" \
  "$DEST/archive"

rsync -a --exclude '.DS_Store' "$SRC_ABS/figma-artifacts/"   "$DEST/figma_artifacts/"
rsync -a --exclude '.DS_Store' "$SRC_ABS/release/native/"    "$DEST/native/"
rsync -a --exclude '.DS_Store' "$SRC_ABS/preview/rendered/"  "$DEST/rendered/"

for f in screenshot-index.json visual-fidelity.json canonical-nodes.json verification.json ARTIFACT_DIGESTS.json full-coverage-workflow.json node-completeness.json context-index.json full-metadata-coverage.json; do
  [[ -f "$SRC_ABS/figma-artifacts/$f" ]] && cp "$SRC_ABS/figma-artifacts/$f" "$DEST/manifests/$f"
done
[[ -f "$SRC_ABS/release/inventory.json" ]] && cp "$SRC_ABS/release/inventory.json" "$DEST/manifests/inventory.json"

for f in EVIDENCE_COMPLETENESS.md FULL_METADATA_COVERAGE.md STRICT_COMPLETENESS.md STRICT_PROGRESS.md VISUAL_FIDELITY_REPORT.md RESUME_QUEUE.md MCP_QUOTA_BLOCKER.md MCP_RECAPTURE_QUEUE.md; do
  [[ -f "$SRC_ABS/figma-artifacts/$f" ]] && cp "$SRC_ABS/figma-artifacts/$f" "$DEST/docs/figma-artifacts/$f"
done

[[ -d "$SRC_ABS/preview/docs" ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/preview/docs/" "$DEST/docs/preview/"
[[ -d "$SRC_ABS/figma-artifacts/snapshots" ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/figma-artifacts/snapshots/" "$DEST/snapshots/"

for f in README.md RELEASE_INVENTORY.md FIGMA_NODE_MANIFEST.md ENGINEERING_GUARDRAILS.md COMPREHENSIVE_PLAN.md FIGMA_EXTRACTION_WORKLIST.md NATIVE_IMAGE_AUDIT.md STRICT_STATUS.md LICENSE; do
  [[ -f "$SRC_ABS/$f" ]] && cp "$SRC_ABS/$f" "$DEST/docs/$f"
done

rsync -a --exclude '.DS_Store' "$SRC_ABS/packages/tokens/src/"           "$DEST/source_ts/tokens/"
rsync -a --exclude '.DS_Store' "$SRC_ABS/packages/contracts/src/"        "$DEST/source_ts/contracts/"
rsync -a --exclude '.DS_Store' "$SRC_ABS/packages/components-html/src/"  "$DEST/source_ts/components_html/"
[[ -d "$SRC_ABS/scripts" ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/scripts/" "$DEST/source_ts/scripts/"

[[ -d "$SRC_ABS/_assumed_archive" ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/_assumed_archive/" "$DEST/archive/_assumed_archive/"
for f in package.json tsconfig.json tsconfig.base.json package-lock.json; do
  [[ -f "$SRC_ABS/$f" ]] && cp "$SRC_ABS/$f" "$DEST/archive/$f"
done
shopt -s nullglob
for tmp in "$SRC_ABS"/tmp-*.png; do
  cp "$tmp" "$DEST/archive/$(basename "$tmp")"
done
shopt -u nullglob

SRC_COMMIT="$(git -C "$SRC_ABS" rev-parse HEAD 2>/dev/null || echo unknown)"
DATE_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

{
  echo "# Provenance"
  echo
  echo "Imported from: $SRC_ABS"
  echo "Source commit: $SRC_COMMIT"
  echo "Imported at:   $DATE_UTC"
  echo
  echo "## File hashes (sha256)"
  echo
  echo '```'
  ( cd "$DEST" && find . -type f ! -name 'PROVENANCE.md' -print0 | sort -z | xargs -0 shasum -a 256 )
  echo '```'
} > "$DEST/PROVENANCE.md"

echo "import_liqkit: copied to $DEST"
echo "import_liqkit: PROVENANCE.md written"
