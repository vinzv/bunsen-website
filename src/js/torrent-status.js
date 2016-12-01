function update_torrent_status() {
  let r = new XMLHttpRequest();
  r.open("GET", "https://www.bunsenlabs.org/tracker/status");
  r.responseType = "text";
  r.onload = () => {
    switch(r.status) {
      case 200:
	d = JSON.parse(r.response);
	document.querySelectorAll(".torrent-status").forEach((n) => {
	  let id = n.getAttribute("id");
	  if(id in d) {
	    n.textContent = `⬆${ d[id].s } ⬇${ d[id].l }`;
	    n.style.display = "block";
	  }
	});
    }
  };
  r.send();
}

update_torrent_status();
setInterval(update_torrent_status, 10000);
