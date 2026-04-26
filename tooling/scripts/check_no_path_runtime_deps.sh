#!/usr/bin/env bash
# Fails if any pubspec.yaml in a publishable package declares a runtime
# `path:` dependency.
set -euo pipefail

REPO="$(git rev-parse --show-toplevel)"
cd "$REPO"

bad=0
while IFS= read -r -d '' pubspec; do
  publish_to_none=$(awk '/^publish_to:[[:space:]]*none/{print 1; exit}' "$pubspec" || true)
  if [[ "$publish_to_none" == "1" ]]; then
    continue
  fi
  if awk '
    /^dependencies:/ { in_deps=1; next }
    /^[a-z_]+:/      { in_deps=0 }
    in_deps && /^[[:space:]]+path:[[:space:]]/ { exit 1 }
  ' "$pubspec"; then
    :
  else
    echo "check_no_path_runtime_deps: $pubspec has a runtime path: dep" >&2
    bad=1
  fi
done < <(find packages -name pubspec.yaml -print0)

exit $bad
