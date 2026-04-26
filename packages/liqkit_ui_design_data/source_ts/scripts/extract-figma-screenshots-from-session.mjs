import { createInterface } from "node:readline";
import { createReadStream } from "node:fs";
import {
  existsSync,
  mkdirSync,
  readFileSync,
  readdirSync,
  statSync,
  writeFileSync,
} from "node:fs";
import { extname, resolve } from "node:path";
import { homedir } from "node:os";

const root = process.cwd();
const verificationPath = resolve(root, "figma-artifacts/verification.json");
const canonicalPath = resolve(root, "figma-artifacts/canonical-nodes.json");
const indexPath = resolve(root, "figma-artifacts/screenshot-index.json");

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

function asPngPath(relPath) {
  if (relPath.endsWith(".note.txt")) {
    return relPath.slice(0, -".note.txt".length) + ".png";
  }
  if (relPath.endsWith(".txt")) {
    return relPath.slice(0, -".txt".length) + ".png";
  }
  const ext = extname(relPath).toLowerCase();
  if (ext === ".png") {
    return relPath;
  }
  return `${relPath}.png`;
}

function ensureDirFor(relPath) {
  const abs = resolve(root, relPath);
  const cut = abs.lastIndexOf("/");
  if (cut <= 0) {
    return;
  }
  mkdirSync(abs.slice(0, cut), { recursive: true });
}

function slugNode(nodeId) {
  return String(nodeId).replaceAll(":", "-");
}

function timestamp() {
  return new Date().toISOString().replaceAll(":", "-").replaceAll(".", "-");
}

function normalizeOutput(output) {
  if (Array.isArray(output)) {
    return output;
  }
  if (typeof output === "string") {
    try {
      const parsed = JSON.parse(output);
      return Array.isArray(parsed) ? parsed : null;
    } catch {
      return null;
    }
  }
  return null;
}

function pngSizeFromBase64(base64) {
  if (!base64) {
    return null;
  }
  const buffer = Buffer.from(base64, "base64");
  if (buffer.length < 24) {
    return null;
  }
  const signature = buffer.subarray(0, 8);
  const isPng = signature.equals(
    Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
  );
  if (!isPng) {
    return null;
  }
  const width = buffer.readUInt32BE(16);
  const height = buffer.readUInt32BE(20);
  return { width, height, area: width * height };
}

const args = parseArgs(process.argv);
const sessionPath = args.session ?? findLatestSessionJsonl();

if (!sessionPath) {
  console.log("No Codex session .jsonl found; screenshot extraction skipped.");
  process.exit(0);
}

const verification = JSON.parse(readFileSync(verificationPath, "utf8"));
const canonical = existsSync(canonicalPath)
  ? JSON.parse(readFileSync(canonicalPath, "utf8"))
  : { components: {} };

const callIdToNodeId = new Map();
const nodeToImage = new Map();
const nodeToCallId = new Map();

const rl = createInterface({
  input: createReadStream(sessionPath, "utf8"),
  crlfDelay: Infinity,
});

for await (const line of rl) {
  if (!line) {
    continue;
  }
  let parsed;
  try {
    parsed = JSON.parse(line);
  } catch {
    continue;
  }

  const payload = parsed.payload;
  if (!payload || payload.type !== "function_call" && payload.type !== "function_call_output") {
    continue;
  }

  if (payload.type === "function_call" && payload.name === "mcp__figma__get_screenshot") {
    try {
      const argsObj = JSON.parse(payload.arguments);
      const nodeId = argsObj.nodeId;
      if (nodeId && payload.call_id) {
        callIdToNodeId.set(payload.call_id, nodeId);
      }
    } catch {
      continue;
    }
    continue;
  }

  if (payload.type === "function_call_output") {
    const nodeId = callIdToNodeId.get(payload.call_id);
    if (!nodeId) {
      continue;
    }
    const outputItems = normalizeOutput(payload.output);
    if (!Array.isArray(outputItems)) {
      continue;
    }
    for (const item of outputItems) {
      if (!item || item.type !== "input_image" || typeof item.image_url !== "string") {
        continue;
      }
      if (!item.image_url.startsWith("data:image/png;base64,")) {
        continue;
      }
      nodeToImage.set(nodeId, item.image_url.slice("data:image/png;base64,".length));
      nodeToCallId.set(nodeId, payload.call_id);
    }
  }
}

let written = 0;
const updatedComponents = structuredClone(verification.components);
const screenshotIndex = {
  sessionPath,
  generatedAt: new Date().toISOString(),
  screenshots: {},
  raw: [],
};

for (const [nodeId, base64] of nodeToImage.entries()) {
  const relPath = `figma-artifacts/raw/${slugNode(nodeId)}/${timestamp()}.get_screenshot.png`;
  ensureDirFor(relPath);
  writeFileSync(resolve(root, relPath), Buffer.from(base64, "base64"));
  screenshotIndex.raw.push({
    nodeId,
    path: relPath,
    callId: nodeToCallId.get(nodeId) ?? null,
  });
}

for (const [categoryNode, component] of Object.entries(updatedComponents)) {
  if (component.status !== "verified") {
    continue;
  }
  if (!component.artifacts?.screenshotPath) {
    continue;
  }

  const canonicalNode = canonical.components?.[categoryNode]?.canonicalNode ?? null;
  const candidates = [canonicalNode, categoryNode]
    .filter(Boolean)
    .map((nodeId) => {
      const value = nodeToImage.get(nodeId);
      if (!value) {
        return null;
      }
      return {
        nodeId,
        base64: value,
        size: pngSizeFromBase64(value),
      };
    })
    .filter(Boolean);

  let selectedNode = null;
  let base64 = null;
  if (candidates.length > 0) {
    const canonicalCandidate = candidates.find((entry) => entry.nodeId === canonicalNode) ?? null;
    const categoryCandidate = candidates.find((entry) => entry.nodeId === categoryNode) ?? null;
    const canonicalArea = canonicalCandidate?.size?.area ?? 0;
    const categoryArea = categoryCandidate?.size?.area ?? 0;

    let selected = canonicalCandidate ?? candidates[0];
    if (canonicalCandidate && categoryCandidate) {
      const canonicalIsTiny = canonicalArea > 0 && canonicalArea <= 16384;
      const categoryHasMateriallyMoreSurface =
        canonicalArea > 0 && categoryArea >= Math.ceil(canonicalArea * 1.5);
      if ((canonicalIsTiny || categoryHasMateriallyMoreSurface) && categoryArea > canonicalArea) {
        selected = categoryCandidate;
      }
    } else if (!canonicalCandidate && categoryCandidate) {
      selected = categoryCandidate;
    }

    selectedNode = selected.nodeId;
    base64 = selected.base64;
  }

  if (!base64 || !selectedNode) {
    continue;
  }

  const targetRelPath = asPngPath(component.artifacts.screenshotPath);
  ensureDirFor(targetRelPath);
  const absTarget = resolve(root, targetRelPath);
  writeFileSync(absTarget, Buffer.from(base64, "base64"));

  component.artifacts.screenshotPath = targetRelPath;
  written += 1;
  screenshotIndex.screenshots[selectedNode] = {
    categoryNode,
    path: targetRelPath,
    callId: nodeToCallId.get(selectedNode) ?? null,
  };
}

verification.components = updatedComponents;
writeFileSync(verificationPath, `${JSON.stringify(verification, null, 2)}\n`, "utf8");
writeFileSync(indexPath, `${JSON.stringify(screenshotIndex, null, 2)}\n`, "utf8");

console.log(
  `Extracted Figma screenshots from session. written=${written} session=${sessionPath}`,
);
