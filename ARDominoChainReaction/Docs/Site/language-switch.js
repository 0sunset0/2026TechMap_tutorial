/* Keep the current DocC chapter when switching between language editions. */
(() => {
  const scriptURL = new URL(document.currentScript.src);
  const scriptBase = scriptURL.pathname.replace(/\/language-switch\.js$/, "");
  const siteBase = scriptBase.replace(/\/(ko|en)$/, "");
  let routes = {};
  const nav = document.createElement("nav");
  nav.id = "tutorial-language-switch";
  nav.setAttribute("aria-label", "Tutorial language / 튜토리얼 언어");
  nav.innerHTML = '<a data-language="ko" lang="ko" hreflang="ko">한국어</a><span aria-hidden="true"> / </span><a data-language="en" lang="en" hreflang="en">English</a>';
  const style = document.createElement("style");
  style.textContent = `
    html { scroll-padding-top: 44px; }
    body { padding-top: 36px; }
    .hero .copy-container p, .hero .copy-container h1 {
      word-break: keep-all;
      overflow-wrap: break-word;
      hyphens: none;
    }
    p.tutorial-language-notice { font-size: 17px; line-height: 1.5; }
    p.tutorial-language-notice a { font-weight: 600; }
    #tutorial-language-switch { position: fixed; inset: 0 0 auto; z-index: 9999;
      height: 36px; box-sizing: border-box; display: flex; align-items: center;
      justify-content: flex-end; gap: 10px; padding: 0 20px;
      background: #f5f5f7; color: #515154; border-bottom: 1px solid #d2d2d7;
      font: 13px/1.3 -apple-system, BlinkMacSystemFont, sans-serif; }
    #tutorial-language-switch a { color: #0066cc; text-decoration: none; }
    #tutorial-language-switch a:hover { text-decoration: underline; }
    #tutorial-language-switch a[aria-current="true"] { color: #1d1d1f; font-weight: 600; }
    #tutorial-language-switch a:focus-visible { outline: 2px solid #0066cc; outline-offset: 3px; }
    @media (prefers-color-scheme: dark) {
      #tutorial-language-switch { background: #1d1d1f; border-color: #424245; color: #a1a1a6; }
      #tutorial-language-switch a { color: #2997ff; }
      #tutorial-language-switch a[aria-current="true"] { color: #f5f5f7; }
    }
  `;
  document.head.append(style);
  document.body.prepend(nav);

  function markLanguageNotice() {
    document.querySelectorAll("p").forEach((paragraph) => {
      if (paragraph.textContent.trim().startsWith("This tutorial is also available in")) {
        paragraph.classList.add("tutorial-language-notice");
        paragraph.setAttribute("lang", "en");
      }
    });
  }
  markLanguageNotice();
  new MutationObserver(markLanguageNotice).observe(document.body, { childList: true, subtree: true });

  // DocC does not consistently scroll to percent-encoded Korean anchors.
  let anchorObserver;
  function restoreAnchor() {
    anchorObserver?.disconnect();
    if (!location.hash) return;
    let anchor;
    try { anchor = decodeURIComponent(location.hash.slice(1)); } catch { return; }
    const scroll = () => {
      const target = document.getElementById(anchor);
      if (!target) return;
      anchorObserver?.disconnect();
      requestAnimationFrame(() => requestAnimationFrame(() => {
        if (decodeURIComponent(location.hash.slice(1)) === anchor) {
          target.scrollIntoView({ block: "start", behavior: "instant" });
        }
      }));
    };
    anchorObserver = new MutationObserver(scroll);
    anchorObserver.observe(document.body, { childList: true, subtree: true });
    scroll();
  }
  restoreAnchor();
  addEventListener("hashchange", restoreAnchor);

  function update() {
    let route = location.pathname.slice(siteBase.length).replace(/^\/(ko|en)(?=\/|$)/, "");
    route = route.replace(/\/index\.html$/, "/");
    if (!route || route === "/") route = "/tutorials/ardominochainreactiontutorials/";
    if (!route.endsWith("/")) route += "/";
    const current = location.pathname.startsWith(siteBase + "/en/") ? "en" : "ko";
    if (document.documentElement.lang !== current) document.documentElement.lang = current;
    nav.querySelectorAll("a").forEach((link) => {
      const language = link.dataset.language;
      let hash = location.hash;
      let anchor;
      try { anchor = decodeURIComponent(hash.slice(1)); } catch { anchor = hash.slice(1); }
      const pair = (routes[route.replace(/\/$/, "")] || []).find((item) =>
        anchor === item[current] || anchor.startsWith(item[current] + "-"));
      if (pair) hash = "#" + encodeURIComponent(pair[language] + anchor.slice(pair[current].length));
      link.href = siteBase + "/" + language + route + location.search + hash;
      if (language === current) link.setAttribute("aria-current", "true");
      else link.removeAttribute("aria-current");
    });
  }
  // DocC changes chapters with client-side history navigation.
  for (const method of ["pushState", "replaceState"]) {
    const original = history[method];
    history[method] = function (...args) {
      const result = original.apply(this, args);
      update();
      return result;
    };
  }
  addEventListener("popstate", update);
  addEventListener("hashchange", update);
  // DocC's renderer initializes the document language after mounting.
  new MutationObserver(update).observe(document.documentElement, { attributes: true, attributeFilter: ["lang"] });
  update();
  fetch(siteBase + "/language-routes.json")
    .then((response) => { if (!response.ok) throw new Error("Language routes unavailable"); return response.json(); })
    .then((mapping) => { routes = mapping; update(); })
    .catch(() => { /* Chapter links still work if the optional section mapping is unavailable. */ });
})();
