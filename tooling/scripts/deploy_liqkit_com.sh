#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

SSH_HOST="${LIQKIT_DEPLOY_HOST:-157.180.115.197}"
SSH_USER="${LIQKIT_DEPLOY_USER:-root}"
SSH_TARGET="${LIQKIT_DEPLOY_ROOT:-/www/wwwroot/liqkit.com}"
PM2_BIN="${LIQKIT_PM2_BIN:-/www/server/nvm/versions/node/v22.19.0/bin/pm2}"
PM2_APP="${LIQKIT_PM2_APP:-liqkit-com}"
PORT="${LIQKIT_PORT:-3107}"
SNIPPETS_URL="${LIQKIT_SNIPPETS_URL:-https://liqkit.com/snippets}"
REMOTE_HOME="${LIQKIT_REMOTE_HOME:-/root}"
RELEASE_NAME="${LIQKIT_RELEASE_NAME:-app-$(date -u +%Y%m%d%H%M%S)}"
KEEP_RELEASES="${LIQKIT_KEEP_RELEASES:-5}"
REMOTE="${SSH_USER}@${SSH_HOST}"
REMOTE_RELEASE="${SSH_TARGET}/releases/${RELEASE_NAME}"
LOCAL_RELEASE="${ROOT_DIR}/.deploy/liqkit.com/${RELEASE_NAME}"

log() {
  printf '\n==> %s\n' "$*"
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  fi
}

ssh_run() {
  ssh -o BatchMode=yes -o ConnectTimeout=12 "$REMOTE" "$@"
}

require_cmd dart
require_cmd flutter
require_cmd git
require_cmd npx
require_cmd rsync
require_cmd ssh

log "Checking remote Apache/PM2 target"
ssh_run "test -d '$SSH_TARGET' && test -x '$PM2_BIN' && '$PM2_BIN' list >/dev/null"

log "Generating snippet manifest output"
dart run tooling/gen/snippet_generator/main.dart

log "Building Flutter snippets for /snippets/"
(
  cd apps/docs_snippets
  flutter build web \
    --wasm \
    --release \
    --no-web-resources-cdn \
    --pwa-strategy=none \
    --base-href=/snippets/
)

log "Copying snippets into Next public assets"
rm -rf apps/docs/public/snippets
mkdir -p apps/docs/public/snippets
rsync -a --delete apps/docs_snippets/build/web/ apps/docs/public/snippets/

log "Installing docs dependencies"
npx pnpm@10 install --frozen-lockfile

log "Building Next standalone docs"
(
  cd apps/docs
  NEXT_PUBLIC_SNIPPETS_URL="$SNIPPETS_URL" \
    NEXT_PUBLIC_SNIPPETS_CACHE_KEY="$RELEASE_NAME" \
    NODE_ENV=production \
    npx pnpm@10 build
)

log "Assembling standalone release at $LOCAL_RELEASE"
rm -rf "$LOCAL_RELEASE"
mkdir -p "$LOCAL_RELEASE/apps/docs/.next" "$LOCAL_RELEASE/apps/docs/public"
rsync -a --delete apps/docs/.next/standalone/ "$LOCAL_RELEASE/"
rsync -a --delete apps/docs/.next/static/ "$LOCAL_RELEASE/apps/docs/.next/static/"
rsync -a --delete apps/docs/public/ "$LOCAL_RELEASE/apps/docs/public/"
cat >"$LOCAL_RELEASE/DEPLOYED_FROM.txt" <<META
release=$RELEASE_NAME
git_sha=$(git rev-parse HEAD 2>/dev/null || printf unknown)
git_branch=$(git branch --show-current 2>/dev/null || printf unknown)
built_at_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)
snippets_url=$SNIPPETS_URL
META

log "Uploading release to $REMOTE_RELEASE"
ssh_run "mkdir -p '$SSH_TARGET/releases' '$REMOTE_RELEASE'"
rsync -az --delete --exclude='.DS_Store' "$LOCAL_RELEASE/" "$REMOTE:$REMOTE_RELEASE/"

log "Activating release and restarting PM2"
ssh_run "set -Eeuo pipefail
ln -sfn '$REMOTE_RELEASE' '$SSH_TARGET/current'
cd '$SSH_TARGET/current/apps/docs'
'$PM2_BIN' delete '$PM2_APP' >/dev/null 2>&1 || true
PORT='$PORT' NODE_ENV=production '$PM2_BIN' start '$SSH_TARGET/current/apps/docs/server.js' --name '$PM2_APP' --cwd '$SSH_TARGET/current/apps/docs' --time
'$PM2_BIN' save
'$PM2_BIN' describe '$PM2_APP' >/dev/null
"

log "Reloading Apache if configuration is valid"
ssh_run "APACHECTL=\$(command -v apachectl || command -v apache2ctl || printf /www/server/apache/bin/apachectl)
if [ -x \"\$APACHECTL\" ] && \"\$APACHECTL\" -t >/dev/null 2>&1; then
  if [ -x /etc/init.d/httpd ]; then
    /etc/init.d/httpd reload || true
  else
    \"\$APACHECTL\" graceful || true
  fi
else
  \"\$APACHECTL\" -t
fi"

log "Checking PM2 startup persistence"
ssh_run "set +e
'$PM2_BIN' startup systemd -u '$SSH_USER' --hp '$REMOTE_HOME' >/tmp/liqkit-pm2-startup.log 2>&1
'$PM2_BIN' save >/dev/null 2>&1
if command -v systemctl >/dev/null 2>&1; then
  systemctl enable pm2-$SSH_USER >/dev/null 2>&1 || true
  systemctl start pm2-$SSH_USER >/dev/null 2>&1 || true
fi
cat /tmp/liqkit-pm2-startup.log | tail -20
"

log "Remote health checks"
ssh_run "curl -fsSI 'http://127.0.0.1:$PORT/docs/foundation/divider' >/dev/null
curl -fsSI 'http://127.0.0.1:$PORT/snippets/index.html' >/dev/null
'$PM2_BIN' list
"

if [[ -n "${CF_ZONE_ID:-}" && -n "${CF_API_TOKEN:-}" ]]; then
  log "Purging Cloudflare cache"
  curl -fsS -X POST "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/purge_cache" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"purge_everything":true}' >/dev/null
else
  log "Skipping Cloudflare purge because CF_ZONE_ID/CF_API_TOKEN are not set"
fi

log "Public health checks"
curl -fsSI "https://liqkit.com/docs/foundation/divider?fresh=${RELEASE_NAME}" >/dev/null
curl -fsSI "https://liqkit.com/snippets/index.html?fresh=${RELEASE_NAME}" >/dev/null

log "Pruning old releases on server"
ssh_run "set +e
ls -1dt '$SSH_TARGET'/releases/app-* 2>/dev/null | tail -n +$((KEEP_RELEASES + 1)) | xargs -r rm -rf
"

log "Deployed $RELEASE_NAME"
printf 'Docs: %s\n' "https://liqkit.com/docs/foundation/divider?fresh=${RELEASE_NAME}"
printf 'Snippets: %s\n' "https://liqkit.com/snippets/index.html?theme=dark&v=${RELEASE_NAME}#/divider/horizontal"
