"use strict";
function update_news() {
  fetch("https://www.bunsenlabs.org/feed/news")
    .then((resp) => {
      return resp.json();
    })
    .then((json) => {
      let anchor = document.querySelector(".news");
      /* A bit too destructive ^^ */
      while(anchor.firstChild) anchor.removeChild(anchor.firstChild);
      json.entries.forEach((e) => {
        let h2 = document.createElement("h2");
        h2.setAttribute("class", "news-heading");

        let span = document.createElement("span");
        span.setAttribute("class", "news-updated");
        span.textContent = e.date;
        h2.appendChild(span);

        let a = document.createElement("a");
        a.setAttribute("href", e.link);
        a.textContent = e.title;
        h2.appendChild(a);

        anchor.appendChild(h2);
      });
      let a = document.createElement("a");
      a.setAttribute("href", "https://forums.bunsenlabs.org/viewforum.php?id=12");
      a.textContent = "Older entries…";

      let h2 = document.createElement("h2");
      h2.setAttribute("class", "news-archive");
      h2.appendChild(a);

      anchor.appendChild(h2);
    })
    .catch((err) => {
      /* If we encounter an error (most importantly, during local
       * testing), default to noscript */
      let noscript = document.querySelector("noscript");
      let anchor = document.querySelector(".news");
      noscript.innerHTML = anchor.innerHTML;
    });
};
update_news();
