/* FF >= 50 supports forEach on NodeList though while FF < 50 does not.
 * This function plays this issue over. Oh jeez. */
function nodelistwrap(elem) {
  if(typeof(elem.forEach) == "undefined") {
    let a = [];
    for(let i of elem)
      a.push(i);
    return a;
  }
  return elem;
}

function update_torrent_status() {
  let r = new XMLHttpRequest();
  r.open("GET", "https://www.bunsenlabs.org/tracker/status");
  r.responseType = "text";
  r.onload = () => {
    switch(r.status) {
      case 200:
	d = JSON.parse(r.response);
	nodelistwrap( document.querySelectorAll(".torrent-status") ).forEach((n) => {
	  let id = n.getAttribute("id");
	  if(id in d.torrents) {
	    n.textContent = `⬆${ d.torrents[id].s } ⬇${ d.torrents[id].l }`;
	    n.style.display = "block";
	  }
	});
    }
  };
  r.send();
}

update_torrent_status();
setInterval(update_torrent_status, 10000);
