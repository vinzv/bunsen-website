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
    });
};
update_news();
