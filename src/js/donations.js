'use strict';

fetch("/donations.json")
.then((resp) => {
  if(resp.status == 200) {
    resp.json()
    .then((payload) => {
      let cc = new ProgressBar.Line("#shortfall", {
        duration: 1000,
        color: "#e0ffba",
        text: { value: `${payload.short_pct*100}% of ${payload.short_year}` }
      }).animate(payload.short_pct);
      document.querySelector("span#d-yearly").textContent = payload.want_pa;
      document.querySelector("span#d-reserve").textContent = payload.reserve;
      document.querySelector("span#d-updated").textContent = payload.last_update;
    });
  }
});
