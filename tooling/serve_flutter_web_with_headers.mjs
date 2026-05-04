#!/usr/bin/env node
import { createReadStream, existsSync, statSync } from 'node:fs';
import { readdir } from 'node:fs/promises';
import { createServer } from 'node:http';
import { extname, join, normalize, resolve, sep } from 'node:path';

const root = resolve(process.argv[2] ?? 'apps/docs_snippets/build/web');
const port = Number(process.env.PORT ?? process.argv[3] ?? 8141);

if (!existsSync(root) || !statSync(root).isDirectory()) {
  throw new Error(`Static root does not exist: ${root}`);
}

const mimeTypes = new Map([
  ['.bin', 'application/octet-stream'],
  ['.css', 'text/css; charset=utf-8'],
  ['.html', 'text/html; charset=utf-8'],
  ['.ico', 'image/x-icon'],
  ['.js', 'text/javascript; charset=utf-8'],
  ['.json', 'application/json; charset=utf-8'],
  ['.mjs', 'text/javascript; charset=utf-8'],
  ['.otf', 'font/otf'],
  ['.png', 'image/png'],
  ['.svg', 'image/svg+xml'],
  ['.wasm', 'application/wasm'],
]);

function setIsolationHeaders(res) {
  res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
  res.setHeader('Cross-Origin-Embedder-Policy', 'credentialless');
  res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
  res.setHeader('Permissions-Policy', 'cross-origin-isolated=(self)');
}

function safePath(url) {
  const pathname = new URL(url, `http://127.0.0.1:${port}`).pathname;
  const decoded = decodeURIComponent(pathname);
  const relative = normalize(decoded).replace(/^(\.\.(\/|\\|$))+/, '');
  const candidate = resolve(root, `.${sep}${relative}`);
  if (!candidate.startsWith(`${root}${sep}`) && candidate !== root) {
    return null;
  }
  return candidate;
}

async function resolveFile(url) {
  const candidate = safePath(url);
  if (!candidate) return null;
  if (existsSync(candidate) && statSync(candidate).isFile()) {
    return candidate;
  }
  if (existsSync(candidate) && statSync(candidate).isDirectory()) {
    const index = join(candidate, 'index.html');
    if (existsSync(index)) return index;
  }
  const index = join(root, 'index.html');
  return existsSync(index) ? index : null;
}

const server = createServer(async (req, res) => {
  setIsolationHeaders(res);
  res.setHeader(
    'Cache-Control',
    'no-store, no-cache, must-revalidate, max-age=0',
  );
  res.setHeader('Pragma', 'no-cache');

  const file = await resolveFile(req.url ?? '/');
  if (!file) {
    res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end('Not found');
    return;
  }

  const type = mimeTypes.get(extname(file)) ?? 'application/octet-stream';
  res.writeHead(200, { 'Content-Type': type });
  createReadStream(file).pipe(res);
});

server.listen(port, '127.0.0.1', async () => {
  const files = await readdir(root);
  const hasWasmEntrypoint = files.some((file) => file.endsWith('.wasm'));
  console.log(
    `Serving ${root} at http://127.0.0.1:${port} with COOP/COEP headers` +
      (hasWasmEntrypoint ? ' and Wasm assets' : ''),
  );
});
