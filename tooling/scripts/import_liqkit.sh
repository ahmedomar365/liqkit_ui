#!/usr/bin/env bash
# Curated import of liqkit/ canonical evidence into
# packages/liqkit_ui_design_data/.
#
# This script intentionally does NOT do a wholesale `rsync -a` — that
# would pull in ~13 GB of historical snapshot backups and raw MCP
# response blobs that are derived/redundant. We import only what is
# canonical evidence or a port source.
#
# What we KEEP (~120 MB total):
#   - figma-artifacts/<category>/ (canonical screenshot + design-context +
#     variable-defs per category node). 37 categories.
#   - figma-artifacts/native/ (HTML/CSS implementations, reference for the
#     Dart hand-port).
#   - figma-artifacts/assets/ (image assets used by liqkit components).
#   - figma-artifacts/*.json manifests (schema/coverage/verification ledger).
#   - figma-artifacts/*.md docs (verification status, audit reports).
#   - release/native/ (final canonical HTML/CSS bundle).
#   - release/inventory.json.
#   - preview/rendered/<category>.html (rendered HTML pages used as the
#     primary SSIM baseline for the Playwright fidelity loop).
#   - preview/rendered/source/*.native.{html,css} (per-category source
#     fragments).
#   - preview/rendered/fidelity-snapshots/ (component-only fidelity PNGs).
#   - preview/docs/ (mirrored markdown for browser navigation).
#   - packages/{tokens,contracts,components-html}/src/ — TS sources, port
#     reference for the Dart side.
#   - scripts/ — npm scripts that produced the above (provenance trail).
#   - root *.md docs and LICENSE.
#
# What we explicitly SKIP:
#   - figma-artifacts/snapshots/ (13 GB of timestamped backups of the
#     above; redundant with current state).
#   - figma-artifacts/raw/ (~535 MB of per-MCP-call raw blobs; derived).
#   - preview/flutter-showcase/ (~50 MB pre-built Flutter Web build; we
#     replace this with our own Dart showcase).
#   - preview/rendered/snapshots/ (full-page rendered PNGs; superseded
#     by fidelity-snapshots which are the per-component crops we
#     actually compare against).
#   - preview/index.html, preview/apple-design/, preview/evidence/,
#     preview/react-showcase/ (browser navigation chrome; not source).
#   - tmp-*.png at liqkit root (dev screenshots; not canonical).
#   - _assumed_archive/ (liqkit's own pre-canonical archive).
#   - node_modules/, build/, .git/ (always derived).
#
# Each excluded class is justified above. If you find a file you think
# should be kept that this script omits, audit before adding — don't
# blanket-include.

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
  "$DEST/figma_artifacts/native" \
  "$DEST/figma_artifacts/assets" \
  "$DEST/native" \
  "$DEST/rendered" \
  "$DEST/rendered/source" \
  "$DEST/rendered/fidelity-snapshots" \
  "$DEST/manifests" \
  "$DEST/docs" \
  "$DEST/docs/figma-artifacts" \
  "$DEST/docs/preview" \
  "$DEST/source_ts/tokens" \
  "$DEST/source_ts/contracts" \
  "$DEST/source_ts/components_html" \
  "$DEST/source_ts/scripts"

