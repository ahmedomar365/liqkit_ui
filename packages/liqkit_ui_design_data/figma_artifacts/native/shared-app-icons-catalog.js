(function attachAppIconsCatalog(global) {
  function escapeHtml(value) {
    return String(value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#39;");
  }

  function parseIconEntry(name) {
    var match = String(name || "").match(/^imgIcon(.+)Mode(Default|Dark|ClearLight)$/);
    if (!match) return null;
    var rawIcon = match[1];
    var modeKey = match[2];
    return {
      iconKey: rawIcon,
      iconLabel: toIconLabel(rawIcon),
      modeKey: modeKey,
      modeLabel: toModeLabel(modeKey),
    };
  }

  function toModeLabel(modeKey) {
    if (modeKey === "Default") return "Default";
    if (modeKey === "Dark") return "Dark";
    if (modeKey === "ClearLight") return "Clear Light";
    return modeKey;
  }

  function toIconLabel(iconKey) {
    var normalized = String(iconKey || "")
      .replace(/ITunes/g, "iTunes")
      .replace(/Tv/g, "TV")
      .replace(/Airdrop/g, "AirDrop")
      .replace(/FindMy/g, "Find My")
      .replace(/FaceTime/g, "FaceTime")
      .replace(/VoiceMemos/g, "Voice Memos");
    return normalized
      .replace(/([a-z])([A-Z])/g, "$1 $2")
      .replace(/\s+/g, " ")
      .trim();
  }

  function parseAssetMap(raw) {
    if (!raw || typeof raw !== "object") {
      return { icons: [], count: 0 };
    }

    var byIcon = new Map();
    var assets = Array.isArray(raw.assets) ? raw.assets : [];

    for (var i = 0; i < assets.length; i += 1) {
      var asset = assets[i];
      if (!asset || asset.status !== "ok" || !asset.name || !asset.file) continue;
      var parsed = parseIconEntry(asset.name);
      if (!parsed) continue;
      if (!byIcon.has(parsed.iconKey)) {
        byIcon.set(parsed.iconKey, {
          key: parsed.iconKey,
          label: parsed.iconLabel,
          modes: {},
        });
      }
      byIcon.get(parsed.iconKey).modes[parsed.modeKey] = {
        label: parsed.modeLabel,
        file: asset.file,
      };
    }

    var icons = Array.from(byIcon.values()).sort(function sortByLabel(a, b) {
      return a.label.localeCompare(b.label);
    });

    return {
      icons: icons,
      count: icons.length,
    };
  }

  function modeCell(icon, modeKey, assetsBasePath) {
    var entry = icon.modes[modeKey];
    if (!entry) {
      return '<div class="ios26-app-icons-mode is-missing"><p>Missing</p></div>';
    }
    var src = assetsBasePath + "/" + entry.file;
    return '<figure class="ios26-app-icons-mode">' +
      '<img src="' + escapeHtml(src) + '" alt="' + escapeHtml(icon.label + ' ' + entry.label) + '" loading="lazy" decoding="async" />' +
      '<figcaption>' + escapeHtml(entry.label) + '</figcaption>' +
      '</figure>';
  }

  function renderCatalog(root, parsed, assetsBasePath) {
    var cards = parsed.icons
      .map(function toCard(icon) {
        return '<article class="ios26-app-icons-card">' +
          '<h4>' + escapeHtml(icon.label) + '</h4>' +
          '<div class="ios26-app-icons-modes">' +
            modeCell(icon, "Default", assetsBasePath) +
            modeCell(icon, "Dark", assetsBasePath) +
            modeCell(icon, "ClearLight", assetsBasePath) +
          '</div>' +
        '</article>';
      })
      .join("");

    root.innerHTML =
      '<header class="ios26-app-icons-head">' +
        '<h3>App Icons</h3>' +
        '<p>Persisted assets from saved Figma design-context. Icons: ' + escapeHtml(parsed.count) + '</p>' +
        '<div class="ios26-app-icons-links">' +
          '<a href="' + escapeHtml(root.dataset.contextPath || "") + '" target="_blank" rel="noreferrer">Open design-context</a>' +
          '<a href="' + escapeHtml(root.dataset.varsPath || "") + '" target="_blank" rel="noreferrer">Open variable-defs</a>' +
          '<a href="' + escapeHtml(root.dataset.assetMapPath || "") + '" target="_blank" rel="noreferrer">Open asset-map</a>' +
        '</div>' +
      '</header>' +
      '<section class="ios26-app-icons-grid" aria-label="App icon variants">' + cards + '</section>';
  }

  async function renderFromDataset(root) {
    if (!root) return;
    var assetMapPath = root.dataset.assetMapPath;
    var assetsBasePath = root.dataset.assetsBasePath;
    if (!assetMapPath || !assetsBasePath) {
      root.innerHTML = '<p class="ios26-app-icons-loading">Missing asset map configuration.</p>';
      return;
    }
    root.innerHTML = '<p class="ios26-app-icons-loading">Loading persisted icon assets…</p>';

    try {
      var response = await fetch(assetMapPath);
      if (!response.ok) {
        throw new Error("Failed to load asset-map (" + response.status + ")");
      }
      var assetMap = await response.json();
      var parsed = parseAssetMap(assetMap);
      if (!parsed.count) {
        root.innerHTML = '<p class="ios26-app-icons-loading">No icon assets were parsed from asset-map.</p>';
        return;
      }
      renderCatalog(root, parsed, assetsBasePath);
    } catch (error) {
      root.innerHTML = '<p class="ios26-app-icons-loading">' + escapeHtml(String(error)) + '</p>';
    }
  }

  function bootstrapCurrentScriptRoot() {
    var currentScript = document.currentScript;
    if (!currentScript) return;
    var root = currentScript.previousElementSibling;
    if (!root || !root.classList || !root.classList.contains("ios26-app-icons-root")) return;
    renderFromDataset(root);
  }

  global.IOS26AppIconsCatalog = {
    renderFromDataset: renderFromDataset,
  };

  bootstrapCurrentScriptRoot();
})(window);
