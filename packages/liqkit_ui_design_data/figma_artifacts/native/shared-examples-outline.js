(function attachExamplesOutline(global) {
  function escapeHtml(value) {
    return String(value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#39;");
  }

  function parseSections(text) {
    var sectionPattern = /<section\s+id="([^"]+)"\s+name="([^"]+)"[^>]*>([\s\S]*?)<\/section>/g;
    var matches = Array.from(text.matchAll(sectionPattern));
    return matches.map(function toSection(match) {
      return {
        id: match[1],
        name: match[2],
        body: match[3] || "",
      };
    });
  }

  function parseNodes(sectionBody) {
    var nodePattern = /<(frame|symbol)\s+id="([^"]+)"\s+name="([^"]+)"\s+x="([^"]+)"\s+y="([^"]+)"\s+width="([^"]+)"\s+height="([^"]+)"\s*\/>/g;
    var matches = Array.from(sectionBody.matchAll(nodePattern));
    return matches.map(function toNode(match) {
      return {
        kind: match[1],
        id: match[2],
        name: match[3],
        x: match[4],
        y: match[5],
        width: match[6],
        height: match[7],
      };
    });
  }

  function buildSectionCard(section, nodeLimit) {
    var nodes = parseNodes(section.body);
    var visible = nodes.slice(0, nodeLimit);
    var items = visible.map(function toItem(node) {
      return '<article class="ios26-examples-item">' +
        '<p class="ios26-examples-item-name">' + escapeHtml(node.name) + '</p>' +
        '<p class="ios26-examples-item-meta"><code>' + escapeHtml(node.id) + '</code> · ' + escapeHtml(node.kind) + '</p>' +
        '<p class="ios26-examples-item-meta">x=' + escapeHtml(node.x) + ', y=' + escapeHtml(node.y) + ', w=' + escapeHtml(node.width) + ', h=' + escapeHtml(node.height) + '</p>' +
      '</article>';
    }).join("");

    return '<section class="ios26-examples-section">' +
      '<h4>' + escapeHtml(section.name) + '</h4>' +
      '<p class="ios26-examples-section-meta"><code>' + escapeHtml(section.id) + '</code> · nodes: ' + escapeHtml(nodes.length) + '</p>' +
      '<div class="ios26-examples-grid">' +
        (items || '<p class="ios26-examples-section-meta">No frame/symbol nodes parsed.</p>') +
      '</div>' +
    '</section>';
  }

  function render(root, contextText) {
    var sections = parseSections(contextText);
    var sectionLimit = Number(root.dataset.sectionLimit || 8);
    var nodeLimit = Number(root.dataset.nodeLimit || 40);
    var visibleSections = sections.slice(0, sectionLimit);

    var body = visibleSections.map(function toSection(section) {
      return buildSectionCard(section, nodeLimit);
    }).join("");

    root.innerHTML =
      '<header class="ios26-examples-head">' +
        '<h3>' + escapeHtml(root.dataset.title || "Examples") + '</h3>' +
        '<p>Node ' + escapeHtml(root.dataset.nodeId || "-") + ' · sections: ' + escapeHtml(sections.length) + '</p>' +
        '<div class="ios26-examples-links">' +
          '<a href="' + escapeHtml(root.dataset.contextPath || "") + '" target="_blank" rel="noreferrer">Open design-context</a>' +
          '<a href="' + escapeHtml(root.dataset.varsPath || "") + '" target="_blank" rel="noreferrer">Open variable-defs</a>' +
        '</div>' +
      '</header>' +
      '<div class="ios26-examples-sections">' +
        (body || '<p class="ios26-examples-loading">No sections parsed from persisted design-context.</p>') +
      '</div>';
  }

  async function renderFromDataset(root) {
    if (!root) return;
    var contextPath = root.dataset.contextPath;
    if (!contextPath) {
      root.innerHTML = '<p class="ios26-examples-loading">Missing context path.</p>';
      return;
    }
    root.innerHTML = '<p class="ios26-examples-loading">Loading persisted example matrix…</p>';

    try {
      var response = await fetch(contextPath);
      if (!response.ok) {
        throw new Error("Failed to load design-context (" + response.status + ")");
      }
      var text = await response.text();
      render(root, text);
    } catch (error) {
      root.innerHTML = '<p class="ios26-examples-loading">' + escapeHtml(String(error)) + '</p>';
    }
  }

  function bootstrapCurrentScriptRoot() {
    var currentScript = document.currentScript;
    if (!currentScript) return;
    var root = currentScript.previousElementSibling;
    if (!root || !root.classList || !root.classList.contains("ios26-examples-root")) return;
    renderFromDataset(root);
  }

  global.IOS26ExamplesOutline = {
    renderFromDataset: renderFromDataset,
  };

  bootstrapCurrentScriptRoot();
})(window);
