import { createReadStream } from "node:fs";
import { createInterface } from "node:readline";
import { existsSync, mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";
import { homedir } from "node:os";

function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i += 1) {
    const key = argv[i];
    if (!key.startsWith("--")) {
      throw new Error(`Unexpected argument: ${key}`);
    }
    const value = argv[i + 1];
    if (!value || value.startsWith("--")) {
      throw new Error(`Missing value for argument: ${key}`);
    }
    args[key.slice(2)] = value;
    i += 1;
  }
  return args;
}

function listJsonlFiles(dir, acc) {
  const entries = readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const abs = resolve(dir, entry.name);
    if (entry.isDirectory()) {
      listJsonlFiles(abs, acc);
      continue;
    }
    if (entry.isFile() && abs.endsWith(".jsonl")) {
      acc.push(abs);
    }
  }
}

function findLatestSessionJsonl() {
  const base = resolve(homedir(), ".codex", "sessions");
  if (!existsSync(base)) {
    return null;
  }
  const files = [];
  listJsonlFiles(base, files);
  if (files.length === 0) {
    return null;
  }
  files.sort((a, b) => statSync(b).mtimeMs - statSync(a).mtimeMs);
  return files[0];
}

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function timestamp() {
  return new Date().toISOString().replaceAll(":", "-").replaceAll(".", "-");
}

const args = parseArgs(process.argv);
const sessionPath = args.session ?? findLatestSessionJsonl();
if (!sessionPath) {
  console.log("No session found; skipping text extraction.");
  process.exit(0);
}

const root = process.cwd();
const outRoot = resolve(root, "figma-artifacts", "raw");
mkdirSync(outRoot, { recursive: true });

const callMeta = new Map();
const writes = [];

const rl = createInterface({
  input: createReadStream(sessionPath, "utf8"),
  crlfDelay: Infinity,
});

for await (const line of rl) {
  if (!line) continue;
  let parsed;
  try {
    parsed = JSON.parse(line);
  } catch {
    continue;
  }

  const payload = parsed.payload;
  if (!payload) continue;

  if (payload.type === "function_call") {
    if (!String(payload.name || "").startsWith("mcp__figma__")) {
      continue;
    }
    let argsObj = {};
    try {
      argsObj = payload.arguments ? JSON.parse(payload.arguments) : {};
    } catch {
      argsObj = {};
    }
    callMeta.set(payload.call_id, {
      name: payload.name,
      nodeId: argsObj.nodeId ?? "unknown-node",
      fileKey: argsObj.fileKey ?? "unknown-file",
    });
    continue;
  }

  if (payload.type === "function_call_output") {
    const meta = callMeta.get(payload.call_id);
    if (!meta) continue;
    let outputItems = payload.output;
    if (typeof outputItems === "string") {
      try {
        outputItems = JSON.parse(outputItems);
      } catch {
        continue;
      }
    }
    if (!Array.isArray(outputItems)) continue;

    const texts = outputItems
      .filter((item) => item && item.type === "text" && typeof item.text === "string")
      .map((item) => item.text);

    if (texts.length === 0) continue;

    const toolName = meta.name.replace("mcp__figma__", "");
    const nodeDir = resolve(outRoot, slugNode(meta.nodeId));
    mkdirSync(nodeDir, { recursive: true });
    const relPath = `figma-artifacts/raw/${slugNode(meta.nodeId)}/${timestamp()}.${toolName}.txt`;
    const absPath = resolve(root, relPath);
    writeFileSync(absPath, `${texts.join("\n\n")}\n`, "utf8");
    writes.push({ nodeId: meta.nodeId, toolName, path: relPath });
  }
}

if (writes.length === 0) {
  console.log(`No Figma text outputs found in session: ${sessionPath}`);
  process.exit(0);
}

const indexPath = resolve(root, "figma-artifacts", "raw", "index.json");
let existing = { sessionPath: null, entries: [] };
try {
  existing = JSON.parse(readFileSync(indexPath, "utf8"));
} catch {
  existing = { sessionPath: null, entries: [] };
}

existing.sessionPath = sessionPath;
existing.entries = [...(existing.entries ?? []), ...writes];
writeFileSync(indexPath, `${JSON.stringify(existing, null, 2)}\n`, "utf8");

console.log(`Extracted Figma text outputs: ${writes.length} session=${sessionPath}`);
for (const item of writes) {
  console.log(`${item.toolName} ${item.nodeId} -> ${item.path}`);
}
