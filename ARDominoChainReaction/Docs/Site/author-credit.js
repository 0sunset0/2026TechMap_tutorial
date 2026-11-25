/* Show a small author credit beside DocC's Light/Dark/Auto toggle. */
(() => {
  const GITHUB = "https://github.com/0sunset0";
  const LINKEDIN = "https://www.linkedin.com/in/%EC%9D%84-%EB%85%B8-990a2732a/";

  const style = document.createElement("style");
  style.textContent = `
    #tutorial-author-credit { margin: 0 16px 0 0; align-self: center; font-size: 12px; line-height: 24px; color: var(--color-figure-gray-secondary); }
    #tutorial-author-credit a { margin-left: 8px; color: var(--color-link); }
    #tutorial-author-credit a:hover { text-decoration: underline; }
  `;
  document.head.append(style);

  function credit() {
    const name = document.documentElement.lang === "en" ? "NohEul" : "노을";
    const element = document.createElement("p");
    element.id = "tutorial-author-credit";
    element.append(`Created by ${name}`);
    for (const [label, href] of [["GitHub", GITHUB], ["LinkedIn", LINKEDIN]]) {
      const link = document.createElement("a");
      link.href = href;
      link.target = "_blank";
      link.rel = "noopener";
      link.textContent = label;
      element.append(link);
    }
    return element;
  }

  // DocC renders the footer after mounting and may re-render it on navigation.
  function attach() {
    const toggle = document.querySelector(".footer .color-scheme-toggle");
    if (!toggle || toggle.parentElement.querySelector("#tutorial-author-credit")) return;
    toggle.after(credit()); // The footer row is row-reverse, so this lands left of the toggle.
  }
  new MutationObserver(attach).observe(document.body, { childList: true, subtree: true });
  attach();
})();