# Per-category canonical artifacts. We iterate the directory list rather
# than `rsync -a` so the snapshots/, raw/, native/, and assets/ subdirs
# are NOT pulled in by accident.
shopt -s nullglob
for catdir in "$SRC_ABS"/figma-artifacts/*/; do
  name=$(basename "$catdir")
  case "$name" in
    snapshots|raw|native|assets|history)
      # Handled separately below or skipped entirely.
      continue
      ;;
  esac
  rsync -a --exclude '.DS_Store' "$catdir" "$DEST/figma_artifacts/$name/"
done
shopt -u nullglob

# Native HTML/CSS reference (within figma-artifacts) and the assets
# folder, both kept verbatim.
[[ -d "$SRC_ABS/figma-artifacts/native"  ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/figma-artifacts/native/"  "$DEST/figma_artifacts/native/"
[[ -d "$SRC_ABS/figma-artifacts/assets"  ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/figma-artifacts/assets/"  "$DEST/figma_artifacts/assets/"

# Top-level JSON manifests in figma-artifacts.
for f in screenshot-index.json visual-fidelity.json canonical-nodes.json verification.json ARTIFACT_DIGESTS.json full-coverage-workflow.json node-completeness.json context-index.json full-metadata-coverage.json LATEST_SNAPSHOT; do
  [[ -f "$SRC_ABS/figma-artifacts/$f" ]] && cp "$SRC_ABS/figma-artifacts/$f" "$DEST/manifests/$f"
done

# Status / audit markdown docs.
for f in EVIDENCE_COMPLETENESS.md FULL_METADATA_COVERAGE.md STRICT_COMPLETENESS.md STRICT_PROGRESS.md VISUAL_FIDELITY_REPORT.md RESUME_QUEUE.md MCP_QUOTA_BLOCKER.md MCP_RECAPTURE_QUEUE.md; do
  [[ -f "$SRC_ABS/figma-artifacts/$f" ]] && cp "$SRC_ABS/figma-artifacts/$f" "$DEST/docs/figma-artifacts/$f"
done

# release/ — canonical native HTML/CSS bundle and machine-readable inventory.
[[ -d "$SRC_ABS/release/native" ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/release/native/" "$DEST/native/"
[[ -f "$SRC_ABS/release/inventory.json" ]] && cp "$SRC_ABS/release/inventory.json" "$DEST/manifests/inventory.json"

# preview/rendered — selectively. We keep the per-category HTML pages,
# the source fragments, and the fidelity snapshots. We skip
# preview/rendered/snapshots/ (full-page; superseded by fidelity-snapshots),
# preview/rendered/index.html, and any chrome.
shopt -s nullglob
for f in "$SRC_ABS"/preview/rendered/*.html; do
  base=$(basename "$f")
  [[ "$base" == "index.html" ]] && continue
  cp "$f" "$DEST/rendered/$base"
done
shopt -u nullglob
[[ -d "$SRC_ABS/preview/rendered/source"             ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/preview/rendered/source/"             "$DEST/rendered/source/"
[[ -d "$SRC_ABS/preview/rendered/fidelity-snapshots" ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/preview/rendered/fidelity-snapshots/" "$DEST/rendered/fidelity-snapshots/"
[[ -d "$SRC_ABS/preview/docs"                        ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/preview/docs/"                        "$DEST/docs/preview/"

# Root markdown docs and LICENSE.
for f in README.md RELEASE_INVENTORY.md FIGMA_NODE_MANIFEST.md ENGINEERING_GUARDRAILS.md COMPREHENSIVE_PLAN.md FIGMA_EXTRACTION_WORKLIST.md NATIVE_IMAGE_AUDIT.md STRICT_STATUS.md LICENSE; do
  [[ -f "$SRC_ABS/$f" ]] && cp "$SRC_ABS/$f" "$DEST/docs/$f"
done

# TS sources — small, frozen, used as port reference for Dart.
rsync -a --exclude '.DS_Store' "$SRC_ABS/packages/tokens/src/"           "$DEST/source_ts/tokens/"
rsync -a --exclude '.DS_Store' "$SRC_ABS/packages/contracts/src/"        "$DEST/source_ts/contracts/"
rsync -a --exclude '.DS_Store' "$SRC_ABS/packages/components-html/src/"  "$DEST/source_ts/components_html/"

# npm scripts (provenance — these produced the artifacts above).
[[ -d "$SRC_ABS/scripts" ]] && rsync -a --exclude '.DS_Store' "$SRC_ABS/scripts/" "$DEST/source_ts/scripts/"

# NOTE: snapshots/, raw/, _assumed_archive/, tmp-*.png, preview/flutter-showcase/
# are all intentionally NOT copied. See the block comment at the top of
# this file for the rationale per directory.

SRC_COMMIT="$(git -C "$SRC_ABS" rev-parse HEAD 2>/dev/null || echo unknown)"
DATE_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

{
  echo "# Provenance"
  echo
  echo "Imported from: $SRC_ABS"
  echo "Source commit: $SRC_COMMIT"
  echo "Imported at:   $DATE_UTC"
  echo
  echo "## Curation policy"
  echo
  echo "This is a curated import, not a verbatim copy. See"
  echo "tooling/scripts/import_liqkit.sh for the explicit list of what"
  echo "is kept (canonical evidence + Dart port sources) versus what is"
  echo "skipped (snapshot history, raw MCP blobs, build outputs, etc.)."
  echo
  echo "## File hashes (sha256)"
  echo
  echo '```'
  ( cd "$DEST" && find . -type f ! -name 'PROVENANCE.md' -print0 | sort -z | xargs -0 shasum -a 256 )
  echo '```'
} > "$DEST/PROVENANCE.md"

echo "import_liqkit: curated copy complete at $DEST"
echo "import_liqkit: PROVENANCE.md written"
du -sh "$DEST" 2>&1 | awk '{print "import_liqkit: total size " $1}'
