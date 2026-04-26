(function attachIos26AssetImages() {
  function resolveEvidencePrefix() {
    const pathname = typeof window !== "undefined" && window.location ? String(window.location.pathname || "") : "";
    return pathname.includes("/rendered/source/") ? "../../evidence/" : "../evidence/";
  }

  function hydrateImageAssets() {
    const prefix = `${resolveEvidencePrefix()}figma-artifacts/assets/`;
    const nodes = document.querySelectorAll("img[data-ios26-asset],source[data-ios26-asset]");
    for (const node of nodes) {
      if (node.getAttribute("src")) {
        continue;
      }
      const rel = node.getAttribute("data-ios26-asset");
      if (!rel) {
        continue;
      }
      const normalized = rel.replace(/^\/+/, "");
      node.setAttribute("src", `${prefix}${normalized}`);
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", hydrateImageAssets, { once: true });
  }
  hydrateImageAssets();
})();
